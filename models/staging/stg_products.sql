{{
  config(
    materialized='view',
    description='Table des produits nettoyée et standardisée'
  )
}}

with source_data as (
    select * from read_csv_auto('data/raw/products.csv')
),

cleaned as (
    select
        product_id,
        trim(product_name) as product_name,
        trim(lower(category)) as category,
        cast(price as decimal(10,2)) as price,
        cast(cost as decimal(10,2)) as cost,
        cast(price as decimal(10,2)) - cast(cost as decimal(10,2)) as margin,
        case 
            when cast(cost as decimal(10,2)) > 0 
            then round(((cast(price as decimal(10,2)) - cast(cost as decimal(10,2))) / cast(cost as decimal(10,2))) * 100, 2)
            else null
        end as margin_percentage,
        current_timestamp as dbt_updated_at
    from source_data
    where product_id is not null
        and product_name is not null
        and price > 0
)

select * from cleaned
