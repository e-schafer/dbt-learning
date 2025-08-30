{% snapshot customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='check',
      check_cols=['total_orders', 'total_spent', 'customer_segment', 'customer_status'],
      description='Snapshot historique des données clients pour tracer les évolutions des métriques'
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
    current_timestamp as dbt_updated_at
from {{ ref('dim_customers') }}

{% endsnapshot %}
