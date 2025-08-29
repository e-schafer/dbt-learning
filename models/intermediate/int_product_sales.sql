{{
  config(
    materialized='view',
    description='Analyse des ventes par produit et période'
  )
}}

with order_details as (
    -- Note: Nous simulons des détails de commande car nous n'avons que les commandes
    -- Dans un vrai projet, vous auriez une table order_items
    select
        o.*,
        -- Simulation: chaque commande contient 1-3 produits aléatoires
        p.product_id,
        p.product_name,
        p.category,
        p.price,
        p.cost,
        p.margin
    from {{ ref('stg_orders') }} o
    cross join {{ ref('stg_products') }} p
    where abs(hash(o.order_id || p.product_id)) % 3 = 0  -- Simulation d'association
),

product_sales as (
    select
        product_id,
        product_name,
        category,
        price,
        cost,
        margin,
        count(distinct order_id) as orders_count,
        count(*) as quantity_sold,
        sum(price) as total_revenue,
        sum(cost) as total_cost,
        sum(margin) as total_margin,
        avg(price) as avg_selling_price,
        min(order_date) as first_sale_date,
        max(order_date) as last_sale_date
    from order_details
    group by
        product_id,
        product_name,
        category,
        price,
        cost,
        margin
),

product_rankings as (
    select
        *,
        row_number() over (order by total_revenue desc) as revenue_rank,
        row_number() over (order by quantity_sold desc) as quantity_rank,
        row_number() over (order by total_margin desc) as margin_rank,
        case
            when total_revenue >= 1000 then 'Top Performer'
            when total_revenue >= 500 then 'Good Performer'
            when total_revenue > 0 then 'Low Performer'
            else 'No Sales'
        end as performance_category
    from product_sales
)

select * from product_rankings
