# Answers to Week 1 Project Questions
## How many users do we have?
| COUNT(DISTINCT USER_GUID) |
|---------------------------|
| 130                       |

```sql
select count(distinct user_guid)
from dev_db.dbt_simonc.postgres_users
```

## On average, how many orders do we receive per hour?
| ORDERS_PER_HOUR | FIRST_ORDER             | LAST_ORDER              | ORDER_TIMESPAN_HOURS | ORDERS |
|-----------------|-------------------------|-------------------------|----------------------|--------|
| 7.680851        | 2021-02-10 00:00:05.000 | 2021-02-11 23:55:36.000 | 47                   | 361    |

```sql
select count(distinct order_guid) / TIMEDIFF(hour, min(created_at), max(created_at)) as orders_per_hour 
, min(created_at) as first_order
, max(created_at) as last_order
, timediff(hour, min(created_at), max(created_at)) as order_timespan_hours
, count(distinct order_guid) orders
from dev_db.dbt_simonc.postgres_orders
```

## On average, how long does an order take from being placed to being delivered?
| AVG(DELIVERY_DELAY_HOURS) |
|---------------------------|
| 93.403279                 |

```sql
WITH delivery_data as (
select created_at
, delivered_at
, timediff(hour, created_at, delivered_at) as delivery_delay_hours

from dev_db.dbt_simonc.postgres_orders
where delivered_at is not null
)

select avg(delivery_delay_hours) from delivery_data
```

## How many users have only made one purchase? Two purchases? Three+ purchases?
| ORDER_COUNT | COUNT(USER_GUID) |
|-------------|------------------|
| 1           | 25               |
| 2           | 28               |
| 3+          | 71               |

```sql
with user_purchases as (
select user_guid
    , case when count(distinct order_guid) > 2 then '3+'
    else cast((count(distinct order_guid)) as string)
    end as order_count
from dev_db.dbt_simonc.postgres_orders
group by user_guid
)

select order_count
, count(user_guid)
from user_purchases
group by order_count
order by order_count
```

## On average, how many unique sessions do we have per hour?
| FIRST_SESSION           | LAST_SESSION            | SESSION_TIMESPAN_HOURS | UNIQUE_SESSIONS | SESSIONS_PER_HOUR |
|-------------------------|-------------------------|------------------------|-----------------|-------------------|
| 2021-02-09 23:55:08.000 | 2021-02-12 08:55:36.000 | 57                     | 578             | 10.140351         |

```sql
select min(created_at) as first_session
, max(created_at) as last_session
, timediff(hour, min(created_at), max(created_at)) as session_timespan_hours
, count(distinct session_guid) unique_sessions
, count(distinct session_guid) / timediff(hour, min(created_at), max(created_at)) as sessions_per_hour

from dev_db.dbt_simonc.postgres_events
```