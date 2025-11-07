USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- View: vw_VendorPerformance
-- Description: Joins Products <-> Vendors <-> Sales to evaluates vendor reliability and average delivery times.
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

IF OBJECT_ID('dbo.vw_VendorPerformance','V') IS NOT NULL
    DROP VIEW dbo.vw_VendorPerformance;
GO

CREATE VIEW dbo.vw_VendorPerformance AS
SELECT
    v.VendorID,
    v.VendorName,
    COUNT(DISTINCT p.ProductID) AS ProductCount,
    SUM(s.TotalAmount) AS TotalSales,
    CAST(
        SUM(s.TotalAmount) * 100.0 / 
        (SELECT SUM(TotalAmount) FROM Sales)
        AS DECIMAL(5,2)
    ) AS SalesSharePercent,
    -- 🔹 Calculate average delivery days
    CAST(AVG(DATEDIFF(DAY, s.SaleDate, s.DeliveryDate)) AS DECIMAL(5,2)) AS AvgDeliveryDays
FROM dbo.Vendors v
JOIN dbo.Products p ON v.VendorID = p.VendorID
JOIN dbo.Sales s    ON p.ProductID = s.ProductID
GROUP BY v.VendorID, v.VendorName;
GO
