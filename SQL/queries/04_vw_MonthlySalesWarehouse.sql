USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_MonthlySalesWarehouse
-- Description: Aggregates total monthly sales by warehouse and product.
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================


CREATE OR ALTER VIEW dbo.vw_MonthlySalesWarehouse AS
SELECT
    FORMAT(s.SaleDate, 'yyyy-MM') AS YearMonth,
    i.Warehouse,
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(s.TotalAmount) AS MonthlySales,
    CONCAT(i.Warehouse, '-', p.ProductID) AS WarehouseProductKey
FROM dbo.Sales AS s
JOIN dbo.Inventory AS i ON s.ProductID = i.ProductID
JOIN dbo.Products  AS p ON s.ProductID = p.ProductID
GROUP BY
    FORMAT(s.SaleDate, 'yyyy-MM'),
    i.Warehouse, p.ProductID, p.ProductName, p.Category;
GO