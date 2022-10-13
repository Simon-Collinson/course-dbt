with orders as (
    select *
    from {{ ref('postgres_orders') }}
)

, order_qty as (
    select order_guid
    , count(distinct product_guid) as product_lines
    , sum(quantity) as total_quantity
    from {{ ref('postgres_order_items') }}
    group by order_guid
)

, promos as (
    select *
    from {{ ref('postgres_promos') }}
)

select    o.order_guid
        , o.user_guid
        , o.status
        , o.address_guid
        , o.created_at
        , o.order_cost
        , o.shipping_cost
        , p.discount as promo_discount
        , o.order_total
        , o.shipping_service
        , o.estimated_delivery_at
        , o.delivered_at
        , timediff(hours, o.estimated_delivery_at, o.delivered_at) as delivery_delay
        , oq.product_lines as product_lines
        , oq.total_quantity as order_units

from orders o
left join order_qty oq
    on o.order_guid = oq.order_guid
left join promos p
    on o.promo_id = p.promo_id