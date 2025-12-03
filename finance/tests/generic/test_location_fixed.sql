{% test location_fixed(model, column_name) %}

    with locations as (
        select distinct {{ column_name }} as all_locs from {{ model }}
    ),

    incompatible_location as (
        select * from locations where LOWER(all_locs) NOT IN ('ipswich', 'london', 'birmingham', 'liverpool', 'manchester')
    )

    select * from incompatible_location

{% endtest %}