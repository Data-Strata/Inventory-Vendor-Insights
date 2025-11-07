### 🧩 RunOrderedViews.sql

A helper script that queries each analytical view in logical order to verify data accuracy and inspect KPIs before loading into Power BI.

**Usage:**
```sql
:r .\queries\RunOrderedViews.sql


### 🧪 TestDataChecks.sql

A quick QA script that verifies data quality and consistency before building reports.  
Includes sanity checks for orphan records, stock anomalies, sales outliers, and forecast deviations.

**Usage:**
```sql
:r .\queries\TestDataChecks.sql

