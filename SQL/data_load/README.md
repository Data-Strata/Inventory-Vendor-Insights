# 🧩 Data Load Script — BulkUpdate.sql

> Refreshes all base SQL tables from the mock CSV datasets stored under `/data/`.  
> Use this script before running the analytical view builds whenever your CSVs change.

---

## ⚙️ Overview

The `BulkUpdate.sql` script automates loading CSV files into SQL Server using the `BULK INSERT` command.  
It truncates each table, reloads data from the latest CSVs, and locks tables during the operation for speed and integrity.

| Table | Source CSV | Description |
|--------|-------------|-------------|
| `Vendors` | `data/vendors.csv` | Vendor info and delivery metrics |
| `Products` | `data/products.csv` | Product catalog linked to vendors |
| `Inventory` | `data/inventory.csv` | Stock quantities and warehouse data |
| `Sales` | `data/sales.csv` | Transactional sales records |
| `Forecasts` | `data/forecasts.csv` | Forecasted vs actual demand data |

---

## 🧱 Prerequisites

- **Enable SQLCMD mode** in SQL Server Management Studio (SSMS).  
  *(Query → SQLCMD Mode)*  
- Make sure all CSVs exist locally in the `/data/` folder.  
- Each file must use **UTF-8 encoding**, commas as delimiters, and include a header row.  

---

## 🚀 Usage

```sql
-- 1. Load all mock data into base tables
:r .\data_load\BulkUpdate.sql

-- 2. Rebuild all analytical views (optional)
:r .\create_views_master.sql
```

💡 Run both scripts in SQLCMD mode to refresh the complete database pipeline.

---
🧭 File Path Configuration

Each BULK INSERT command uses an absolute file path.
Edit these paths to match your local environment before execution:

```sql
BULK INSERT Vendors
FROM 'C:\Users\<YourName>\Documents\Data-Strata\data\vendors.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);
```

Keep paths inside single quotes '...'

Use double backslashes \\ if executing through other clients like Azure Data Studio

---

⚠ Notes

This script truncates all base tables before loading new data.
❌ Do not use it in production databases.

The script assumes the database InventoryVendor_SampleDB already exists.

Designed for development and demonstration purposes only — not a production ETL workflow.

---

BulkUpdate.sql forms the foundation of the Data-Strata refresh workflow — enabling quick, repeatable database resets for testing and development.