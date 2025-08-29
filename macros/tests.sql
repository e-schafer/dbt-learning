{#
Macro pour tester qu'une valeur est dans une plage
Usage: {{ test_value_in_range('price', 0, 1000) }}
#}
{% test value_in_range(model, column_name, min_value, max_value) %}
    select count(*)
    from {{ model }}
    where {{ column_name }} < {{ min_value }}
       or {{ column_name }} > {{ max_value }}
       or {{ column_name }} is null
{% endtest %}

{#
Macro pour tester qu'une date est récente
Usage: {{ test_recent_date('created_at', 30) }}
#}
{% test recent_date(model, column_name, days_threshold=30) %}
    select count(*)
    from {{ model }}
    where {{ column_name }} < current_date - interval '{{ days_threshold }} days'
       or {{ column_name }} is null
{% endtest %}

{#
Macro pour tester qu'un email est valide
Usage: {{ test_valid_email('email') }}
#}
{% test valid_email(model, column_name) %}
    select count(*)
    from {{ model }}
    where {{ column_name }} is not null
      and (
          {{ column_name }} not like '%@%'
          or {{ column_name }} like '%@%@%'
          or {{ column_name }} like '@%'
          or {{ column_name }} like '%@'
          or length({{ column_name }}) < 5
      )
{% endtest %}

{#
Macro pour tester la cohérence des montants
Usage: {{ test_amount_consistency('total', 'subtotal', 'tax') }}
#}
{% test amount_consistency(model, total_column, subtotal_column, tax_column) %}
    select count(*)
    from {{ model }}
    where abs({{ total_column }} - ({{ subtotal_column }} + {{ tax_column }})) > 0.01
{% endtest %}

{#
Macro pour tester qu'une valeur existe dans une table de référence
Usage: {{ test_referential_integrity('customer_id', ref('dim_customers'), 'customer_id') }}
#}
{% test referential_integrity(model, column_name, ref_table, ref_column) %}
    select count(*)
    from {{ model }} a
    left join {{ ref_table }} b on a.{{ column_name }} = b.{{ ref_column }}
    where a.{{ column_name }} is not null
      and b.{{ ref_column }} is null
{% endtest %}
