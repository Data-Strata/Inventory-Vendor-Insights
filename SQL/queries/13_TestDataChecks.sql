-- ==============================================
-- Script: TestDataChecks.sql
-- Description: Sanity and QA checks for Data-Strata database.
--              Runs quick diagnostics to validate data quality,
--              logical consistency, and metric integrity before
--              loading into Power BI dashboards.
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- 1. Check total row counts by table
-- ==============================================
SELECT 'Vendors' AS TableName, COUNT(*) AS TotalRows FROM dbo.Vendors
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL
SELECT 'Inventory', COUNT(*) FROM dbo.Inventory
UNION ALL
SELECT 'Sales', COUNT(*) FROM dbo.Sales
UNION ALL
SELECT 'Forecasts', COUNT(*) FROM dbo.Forecasts;
GO

-- ==============================================
-- 2. Check for orphaned ProductIDs (exist in Sales but not in Products)
-- ==============================================
SELECT DISTINCT s.ProductID
FROM dbo.Sales AS s
LEFT JOIN dbo.Products AS p ON s.ProductID = p.ProductID
WHERE p.ProductID IS NULL;
GO

-- ==============================================
-- 3. Top 5 Low Stock Items
-- ==============================================
SELECT TOP 5
    i.Warehouse,
    p.ProductName,
    i.StockQty,
    i.ReorderLevel,
    (i.ReorderLevel - i.StockQty) AS UnitsBelowThreshold
FROM dbo.Inventory AS i
JOIN dbo.Products AS p ON i.ProductID = p.ProductID
WHERE i.StockQty < i.ReorderLevel
ORDER BY UnitsBelowThreshold DESC;
GO

-- ==============================================
-- 4. Products with zero or negative sales
-- ==============================================
SELECT
    p.ProductName,
    p.Category,
    SUM(s.Quantity) AS TotalUnitsSold,
    SUM(s.TotalAmount) AS TotalSales
FROM dbo.Products AS p
LEFT JOIN dbo.Sales AS s ON p.ProductID = s.ProductID
GROUP BY p.ProductName, p.Category
HAVING SUM(s.TotalAmount) <= 0 OR SUM(s.Quantity) IS NULL;
GO

-- ==============================================
-- 5. Vendors with negative margins (if joined to vw_CategoryMargin)
-- ==============================================
SELECT
    v.VendorName,
    c.Category,
    c.MarginPct
FROM dbo.vw_CategoryMargin AS c
JOIN dbo.Products AS p ON c.Category = p.Category
JOIN dbo.Vendors AS v ON p.VendorID = v.VendorID
WHERE c.MarginPct < 0
ORDER BY c.MarginPct ASC;
GO

-- ==============================================
-- 6. Forecast Accuracy Outliers (<70% or >130%)
-- ==============================================
SELECT
    f.ForecastMonth,
    p.ProductName,
    f.ForecastQty,
    f.ActualQty,
    CASE
        WHEN f.ForecastQty = 0 THEN NULL
        ELSE ROUND((CAST(f.ActualQty AS DECIMAL(10,2)) / f.ForecastQty) * 100, 2)
    END AS ForecastAccuracyPct
FROM dbo.Forecasts AS f
JOIN dbo.Products AS p ON f.ProductID = p.ProductID
WHERE
    (f.ForecastQty > 0)
    AND (
        ROUND((CAST(f.ActualQty AS DECIMAL(10,2)) / f.ForecastQty) * 100, 2) < 70
        OR ROUND((CAST(f.ActualQty AS DECIMAL(10,2)) / f.ForecastQty) * 100, 2) > 130
    )
ORDER BY ForecastAccuracyPct;
GO
