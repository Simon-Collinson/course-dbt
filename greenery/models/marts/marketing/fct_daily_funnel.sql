{{
    config(
        materialized = 'table'
    )
}}

with date_spine as (
    select *
    from {{ ref('date_spine') }}
)

, sessions as (
    select *
    from {{ ref('int_sessions') }}
)

, session_summary as (
    select 
    date_trunc(day, session_start) session_start_date
    , count(session_guid) top_funnel
    , sum(case when (adds_to_cart + checkouts) > 0 then 1 else 0 end) mid_funnel
    , sum(case when checkouts > 0 then 1 else 0 end) bottom_funnel
    from sessions
    group by 1
)

select
    ds.date_day as session_date
    , top_funnel
    , mid_funnel
    , bottom_funnel

from date_spine ds
left join session_summary s
    on ds.date_day = s.session_start_date