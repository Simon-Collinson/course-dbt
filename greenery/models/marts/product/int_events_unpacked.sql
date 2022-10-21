with unpack as (
    select coalesce(poi.product_guid, pe.product_guid) product_guid_coalesce
        , pe.event_guid --note that the event guid is no longer unique, since it can be the same if >1 products were checked out or shipped in a single event
        , pe.session_guid
        , pe.user_guid
        , pe.page_url
        , pe.created_at
        , pe.event_type
    from {{ ref('postgres_order_items') }} poi
    full outer join {{ ref('postgres_events') }} pe
        on poi.order_guid = pe.order_guid
)

select * 
from unpack