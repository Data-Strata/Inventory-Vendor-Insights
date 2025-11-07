USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_ReorderAlerts
-- Description: What to reorder, where, and by how much.
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================


IF OBJECT_ID('dbo.vw_ReorderAlerts','V') IS NOT NULL DROP VIEW dbo.vw_ReorderAlerts;
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
FROM dbo.Inventory i
JOIN dbo.vw_ProductCatalog pc ON pc.ProductID = i.ProductID
WHERE i.StockQty < i.ReorderLevel;