select
    nullif(trim(customer_id), '') as customer_id,
    nullif(trim(customer_name), '') as customer_name,
    nullif(trim(country), '') as country,
    nullif(trim(risk_level), '') as risk_level,

    nullif(trim(customer_since), '') as customer_since_raw,
    safe_cast(nullif(trim(customer_since), '') as date) as customer_since_date

from {{ ref('customers') }}