{{
  config(
    materialized='table',
    description='Table de faits des ventes avec toutes les métriques'
  )
}}

with sales_facts as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_year,
        o.order_month,
        o.order_quarter,
        o.total_amount,
        o.status,
        c.customer_segment,
        c.customer_status,
        -- Métriques temporelles
        extract(dayofweek from o.order_date) as day_of_week,
        extract(week from o.order_date) as week_of_year,
        case
            when extract(dayofweek from o.order_date) in (1, 7) then 'Weekend'
            else 'Weekday'
        end as day_type,
        case
            when extract(hour from current_timestamp) between 6 and 11 then 'Morning'
            when extract(hour from current_timestamp) between 12 and 17 then 'Afternoon'
            when extract(hour from current_timestamp) between 18 and 23 then 'Evening'
            else 'Night'
        end as time_of_day,
        -- Flags business
        case when o.total_amount > 100 then 1 else 0 end as is_high_value_order,
        case when o.status = 'delivered' then 1 else 0 end as is_successful_order,
        case when o.status = 'cancelled' then 1 else 0 end as is_cancelled_order,
        -- Métriques de délai (simulation)
        case
            when o.status = 'delivered' then random() * 10 + 1  -- 1-11 jours
            else null
        end as delivery_days,
        current_timestamp as dbt_updated_at
    from {{ ref('stg_orders') }} o
    left join {{ ref('int_customer_metrics') }} c on o.customer_id = c.customer_id
)

select * from sales_facts
