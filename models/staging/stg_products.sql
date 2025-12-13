 {{ config(
    alias='STG_PRODUCTS',
    materialized='view'
) }}

with source as (

    select *
    from {{ source('raw_erp', 'PRODUCTS') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['source_system', 'product_id']) }} as product_key,
        upper(trim(product_id)) as product_id,
        initcap(trim(product_name)) as product_name,
        list_price,
        source_system
    from source
    where product_id is not null

)

select *
from renamed
