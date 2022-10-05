SELECT
ORDER_ID as ORDER_GUID
, PRODUCT_ID as PRODUCT_GUID
, QUANTITY

FROM {{ source('postgres_greenery', 'order_items') }}