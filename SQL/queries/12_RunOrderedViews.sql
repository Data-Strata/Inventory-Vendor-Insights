USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- Script: RunOrderedViews.sql
-- Description: Executes all analytical views in order, returning
--              their key metrics sorted for quick validation and review.
-- Purpose: Used to verify that each view produces expected results
--          before connecting to Power BI dashboards.
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

-- ==============================================
-- 1. Vendor Performance
-- ==============================================
SELECT * FROM dbo.vw_VendorPerformance ORDER BY TotalSales DESC;
GO

-- ==============================================
-- 2. Reorder Alerts
-- ==============================================
SELECT *
FROM dbo.vw_ReorderAlerts
ORDER BY Warehouse, Category, ProductName;
GO

-- ==============================================
-- 3. Monthly Sales
-- ==============================================
SELECT * FROM dbo.vw_MonthlySales ORDER BY YearMonth;
GO

-- ==============================================
-- 4. Forecast vs Actual
-- ==============================================
SELECT * FROM dbo.vw_ForecastVsActual
ORDER BY ForecastMonth, ForecastAccuracyPct DESC;
GO

-- ==============================================
-- 5. Category Margin
-- ==============================================
SELECT * FROM dbo.vw_CategoryMargin ORDER BY MarginPct DESC;
GO


