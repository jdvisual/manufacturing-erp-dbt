{{ config(
    alias='STG_PRODUCT',
    materialized='view'
) }}

with source as (
    select * from source('raw_erp', 'PRODUCTS')

),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['source_system', 'product_id']) }} as product_key,
        upper(trim(product_id))           as product_id,
        initcap(trim(product_name))       as product_name,
        upper(trim(product_category))     as product_category,
        unit_of_measure,
        standard_cost,
        list_price,
         created_at,
         updated_at,
        source_system
    from source
    where product_id is not null
)

select * from renamed
