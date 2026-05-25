WITH listings AS (
    SELECT * FROM {{ ref('stg_listings') }}
),

hosts AS (
    SELECT * FROM {{ ref('stg_hosts') }}
)

SELECT
    l.listing_id,
    l.listing_name,
    l.listing_url,
    l.room_type,
    l.minimum_nights,
    l.price,
    
    -- Host attributes (flattened in via join)
    l.host_id,
    h.host_name,
    h.is_superhost,
    
    -- Categorise price tiers for easier analytics
    CASE
        WHEN l.price < 50  THEN 'budget'
        WHEN l.price < 150 THEN 'mid_range'
        WHEN l.price < 300 THEN 'premium'
        ELSE 'luxury'
    END AS price_tier,
    
    -- Categorise stay length
    CASE
        WHEN l.minimum_nights = 1 THEN 'single_night'
        WHEN l.minimum_nights <= 7 THEN 'short_stay'
        WHEN l.minimum_nights <= 30 THEN 'medium_stay'
        ELSE 'long_stay'
    END AS stay_length_category,
    
    l.created_at,
    l.updated_at

FROM listings l
LEFT JOIN hosts h
    ON l.host_id = h.host_id