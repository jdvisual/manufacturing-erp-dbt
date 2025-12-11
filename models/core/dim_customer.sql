{{ config(
    alias='DIM_CUSTOMER',
    materialized='table'
) }}

select
    customer_key,
    customer_id,
    customer_name,
    customer_segment,
    country_code,
    created_at,
    updated_at
from {{ ref('stg_customers') }}
