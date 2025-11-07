USE [InventoryVendor_SampleDB];
GO

-- ==============================================
-- Script: create_tables.sql
-- Description: Base schema for the Data-Strata project.
--              Creates Vendors, Products, Inventory, Sales, and Forecasts tables.
-- Note: Designed for Microsoft SQL Server 2019+.
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

-- ==============================================
-- 1. Vendors Table
-- ==============================================
IF OBJECT_ID('dbo.Vendors','U') IS NOT NULL DROP TABLE dbo.Vendors;
GO

CREATE TABLE dbo.Vendors (
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    VendorName NVARCHAR(100) NOT NULL,
    Region NVARCHAR(100),
    DeliveryTimeDays INT,
    ContactEmail NVARCHAR(100)
);
GO

-- ==============================================
-- 2. Products Table
-- ==============================================
IF OBJECT_ID('dbo.Products','U') IS NOT NULL DROP TABLE dbo.Products;
GO

CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(100),
    VendorID INT,
    UnitCost DECIMAL(10,2),
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (VendorID) REFERENCES dbo.Vendors(VendorID)
);
GO

-- ==============================================
-- 3. Inventory Table
-- ==============================================
IF OBJECT_ID('dbo.Inventory','U') IS NOT NULL DROP TABLE dbo.Inventory;
GO

CREATE TABLE dbo.Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Warehouse NVARCHAR(100),
    StockQty INT,
    ReorderLevel INT,
    LastRestockDate DATE,
    FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO

-- ==============================================
-- 4. Sales Table
-- ==============================================
IF OBJECT_ID('dbo.Sales','U') IS NOT NULL DROP TABLE dbo.Sales;
GO

CREATE TABLE dbo.Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Warehouse NVARCHAR(100),
    SaleDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalAmount AS (Quantity * UnitPrice) PERSISTED,
    FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO

-- ==============================================
-- 5. Forecasts Table
-- ==============================================
IF OBJECT_ID('dbo.Forecasts','U') IS NOT NULL DROP TABLE dbo.Forecasts;
GO

CREATE TABLE dbo.Forecasts (
    ForecastID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ForecastMonth CHAR(7),  -- e.g., 2025-09
    ForecastQty INT,
    ActualQty INT,
    FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO
