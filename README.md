## Project overview

This project demonstrates a dbt analytics engineering workflow on BigQuery.

Data flow:

seeds → staging → marts → quality

## Key features

- CSV seed data loaded into BigQuery
- staging models for cleaning and type casting
- customer-level transaction mart
- data quality model for detecting invalid records
- dbt schema tests and documentation
