{{
  config(
    materialized='table',
    description='Dashboard principal des métriques clients'
  )
}}

select
    customer_id,
    first_name,
    last_name,
    email,
    registration_date,
    total_orders,
    total_spent,
    avg_order_value,
    first_order_date,
    last_order_date,
    delivered_orders,
    cancelled_orders,
    delivery_success_rate,
    customer_segment,
    customer_status,
    case
        when registration_date >= current_date - interval '30 days' then 'New'
        when registration_date >= current_date - interval '365 days' then 'Recent'
        else 'Established'
    end as customer_tenure,
    case
        when last_order_date is not null
        then current_date - last_order_date
        else null
    end as days_since_last_order,
    current_timestamp as dbt_updated_at
from {{ ref('int_customer_metrics') }}
