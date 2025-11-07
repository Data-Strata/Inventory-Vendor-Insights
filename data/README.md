# 📦 Data Folder — Sample Datasets

This folder contains all **mock CSV files** used to populate the base tables of the  
**Data-Strata: Inventory & Vendor Insights Dashboard** project.

Each dataset is intentionally simplified but realistic — modeled after a mid-size HVAC parts and supplies distributor.  
These files are loaded into SQL Server via `/SQL/data_load/BulkUpdate.sql` before building the analytical views.

---

## 📁 File Overview

| File | Table Target | Purpose / Key Fields |
|------|---------------|----------------------|
| **vendors.csv** | `Vendors` | Master list of product suppliers, including `VendorName`, `Region`, `DeliveryTimeDays`, and `ContactEmail`. |
| **products.csv** | `Products` | Catalog of all SKUs sold, linked to `VendorID`; includes category, unit cost, and unit price. |
| **inventory.csv** | `Inventory` | Current stock levels by warehouse, reorder thresholds, and last restock dates. |
| **sales.csv** | `Sales` | Historical sales transactions with product ID, quantity, total amount, and sale date. |
| **forecasts.csv** | `Forecasts` | Monthly demand projections and actual quantities, used for forecast accuracy KPIs. |

---

## 🧱 Data Relationships

Vendors ──┬──> Products ───┬──> Inventory
│ ├──> Sales
│ └──> Forecasts


Each file contains a `ProductID` or `VendorID` key field so that relationships can be recreated automatically once data is imported.

---

## ⚙️ Usage

1. Verify that all five CSVs are saved in this `/data/` folder.
2. Update the **file paths** inside `/SQL/data_load/BulkUpdate.sql` if needed:
   ```sql
   FROM 'C:\Users\<YourName>\Documents\Data-Strata\data\vendors.csv'
3. Run the following in SSMS:
   ```sql
   :r .\SQL\data_load\BulkUpdate.sql
4. Confirm that tables contain data with simple checks:
   ```sql
   SELECT COUNT(*) FROM Vendors;
   SELECT COUNT(*) FROM Sales;

---

💡 Notes

All files use comma-separated values (CSV) with headers in the first row.

Character encoding: ANSI / Windows-1252 (default for BULK INSERT).

If your CSVs are edited in Excel, ensure numeric columns use . as the decimal separator.

Data is fictional and provided for educational and demonstration purposes only.

---

## 🧾 License

This project is licensed under the [MIT License](LICENSE).

---

## ✍️ Author

**Mairilyn Yera Galindo (Pilyla)**  
*Data-Strata Project — 2025*  
🌐 [https://github.com/pilylay/Data-Strata](https://github.com/pilylay/Data-Strata)

