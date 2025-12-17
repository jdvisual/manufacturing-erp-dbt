 {% snapshot snap_customer_account %}

{{
  config(
    target_schema='snapshots',
    strategy='check',
    unique_key='customer_id',
    check_cols=[
      'customer_name',
      'account_status',
      'customer_segment',
      'credit_limit',
      'payment_terms'
    ]
  )
}}

select
  customer_id,
  customer_name,
  account_status,
  customer_segment,
  credit_limit,
  payment_terms
from {{ ref('core_customer') }}

{% endsnapshot %}

