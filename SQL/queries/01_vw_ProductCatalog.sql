USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_ProductCatalog
-- Description: Joins Products <-> Vendors for easy reuse across other views and dashboards.
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

IF OBJECT_ID('dbo.vw_ProductCatalog','V') IS NOT NULL DROP VIEW dbo.vw_ProductCatalog;
GO

CREATE VIEW dbo.vw_ProductCatalog AS
SELECT
  p.ProductID,
  p.ProductName,
  p.Category,
  p.UnitCost,
  p.UnitPrice,
  v.VendorID,
  v.VendorName,
  v.Region,
  v.DeliveryTimeDays
FROM dbo.Products p
JOIN dbo.Vendors  v ON v.VendorID = p.VendorID;
GO