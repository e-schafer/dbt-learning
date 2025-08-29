{{
  config(
    severity='error',
    description='Test de logique métier - vérifie qu\'il n\'y a pas de montants négatifs dans les ventes'
  )
}}

-- Test simple : vérifier qu'il n'y a pas de montants négatifs dans les ventes
select order_id, total_amount
from {{ ref('fact_sales') }}
where total_amount <= 0
