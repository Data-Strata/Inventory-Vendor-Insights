# 🧮 SQL Layer Documentation — Data-Strata

> Central documentation for all SQL components in the **Data-Strata: Inventory & Vendor Insights Dashboard** project.  
> This layer transforms mock CSV data into a relational schema and reusable analytical views for Power BI.

---

## 🧱 Architecture Overview

The SQL layer contains three levels of logic:

| Layer | Purpose | Key Files |
|--------|----------|-----------|
| **Schema** | Defines normalized tables for raw data ingestion. | `schema/create_tables.sql` |
| **Data Load** | Imports mock CSVs using `BULK INSERT`. | `data_load/BulkUpdate.sql` |
| **Analytical Views** | Aggregates and joins data into clean metrics for BI dashboards. | `queries/*.sql` |

All scripts can be executed sequentially using the **`DataStrata_RefreshAll.sql`** pipeline.

---

## ⚙️ Execution Order

1. **Run the base schema**
   ```sql
   :r .\schema\create_tables.sql
   ```
2. Load mock CSV data
   ```sql
   :r .\data_load\BulkUpdate.sql
   ```
3. Build analytical views
   ```sql
   :r .\create_views_master.sql
   ```
4. (Optional) Rebuild everything at once:
   ```sql
   :r .\DataStrata_RefreshAll.sql
   ```

---

🧩 Analytical Views Reference

| View                         | Purpose / Description                                                                            | Power BI Page                  |
| ---------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------ |
| **vw_ProductCatalog**        | Joins Vendors ↔ Products for a unified lookup table.                                             | Shared reference               |
| **vw_InventoryDetail**       | Combines product, warehouse, and unit cost data to evaluate stock value and efficiency.          | Warehouse Health               |
| **vw_MonthlySales**          | Aggregates sales totals by month (YYYY-MM).                                                      | Overview                       |
| **vw_MonthlySalesWarehouse** | Extends `vw_MonthlySales` by warehouse dimension.                                                | Warehouse Health               |
| **vw_VendorPerformance**     | Evaluates vendor reliability (delivery days, cost variance, on-time %).                          | Vendor Performance             |
| **vw_WarehouseHealth**       | Summarizes stock, turnover, and inventory value by warehouse.                                    | Warehouse Health               |
| **vw_SalesCOGS**             | Calculates Cost of Goods Sold and gross profit metrics.                                          | Category Profit Margin         |
| **vw_CategoryMargin**        | Groups sales and cost data by category to produce profit margin %.                               | Category Profit Margin         |
| **vw_ForecastVsActual**      | Compares forecasted vs actual sales quantities to compute accuracy and MAPE.                     | Forecast Accuracy              |
| **vw_ReorderAlerts**         | Flags low-stock products below reorder level; outputs quantity to reorder and last restock date. | Reorder Alerts                 |
| **vw_DataQualitySummary**    | Provides one-row data quality indicators (forecast accuracy, orphan rows, low stock %, etc.).    | Overview – Data Health Summary |


---

🧮 View Relationships Diagram

Vendors ─┬─> vw_ProductCatalog ─┬─> vw_InventoryDetail
│ ├─> vw_SalesCOGS ─┬─> vw_CategoryMargin
│ ├─> vw_ReorderAlerts
│ └─> vw_VendorPerformance
Inventory ───────────┬─> vw_WarehouseHealth
Sales ───────────────┼─> vw_MonthlySales
└─> vw_MonthlySalesWarehouse
Forecast ────────────└─> vw_ForecastVsActual
vw_DataQualitySummary (standalone QA view)

---

🔍 Data Quality & Validation Scripts

| File                          | Purpose                                                                            |
| ----------------------------- | ---------------------------------------------------------------------------------- |
| **RunOrderedViews.sql**       | Executes all key views in logical order for quick inspection and validation.       |
| **TestDataChecks.sql**        | Verifies referential integrity, missing values, and aggregation sanity checks.     |
| **vw_DataQualitySummary.sql** | Aggregates core QA metrics into one summarized dataset for the Overview dashboard. |


---

📊 Best Practices Applied

-Layered Modeling: Raw → Cleansed → Analytical views for transparency and modularity.

-Reusability: Each view serves as an independent data source for Power BI pages.

-Readability: Consistent naming (vw_ prefix) and clear comments per query.

-Maintainability: One-click rebuild pipeline (DataStrata_RefreshAll.sql).

-Performance: Aggregations pre-calculated in SQL to minimize Power BI load.

---

🧠 Notes & Usage Tips

-All views are created under the dbo schema for simplicity.

-File paths in BulkUpdate.sql must match your local folder structure.

-Use :r (SQLCMD mode) when executing combined scripts.

-You can export or attach the .bak database for demonstration without revealing file paths.

-Each view is modular — you can re-use individual scripts for other inventory or vendor projects.

---

The SQL layer forms the analytical backbone of Data-Strata — transforming CSV inputs into relational intelligence ready for Power BI visualization.