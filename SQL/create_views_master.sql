-- =============================================
-- 🧮 Data-Strata: Create Analytical Views
-- Description: Rebuilds all analytical views
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- =============================================

-- Enable this script in SQLCMD mode
-- Usage:
-- :r .\create_views_master.sql
-- =============================================

USE [InventoryVendor_SampleDB];
GO

PRINT 'Rebuilding Data-Strata analytical views...';
GO

-- ========================================================
-- 1. Product Catalog View
-- ========================================================
IF OBJECT_ID('dbo.vw_ProductCatalog', 'V') IS NOT NULL DROP VIEW dbo.vw_ProductCatalog;
GO
CREATE VIEW dbo.vw_ProductCatalog AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    v.VendorName,
    v.Region,
    v.DeliveryTimeDays,
    v.ContactEmail
FROM dbo.Products AS p
JOIN dbo.Vendors AS v
    ON p.VendorID = v.VendorID;
GO

-- ========================================================
-- 2. Inventory Detail View
-- ========================================================
IF OBJECT_ID('dbo.vw_InventoryDetail', 'V') IS NOT NULL DROP VIEW dbo.vw_InventoryDetail;
GO
CREATE VIEW dbo.vw_InventoryDetail AS
SELECT
    i.InventoryID,
    i.ProductID,
    i.Warehouse,
    i.StockQty,
    i.ReorderLevel,
    i.LastRestockDate,
    p.UnitCost,
    p.UnitPrice,
    p.ProductName,
    p.Category,
    p.VendorID
FROM dbo.Inventory AS i
JOIN dbo.Products AS p
    ON i.ProductID = p.ProductID;
GO

-- ========================================================
-- 3. Monthly Sales View
-- ========================================================
IF OBJECT_ID('dbo.vw_MonthlySales', 'V') IS NOT NULL DROP VIEW dbo.vw_MonthlySales;
GO
CREATE VIEW dbo.vw_MonthlySales AS
SELECT
    CONVERT(CHAR(7), s.SaleDate, 126) AS YearMonth,
    SUM(s.TotalAmount) AS MonthlySales
FROM dbo.Sales AS s
GROUP BY CONVERT(CHAR(7), s.SaleDate, 126);
GO

-- ========================================================
-- 4. Monthly Sales by Warehouse
-- ========================================================
IF OBJECT_ID('dbo.vw_MonthlySalesWarehouse', 'V') IS NOT NULL DROP VIEW dbo.vw_MonthlySalesWarehouse;
GO
CREATE VIEW dbo.vw_MonthlySalesWarehouse AS
SELECT
    i.Warehouse,
    CONVERT(CHAR(7), s.SaleDate, 126) AS YearMonth,
    SUM(s.TotalAmount) AS MonthlySales
FROM dbo.Sales AS s
JOIN dbo.Inventory AS i
    ON s.ProductID = i.ProductID
GROUP BY i.Warehouse, CONVERT(CHAR(7), s.SaleDate, 126);
GO

-- ========================================================
-- 5. Vendor Performance
-- ========================================================
IF OBJECT_ID('dbo.vw_VendorPerformance', 'V') IS NOT NULL DROP VIEW dbo.vw_VendorPerformance;
GO
CREATE VIEW dbo.vw_VendorPerformance AS
SELECT
    v.VendorID,
    v.VendorName,
    v.Region,
    COUNT(p.ProductID) AS ProductCount,
    AVG(v.DeliveryTimeDays) AS AvgDeliveryDays
FROM dbo.Vendors AS v
LEFT JOIN dbo.Products AS p
    ON v.VendorID = p.VendorID
GROUP BY v.VendorID, v.VendorName, v.Region;
GO

-- ========================================================
-- 6. Warehouse Health
-- ========================================================
IF OBJECT_ID('dbo.vw_WarehouseHealth', 'V') IS NOT NULL DROP VIEW dbo.vw_WarehouseHealth;
GO
CREATE VIEW dbo.vw_WarehouseHealth AS
SELECT
    i.Warehouse,
    COUNT(i.ProductID) AS TotalProducts,
    SUM(i.StockQty * p.UnitCost) AS InventoryValue,
    SUM(i.StockQty) AS TotalStockQty,
    AVG(i.ReorderLevel) AS AvgReorderLevel
FROM dbo.Inventory AS i
JOIN dbo.Products AS p
    ON i.ProductID = p.ProductID
GROUP BY i.Warehouse;
GO

