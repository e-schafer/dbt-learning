{{
  config(
    materialized='view',
    description='Métriques agrégées par client'
  )
}}

with customer_orders as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.registration_date,
        count(o.order_id) as total_orders,
        coalesce(sum(o.total_amount), 0) as total_spent,
        coalesce(avg(o.total_amount), 0) as avg_order_value,
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date,
        count(case when o.status = 'delivered' then 1 end) as delivered_orders,
        count(case when o.status = 'cancelled' then 1 end) as cancelled_orders
    from {{ ref('stg_customers') }} c
    left join {{ ref('stg_orders') }} o on c.customer_id = o.customer_id
    group by
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.registration_date
),

customer_segments as (
    select
        *,
        case
            when total_spent >= 1000 then 'High Value'
            when total_spent >= 500 then 'Medium Value'
            when total_spent > 0 then 'Low Value'
            else 'No Purchase'
        end as customer_segment,
        case
            when last_order_date >= current_date - interval '30 days' then 'Active'
            when last_order_date >= current_date - interval '90 days' then 'At Risk'
            when last_order_date is not null then 'Inactive'
            else 'Never Purchased'
        end as customer_status,
        case
            when delivered_orders + cancelled_orders > 0
            then round((delivered_orders::decimal / (delivered_orders + cancelled_orders)) * 100, 2)
            else null
        end as delivery_success_rate
    from customer_orders
)

select * from customer_segments
