{{
  config(
    materialized='view',
    description='Table des clients nettoyée et standardisée'
  )
}}

with source_data as (
    select * from read_csv_auto('data/raw/customers.csv')
),

cleaned as (
    select
        customer_id,
        trim(lower(first_name)) as first_name,
        trim(lower(last_name)) as last_name,
        trim(lower(email)) as email,
        cast(registration_date as date) as registration_date,
        current_timestamp as dbt_updated_at
    from source_data
    where customer_id is not null
        and email is not null
        and email like '%@%'
)

select * from cleaned
