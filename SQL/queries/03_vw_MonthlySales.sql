USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_MonthlySales
-- Description: Aggregates total monthly sales across all warehouses.
--              Serves as the base dataset for monthly sales trend,
--              YTD calculations, and MoM % change in Power BI.
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

IF OBJECT_ID('dbo.vw_MonthlySales','V') IS NOT NULL 
    DROP VIEW dbo.vw_MonthlySales;
GO

CREATE VIEW dbo.vw_MonthlySales AS
SELECT
    CONVERT(char(7), s.SaleDate, 126) AS YearMonth,  -- e.g., 2025-09
    SUM(s.TotalAmount) AS MonthlySales
FROM dbo.Sales AS s
GROUP BY
    CONVERT(char(7), s.SaleDate, 126);
GO
