# dbt Cloud + BigQuery Analytics Engineering Portfolio Project

## Overview

This is a small analytics engineering portfolio project built with **dbt Cloud**, **BigQuery** and **GitHub**.

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
                ↓
        BigQuery Conversational Agent
                ↓
    Natural-language analytics and data quality insights
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

Data quality is implemented in two complementary ways:

#### YAML-based dbt tests

Data quality rules are defined in the project’s `.yml` files using dbt schema tests.

These tests validate important model and column-level requirements, such as:

* required fields using `not_null`
* unique identifiers using `unique`
* allowed values using `accepted_values`
* valid references between models using `relationships`

The tests are executed with:

```bash
dbt test
```

or as part of:

```bash
dbt build
```

If a test fails, dbt reports that the corresponding data quality rule has been violated.

#### SQL-based data quality models

The project also includes SQL models that identify and expose individual problematic records.

The `dq_transaction_issues` model stores records with issues such as:

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

This provides two levels of data quality control:

```text
YAML tests
→ validate whether models meet defined data quality requirements

SQL data quality models
→ identify and expose the specific records that require investigation
```

Together, these approaches provide both automated validation and detailed visibility into data quality issues.

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
