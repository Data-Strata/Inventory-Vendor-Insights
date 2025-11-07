USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_CategoryMargin
-- Description: Aggregates profitability and margin percentage by product category.
--              Uses vw_SalesCOGS as source to calculate Total Sales, Total Cost,
--              Profit, and Profit Margin % for category-level insights.
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

IF OBJECT_ID('dbo.vw_CategoryMargin','V') IS NOT NULL
    DROP VIEW dbo.vw_CategoryMargin;
GO

CREATE VIEW dbo.vw_CategoryMargin AS
SELECT
    sc.Category,
    SUM(sc.SalesAmount) AS TotalSales,
    SUM(sc.COGS) AS TotalCost,
    SUM(sc.Profit) AS Profit,
    CASE
        WHEN SUM(sc.SalesAmount) = 0 THEN NULL
        ELSE ROUND(SUM(sc.Profit) / SUM(sc.SalesAmount) * 100, 2)
    END AS ProfitMarginPct
FROM dbo.vw_SalesCOGS AS sc
GROUP BY
    sc.Category;
GO
