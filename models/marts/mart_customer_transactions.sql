with customers as (
    select *
    from {{ ref('stg_customers') }}
),

transactions as (
    select *
    from {{ ref('stg_transactions') }}
),

valid_transactions as (
    select *
    from transactions
    where transaction_id is not null
      and customer_id is not null
      and transaction_date is not null
      and amount_eur is not null
      and amount_eur > 0
      and transaction_type in (
          'Card payment',
          'Bank transfer',
          'Cash deposit',
          'International transfer',
          'ATM withdrawal'
      )
)

select
    c.customer_id,
    c.customer_name,
    c.country,
    c.risk_level,
    c.customer_since_date,

    count(t.transaction_id) as transaction_count,
    coalesce(sum(t.amount_eur), 0) as total_amount_eur,
    coalesce(avg(t.amount_eur), 0) as avg_transaction_amount_eur,

    case
        when coalesce(sum(t.amount_eur), 0) >= 5000 then 'High value customer'
        when coalesce(sum(t.amount_eur), 0) >= 1000 then 'Medium value customer'
        else 'Low value customer'
    end as customer_value_segment

from customers c

left join valid_transactions t
    on c.customer_id = t.customer_id

group by
    c.customer_id,
    c.customer_name,
    c.country,
    c.risk_level,
    c.customer_since_date