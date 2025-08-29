{% snapshot customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='dbt_updated_at',
    )
}}

select
    customer_id,
    first_name,
    last_name,
    email,
    registration_date,
    customer_segment,
    customer_status,
    total_orders,
    total_spent,
    avg_order_value,
    delivery_success_rate,
    dbt_updated_at
from {{ ref('dim_customers') }}

{% endsnapshot %}
