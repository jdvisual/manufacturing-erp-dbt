{{ config(
    alias='DIM_PRODUCT',
    materialized='table'
) }}

select
    product_key,
    product_id,
    product_name,
    product_category,
    unit_of_measure,
    standard_cost,
    list_price,
    created_at,
    updated_at
from {{ ref('stg_products') }}
