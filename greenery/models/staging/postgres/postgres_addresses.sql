SELECT
ADDRESS_ID as ADDRESS_GUID
, ADDRESS
, ZIPCODE
, STATE
, COUNTRY

FROM {{ source('postgres_greenery', 'addresses') }}