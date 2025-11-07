-- ==============================================
-- View: vw_DataQualitySummary
-- Description: Provides summarized data-quality KPIs for the
--              Data-Strata project — counts and ratios useful for
--              monitoring database health and data integrity.
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================
USE [InventoryVendor_SampleDB];
GO


IF OBJECT_ID('dbo.vw_DataQualitySummary','V') IS NOT NULL
    DROP VIEW dbo.vw_DataQualitySummary;
GO

CREATE VIEW dbo.vw_DataQualitySummary AS
WITH
-- ----------------------------------------------
-- 1. Base table counts
-- ----------------------------------------------
Counts AS (
    SELECT
        (SELECT COUNT(*) FROM dbo.Vendors)    AS VendorsCount,
        (SELECT COUNT(*) FROM dbo.Products)   AS ProductsCount,
        (SELECT COUNT(*) FROM dbo.Inventory)  AS InventoryCount,
        (SELECT COUNT(*) FROM dbo.Sales)      AS SalesCount,
        (SELECT COUNT(*) FROM dbo.Forecasts)  AS ForecastsCount
),

-- ----------------------------------------------
-- 2. Orphan checks
-- ----------------------------------------------
Orphans AS (
    SELECT
        (SELECT COUNT(DISTINCT s.ProductID)
         FROM dbo.Sales s
         LEFT JOIN dbo.Products p ON s.ProductID = p.ProductID
         WHERE p.ProductID IS NULL) AS OrphanSalesProducts
),

-- ----------------------------------------------
-- 3. Low-stock items
-- ----------------------------------------------
LowStock AS (
    SELECT
        COUNT(*) AS LowStockCount,
        ROUND(
            100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM dbo.Inventory),0),
            2
        ) AS LowStockPct
    FROM dbo.Inventory
    WHERE StockQty < ReorderLevel
),

-- ----------------------------------------------
-- 4. Zero or negative sales
-- ----------------------------------------------
ZeroSales AS (
    SELECT
        COUNT(*) AS ZeroSalesProducts
    FROM (
        SELECT p.ProductID
        FROM dbo.Products p
        LEFT JOIN dbo.Sales s ON p.ProductID = s.ProductID
        GROUP BY p.ProductID
        HAVING SUM(ISNULL(s.TotalAmount,0)) <= 0
    ) t
),

-- ----------------------------------------------
-- 5. Forecast accuracy metrics
-- ----------------------------------------------
ForecastStats AS (
    SELECT
        ROUND(
            AVG(
                CASE
                    WHEN f.ForecastQty > 0 THEN
                        ABS(1 - (CAST(f.ActualQty AS DECIMAL(10,2)) / f.ForecastQty)) * 100
                    ELSE NULL
                END
            ), 2
        ) AS AvgMAPE,
        ROUND(
            AVG(
                CASE
                    WHEN f.ForecastQty > 0 THEN
                        (CAST(f.ActualQty AS DECIMAL(10,2)) / f.ForecastQty) * 100
                    ELSE NULL
                END
            ), 2
        ) AS AvgForecastAccuracy
    FROM dbo.Forecasts f
)

-- ----------------------------------------------
-- Final SELECT — single-row summary
-- ----------------------------------------------
SELECT
    c.VendorsCount,
    c.ProductsCount,
    c.InventoryCount,
    c.SalesCount,
    c.ForecastsCount,
    o.OrphanSalesProducts,
    l.LowStockCount,
    l.LowStockPct,
    z.ZeroSalesProducts,
    f.AvgMAPE,
    f.AvgForecastAccuracy
FROM Counts c
CROSS JOIN Orphans o
CROSS JOIN LowStock l
CROSS JOIN ZeroSales z
CROSS JOIN ForecastStats f;
GO
