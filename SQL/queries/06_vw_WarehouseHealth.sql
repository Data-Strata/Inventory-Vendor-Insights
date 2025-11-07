USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_WarehouseHealth
-- Description: Summarizes inventory turnover and warehouse efficiency KPIs.
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

IF OBJECT_ID('dbo.vw_WarehouseHealth','V') IS NOT NULL DROP VIEW dbo.vw_WarehouseHealth;
GO
CREATE VIEW dbo.vw_WarehouseHealth AS
SELECT
    i.Warehouse,
    COUNT(DISTINCT i.ProductID)                      AS ProductCount,
    SUM(i.StockQty)                                  AS TotalUnitsInStock,
    SUM(i.StockQty * p.UnitCost)                     AS StockValue,
    SUM(CASE WHEN i.StockQty < i.ReorderLevel THEN 1 ELSE 0 END) AS BelowReorderCount,
    CAST(AVG(DATEDIFF(DAY, i.LastRestockDate, GETDATE())) AS DECIMAL(5,1)) AS AvgDaysSinceRestock
FROM dbo.Inventory i
JOIN dbo.Products p ON i.ProductID = p.ProductID
GROUP BY i.Warehouse;
GO