-- ========================================================
-- 7. Forecast vs Actual
-- ========================================================
IF OBJECT_ID('dbo.vw_ForecastVsActual', 'V') IS NOT NULL DROP VIEW dbo.vw_ForecastVsActual;
GO
CREATE VIEW dbo.vw_ForecastVsActual AS
SELECT
    f.ForecastMonth,
    f.ProductID,
    p.ProductName,
    p.Category,
    f.ForecastQty,
    f.ActualQty,
    CASE
        WHEN f.ForecastQty = 0 THEN NULL
        ELSE ROUND(100.0 * (1 - ABS(f.ActualQty - f.ForecastQty) / f.ForecastQty), 2)
    END AS ForecastAccuracyPct
FROM dbo.Forecasts AS f
JOIN dbo.Products AS p
    ON f.ProductID = p.ProductID;
GO

-- ========================================================
-- 8. Sales COGS
-- ========================================================
IF OBJECT_ID('dbo.vw_SalesCOGS', 'V') IS NOT NULL DROP VIEW dbo.vw_SalesCOGS;
GO
CREATE VIEW dbo.vw_SalesCOGS AS
SELECT
    s.ProductID,
    p.ProductName,
    p.Category,
    SUM(s.Quantity) AS UnitsSold,
    SUM(s.TotalAmount) AS TotalSales,
    SUM(s.Quantity * p.UnitCost) AS TotalCost,
    SUM(s.TotalAmount - (s.Quantity * p.UnitCost)) AS TotalProfit
FROM dbo.Sales AS s
JOIN dbo.Products AS p
    ON s.ProductID = p.ProductID
GROUP BY s.ProductID, p.ProductName, p.Category;
GO

-- ========================================================
-- 9. Category Margin
-- ========================================================
IF OBJECT_ID('dbo.vw_CategoryMargin', 'V') IS NOT NULL DROP VIEW dbo.vw_CategoryMargin;
GO
CREATE VIEW dbo.vw_CategoryMargin AS
SELECT
    p.Category,
    SUM(s.TotalAmount) AS TotalSales,
    SUM(s.Quantity * p.UnitCost) AS TotalCost,
    SUM(s.TotalAmount - (s.Quantity * p.UnitCost)) AS TotalProfit,
    ROUND(
        (SUM(s.TotalAmount - (s.Quantity * p.UnitCost)) / NULLIF(SUM(s.TotalAmount), 0)) * 100, 2
    ) AS MarginPct
FROM dbo.Sales AS s
JOIN dbo.Products AS p
    ON s.ProductID = p.ProductID
GROUP BY p.Category;
GO

-- ========================================================
-- 10. Reorder Alerts
-- ========================================================
IF OBJECT_ID('dbo.vw_ReorderAlerts', 'V') IS NOT NULL DROP VIEW dbo.vw_ReorderAlerts;
GO
CREATE VIEW dbo.vw_ReorderAlerts AS
SELECT
    i.Warehouse,
    pc.ProductID,
    pc.ProductName,
    pc.Category,
    pc.VendorName,
    i.StockQty,
    i.ReorderLevel,
    (i.ReorderLevel - i.StockQty) AS UnitsToReorder,
    i.LastRestockDate
FROM dbo.Inventory AS i
JOIN dbo.vw_ProductCatalog AS pc
    ON pc.ProductID = i.ProductID
WHERE i.StockQty < i.ReorderLevel;
GO

-- ========================================================
-- 11. Data Quality Summary
-- ========================================================
IF OBJECT_ID('dbo.vw_DataQualitySummary', 'V') IS NOT NULL DROP VIEW dbo.vw_DataQualitySummary;
GO
CREATE VIEW dbo.vw_DataQualitySummary AS
SELECT
    (SELECT COUNT(*) FROM dbo.Sales) AS TotalSalesRecords,
    (SELECT COUNT(*) FROM dbo.Products) AS TotalProducts,
    (SELECT COUNT(*) FROM dbo.Inventory WHERE StockQty < ReorderLevel) AS LowStockItems,
    (SELECT ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM dbo.Inventory), 0), 2)
        FROM dbo.Inventory WHERE StockQty < ReorderLevel) AS LowStockPct,
    (SELECT ROUND(AVG(
        CASE
            WHEN ForecastQty = 0 THEN NULL
            ELSE 100.0 * (1 - ABS(ActualQty - ForecastQty) / ForecastQty)
        END), 2)
     FROM dbo.Forecasts) AS AvgForecastAccuracy
;
GO

PRINT 'All Data-Strata analytical views created successfully.';
GO
