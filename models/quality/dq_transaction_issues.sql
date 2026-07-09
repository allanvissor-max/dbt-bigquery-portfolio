with transactions as (
    select *
    from {{ ref('stg_transactions') }}
),

customers as (
    select *
    from {{ ref('stg_customers') }}
),

duplicate_transactions as (
    select transaction_id
    from transactions
    where transaction_id is not null
    group by transaction_id
    having count(*) > 1
)

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'MISSING_TRANSACTION_ID' as issue_type
from transactions
where transaction_id is null

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'DUPLICATE_TRANSACTION_ID' as issue_type
from transactions
where transaction_id in (
    select transaction_id
    from duplicate_transactions
)

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'MISSING_CUSTOMER_ID' as issue_type
from transactions
where customer_id is null

union all

select
    t.transaction_id,
    t.customer_id,
    t.transaction_date_raw,
    t.amount_eur_raw,
    t.transaction_type,
    'ORPHAN_CUSTOMER_ID' as issue_type
from transactions t
left join customers c
    on t.customer_id = c.customer_id
where t.customer_id is not null
  and c.customer_id is null

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'MISSING_TRANSACTION_DATE' as issue_type
from transactions
where transaction_date_raw is null

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'INVALID_TRANSACTION_DATE' as issue_type
from transactions
where transaction_date_raw is not null
  and transaction_date is null

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'MISSING_AMOUNT' as issue_type
from transactions
where amount_eur_raw is null

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'NEGATIVE_AMOUNT' as issue_type
from transactions
where amount_eur < 0

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'ZERO_AMOUNT' as issue_type
from transactions
where amount_eur = 0

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'INVALID_TRANSACTION_TYPE' as issue_type
from transactions
where transaction_type not in (
    'Card payment',
    'Bank transfer',
    'Cash deposit',
    'International transfer',
    'ATM withdrawal'
)

union all

select
    transaction_id,
    customer_id,
    transaction_date_raw,
    amount_eur_raw,
    transaction_type,
    'HIGH_VALUE_REVIEW' as issue_type
from transactions
where amount_eur >= 10000