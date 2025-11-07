USE [InventoryVendor_SampleDB];
GO
--:cd "C:\Users\piles\OneDrive\Documents\Data-Strata\SQL\"  "C:\Users\piles\OneDrive\Documents\Data-Strata\data"

-- ==============================================
-- Script: DataStrata_RefreshAll.sql
-- Description: Master refresh pipeline for the Data-Strata Inventory & Vendor Insights database.
--              Step 1: Reloads base tables from CSV files (Bulkdata_Update.sql)
--              Step 2: Recreates all analytical views (analytical_views_master.sql)
-- Project: Data-Strata Inventory & Vendor Insights
-- Author: Mairilyn Yera Galindo - Pilyla (Data-Strata)
-- Created: 2025-09-08
-- ==============================================

-- ⚠️ IMPORTANT:
-- 1. Update file paths inside BulkUpdate.sql to match your local directory.
-- 2. Ensure your CSVs are saved in /data/ under your project folder.
-- 3. Run this script in SQL Server Management Studio (SSMS) with SQLCMD mode enabled.

PRINT '==============================================';
PRINT 'STEP 1: Loading CSV data into base tables...';
PRINT '==============================================';
:r "C:\Users\piles\OneDrive\Documents\Data-Strata\SQL\data_load\BulkUpdate.sql"   

PRINT '==============================================';
PRINT 'STEP 2: Building analytical views...';
PRINT '==============================================';
:r "C:\Users\piles\OneDrive\Documents\Data-Strata\SQL\create_views_master.sql"

PRINT '==============================================';
PRINT 'REFRESH COMPLETE';
PRINT 'All tables and analytical views have been rebuilt successfully.';
PRINT '==============================================';
GO
