SELECT
PRODUCT_ID as PRODUCT_GUID
, NAME as PRODUCT_NAME
, PRICE
, INVENTORY

FROM {{ source('postgres_greenery', 'products') }}