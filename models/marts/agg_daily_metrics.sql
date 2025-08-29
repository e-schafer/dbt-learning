{{
  config(
    materialized='table',
    description='Métriques business agrégées par période'
  )
}}

with daily_metrics as (
    select
        order_date,
        order_year,
        order_month,
        order_quarter,
        count(distinct order_id) as total_orders,
        count(distinct customer_id) as unique_customers,
        sum(total_amount) as total_revenue,
        avg(total_amount) as avg_order_value,
        sum(is_high_value_order) as high_value_orders,
        sum(is_successful_order) as successful_orders,
        sum(is_cancelled_order) as cancelled_orders,
        avg(delivery_days) as avg_delivery_days
    from {{ ref('fact_sales') }}
    group by order_date, order_year, order_month, order_quarter
),

enriched_metrics as (
    select
        *,
        -- Calculs de taux
        round((successful_orders::decimal / total_orders) * 100, 2) as success_rate,
        round((cancelled_orders::decimal / total_orders) * 100, 2) as cancellation_rate,
        round((high_value_orders::decimal / total_orders) * 100, 2) as high_value_rate,
        
        -- Métriques mobiles (fenêtre de 7 jours)
        avg(total_revenue) over (
            order by order_date 
            rows between 6 preceding and current row
        ) as rolling_7d_avg_revenue,
        
        avg(total_orders) over (
            order by order_date 
            rows between 6 preceding and current row
        ) as rolling_7d_avg_orders,
        
        -- Comparaisons période précédente
        lag(total_revenue, 1) over (order by order_date) as prev_day_revenue,
        lag(total_orders, 1) over (order by order_date) as prev_day_orders,
        
        current_timestamp as dbt_updated_at
    from daily_metrics
),

final_metrics as (
    select
        *,
        -- Calculs de croissance
        case
            when prev_day_revenue > 0
            then round(((total_revenue - prev_day_revenue) / prev_day_revenue) * 100, 2)
            else null
        end as revenue_growth_rate,
        
        case
            when prev_day_orders > 0
            then round(((total_orders - prev_day_orders) / prev_day_orders::decimal) * 100, 2)
            else null
        end as orders_growth_rate
    from enriched_metrics
)

select * from final_metrics
order by order_date desc
