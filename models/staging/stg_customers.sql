{{ config(
    alias='STG_CUSTOMER',
    materialized='view'
) }}

with source as (
    select * from {{ source('erp_raw', 'customers') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['source_system', 'customer_id']) }} as customer_key,
        upper(trim(customer_id))          as customer_id,
        initcap(trim(customer_name))      as customer_name,
        upper(trim(customer_segment))     as customer_segment,
        upper(trim(country_code))         as country_code,
 	created_at,
 	updated_at ,
        source_system
    from source
    where customer_id is not null
)

select * from renamed
