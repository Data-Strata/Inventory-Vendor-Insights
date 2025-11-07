USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_SalesCOGS
-- Description: Calculates Cost of Goods Sold and profit per product
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================



CREATE OR ALTER VIEW dbo.vw_SalesCOGS AS
SELECT
    FORMAT(s.SaleDate, 'yyyy-MM') AS YearMonth,
    i.Warehouse,
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(s.Quantity) AS SoldQty,
    SUM(s.Quantity * p.UnitPrice) AS SalesAmount,
    SUM(s.Quantity * p.UnitCost)  AS COGS,
    SUM(s.Quantity * p.UnitPrice) - SUM(s.Quantity * p.UnitCost) AS Profit,
    CONCAT(i.Warehouse, '-', p.ProductID) AS WarehouseProductKey
FROM dbo.Sales AS s
JOIN dbo.Products AS p
    ON s.ProductID = p.ProductID
JOIN dbo.Inventory AS i
    ON s.ProductID = i.ProductID
GROUP BY
    FORMAT(s.SaleDate, 'yyyy-MM'),
    i.Warehouse,
    p.ProductID,
    p.ProductName,
    p.Category;
