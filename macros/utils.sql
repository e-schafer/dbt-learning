{# Macro pour générer un hash sécurisé #}
{% macro generate_hash(column_name) %}
    md5(cast({{ column_name }} as string))
{% endmacro %}

{# Macro pour calculer l'âge en années #}
{% macro calculate_age(birth_date_column) %}
    datediff('year', {{ birth_date_column }}, current_date)
{% endmacro %}

{# Macro pour nettoyer les emails #}
{% macro clean_email(email_column) %}
    lower(trim({{ email_column }}))
{% endmacro %}

{# Macro pour formater les montants en euros #}
{% macro format_currency(amount_column, currency='EUR') %}
    concat(cast(round({{ amount_column }}, 2) as string), ' {{ currency }}')
{% endmacro %}

{# Macro pour catégoriser les montants #}
{% macro categorize_amount(amount_column, low_threshold=100, high_threshold=500) %}
    case
        when {{ amount_column }} >= {{ high_threshold }} then 'High'
        when {{ amount_column }} >= {{ low_threshold }} then 'Medium'
        when {{ amount_column }} > 0 then 'Low'
        else 'Zero'
    end
{% endmacro %}

{# Macro pour calculer le percentile #}
{% macro percentile(column_name, percentile_value) %}
    percentile_cont({{ percentile_value }}) within group (order by {{ column_name }})
{% endmacro %}

{# Macro pour créer des tranches temporelles #}
{% macro time_bucket(date_column, bucket_type='day') %}
    {% if bucket_type == 'hour' %}
        date_trunc('hour', {{ date_column }})
    {% elif bucket_type == 'day' %}
        date_trunc('day', {{ date_column }})
    {% elif bucket_type == 'week' %}
        date_trunc('week', {{ date_column }})
    {% elif bucket_type == 'month' %}
        date_trunc('month', {{ date_column }})
    {% elif bucket_type == 'quarter' %}
        date_trunc('quarter', {{ date_column }})
    {% elif bucket_type == 'year' %}
        date_trunc('year', {{ date_column }})
    {% else %}
        {{ date_column }}
    {% endif %}
{% endmacro %}
