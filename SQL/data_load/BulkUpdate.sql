Use [InventoryVendor_SampleDB]; -- path to flat files ''C:\Users\piles\OneDrive\Documents\Data-Strata\data\'


-- ==============================================
-- Script: BulkUpdate.sql
-- Description: Reloads all base tables (Vendors, Products, Inventory,
--              Sales, Forecasts) from local CSV files under /data.
--              Used for quick reseeding of the Data-Strata sample database.
-- Author: Pilyla Y.
-- Project: Data-Strata Inventory & Vendor Insights
-- Created: 2025-10-26
-- ==============================================

-- ⚠️ Note: Adjust file paths before running in your environment.
-- ==============================================


-- ================================
-- 1. Vendors
-- ================================
TRUNCATE TABLE Vendors;

BULK INSERT Vendors
FROM 'C:\Users\piles\OneDrive\Documents\Data-Strata\data\vendors.csv' 
WITH (
    FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);

-- ================================
-- 2. Products
-- ================================

BULK INSERT Products
FROM 'C:\Users\piles\OneDrive\Documents\Data-Strata\data\products.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);

-- ================================
-- 3. Inventory
-- ================================
TRUNCATE TABLE Inventory;

BULK INSERT Inventory
FROM 'C:\Users\piles\OneDrive\Documents\Data-Strata\data\inventory.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);

-- ================================
-- 4. Sales
-- ================================
TRUNCATE TABLE Sales;

BULK INSERT Sales
FROM 'C:\Users\piles\OneDrive\Documents\Data-Strata\data\sales.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);

    -- ================================
-- 5. Forecasts
-- ================================
TRUNCATE TABLE Forecasts;

BULK INSERT Forecasts
FROM 'C:\Users\piles\OneDrive\Documents\Data-Strata\data\forecasts.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);
