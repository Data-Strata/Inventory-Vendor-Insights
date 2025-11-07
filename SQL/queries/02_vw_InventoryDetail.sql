USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_InventoryDetail
-- Description: Combines inventory quantities with product attributes and cost information.
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

CREATE OR ALTER VIEW dbo.vw_InventoryDetail AS
SELECT
    i.InventoryID,
    i.ProductID,
    p.ProductName,
    p.Category,
    i.Warehouse,
    i.StockQty,
    p.UnitCost,
    CONCAT(i.Warehouse, '-', i.ProductID) AS WarehouseProductKey   -- Create Inventory View with composite key
FROM dbo.Inventory AS i
JOIN dbo.Products AS p
    ON i.ProductID = p.ProductID;
GO
