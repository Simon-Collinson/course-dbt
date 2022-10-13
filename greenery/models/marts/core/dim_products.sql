with products as (
    select *
 from {{ ref('postgres_products') }}
)

, product_orders as (
    select
        product_guid
        , sum(quantity) quantity
    from {{ ref('postgres_order_items') }}
    group by product_guid
)

, product_events as (
    select *
    from {{ ref('int_product_events') }}
)

select  p.product_guid
        , p.product_name
        , p.price
        , p.inventory
        , zeroifnull(po.quantity) as product_qty_lifetime --if join fails, coerce to zero units sold
        , p.price * zeroifnull(po.quantity) as product_sales_lifetime --important note! we assume here the product's price has never changed
        , zeroifnull(pe.page_views) as product_pageviews_lifetime
        , zeroifnull(pe.adds_to_cart) as products_adds_to_cart_lifetime

from products p
left join product_orders po
    on p.product_guid = po.product_guid
left join product_events pe
    on p.product_guid = pe.product_guid