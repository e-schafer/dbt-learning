{{
  config(
    materialized='view',
    description='Table des commandes nettoyée et standardisée'
  )
}}

with source_data as (
    select * from read_parquet('data/raw/orders.parquet')
),

cleaned as (
    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        cast(total_amount as decimal(10,2)) as total_amount,
        lower(trim(status)) as status,
        extract(year from cast(order_date as date)) as order_year,
        extract(month from cast(order_date as date)) as order_month,
        extract(quarter from cast(order_date as date)) as order_quarter,
        current_timestamp as dbt_updated_at
    from source_data
    where order_id is not null
        and customer_id is not null
        and total_amount > 0
)

select * from cleaned
