USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_ForecastVsActual
-- Description: Compares forecasted vs actual sales for accuracy metrics.
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

-- Forecast vs actual (with accuracy): Side-by-side forecast/actual plus accuracy %.

IF OBJECT_ID('dbo.vw_ForecastVsActual','V') IS NOT NULL DROP VIEW dbo.vw_ForecastVsActual;
GO
CREATE VIEW dbo.vw_ForecastVsActual AS
SELECT
  f.ForecastMonth,            -- 'YYYY-MM'
  pc.ProductID,
  pc.ProductName,
  pc.Category,
  SUM(f.ForecastQty) AS ForecastQty,
  SUM(f.ActualQty)   AS ActualQty,
  CAST(ROUND(
    100.0 * (1 - ABS(SUM(f.ForecastQty) - SUM(f.ActualQty)) / NULLIF(SUM(f.ForecastQty),0)), 2
  ) AS DECIMAL(6,2)) AS ForecastAccuracyPct
FROM dbo.Forecasts f
JOIN dbo.vw_ProductCatalog pc ON pc.ProductID = f.ProductID
GROUP BY f.ForecastMonth, pc.ProductID, pc.ProductName, pc.Category;
GO
