{{
  config(
    severity='error',
    description='Test d\'intégrité des données - vérifie qu\'il n\'y a pas de commandes orphelines'
  )
}}

-- Test simple : vérifier qu'il n'y a pas de commandes orphelines
select f.order_id, f.customer_id
from {{ ref('fact_sales') }} f
left join {{ ref('dim_customers') }} d on f.customer_id = d.customer_id
where d.customer_id is null
