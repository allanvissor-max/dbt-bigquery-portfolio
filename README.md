# dbt + BigQuery Analytics Engineering Portfolio Project

## Overview

This is a small analytics engineering portfolio project built with **dbt**, **BigQuery** and **GitHub**.

The project demonstrates how raw transaction and customer data can be loaded, cleaned, transformed, tested and monitored for data quality issues.

The goal is to show a realistic data workflow:

```text
CSV seed data
    ↓
BigQuery raw tables
    ↓
dbt staging models
    ↓
analytical marts
    ↓
data quality issue detection layer
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
- data quality checks
- schema testing
- GitHub version control
- basic data pipeline thinking
