# dbt + BigQuery Analytics Engineering Portfolio Project

## Overview

This is a small analytics engineering portfolio project built with **dbt**, **BigQuery** and **GitHub**.

The project demonstrates an end-to-end analytics engineering workflow where raw customer and transaction data is loaded into BigQuery, cleaned and transformed with dbt, tested, and prepared into reporting-ready analytical marts, while a separate data quality layer captures duplicates, missing keys, invalid dates and other problematic records.

Data workflow:

```text
CSV seed data
    ↓
BigQuery raw tables
    ↓
dbt staging models
    ↓
    ├── analytical marts
    │       ├── mart_customer_transactions
    │       └── mart_monthly_transaction_summary
    │
    └── data quality issue detection layer
            └── dq_transaction_issues
```

## The project includes:

- sample customer and transaction data
- dbt seed files loaded into BigQuery
- staging models for cleaning and type casting
- analytical marts for customer and monthly transaction analysis
- schema tests and documentation
- a dedicated data quality model for identifying problematic records
- GitHub version control

## Data Flow
### 1. Seed Data

The project starts with two CSV files:

```
seeds/customers.csv
seeds/transactions.csv
```
These files are loaded into BigQuery using:
```
dbt seed --full-refresh
```
The seed files simulate raw source data.

### 2. Staging Layer

The staging models clean and standardise the raw data.
```
models/staging/stg_customers.sql
models/staging/stg_transactions.sql
```
The staging layer performs:

- trimming of text fields
- conversion of empty strings to NULL
- safe casting of dates and numeric values
- preservation of raw values for auditability

Example logic:
```
safe_cast(nullif(trim(transaction_date), '') as date) as transaction_date
```
This ensures that invalid dates do not break the pipeline. Instead, they are converted to NULL and captured later in the data quality layer.

### 3. Analytical Marts

The marts layer creates business-friendly analytical tables.
```
models/marts/mart_customer_transactions.sql
models/marts/mart_monthly_transaction_summary.sql
```
Customer-level transaction summary including:

- transaction count
- total transaction amount
- average transaction amount
- customer value segment
- mart_monthly_transaction_summary

Monthly transaction summary by transaction type including:

- transaction month
- transaction type
- transaction count
- total transaction amount
- average transaction amount

The marts use only valid transactions, while invalid records are handled separately in the data quality layer.

### 4. Data Quality Layer

The model below identifies transaction records with data quality issues:
```
models/quality/dq_transaction_issues.sql
```
It detects:

- missing transaction IDs
- duplicate transaction IDs
- missing customer IDs
- orphan customer references
- missing transaction dates
- invalid transaction dates
- missing amounts
- negative amounts
- zero amounts
- invalid transaction types
- high-value transactions requiring review

This separates analytical reporting from data quality monitoring.

## What This Project Demonstrates

This project demonstrates practical knowledge of:

- analytics engineering
- dbt project structure
- BigQuery as a cloud data warehouse
- SQL transformations
- staging and mart modelling
- building reporting-ready analytical marts
- BI and reporting layer design
- BigQuery conversational agent setup
- data quality checks and issue detection
- schema testing
- GitHub version control
- data pipeline thinking

## How to run the full dbt workflow

```bash
dbt seed
dbt build
dbt docs generate
```
## How BigQuery Is Used

BigQuery is used as the cloud data warehouse for this project.

The dbt project connects to BigQuery through a dbt Cloud environment. The actual BigQuery credentials and connection settings are managed securely in dbt Cloud and are not stored in this GitHub repository.

When the project is run, dbt executes SQL models against BigQuery and creates the following tables/views in the target BigQuery dataset:

```text
BigQuery project: alien-lattice-501815-p1
BigQuery dataset: dbt_avissor
```
