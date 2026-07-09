select
    nullif(trim(transaction_id), '') as transaction_id,
    nullif(trim(customer_id), '') as customer_id,

    nullif(trim(transaction_date), '') as transaction_date_raw,
    safe_cast(nullif(trim(transaction_date), '') as date) as transaction_date,

    nullif(trim(amount_eur), '') as amount_eur_raw,
    safe_cast(nullif(trim(amount_eur), '') as numeric) as amount_eur,

    nullif(trim(transaction_type), '') as transaction_type

from {{ ref('transactions') }}