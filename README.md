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
data quality issue detection layer```

## The project includes:

sample customer and transaction data
dbt seed files loaded into BigQuery
staging models for cleaning and type casting
analytical marts for customer and monthly transaction analysis
schema tests and documentation
a dedicated data quality model for identifying problematic records
GitHub version control
