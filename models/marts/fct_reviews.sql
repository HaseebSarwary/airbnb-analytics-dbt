WITH reviews AS (
    SELECT * FROM {{ ref('stg_reviews') }}
),

listings AS (
    SELECT * FROM {{ ref('stg_listings') }}
)

SELECT
    -- Generate a surrogate key for each review
    -- (no natural key exists in source, so we hash combine fields)
    {{ dbt_utils.generate_surrogate_key(['r.listing_id', 'r.review_date', 'r.reviewer_name', 'r.review_text']) }} AS review_id,
    
    -- Foreign keys
    r.listing_id,
    
    -- Review attributes
    r.review_date,
    r.reviewer_name,
    r.review_text,
    r.review_sentiment,
    
    -- Derived time attributes for analytics
    DATE_TRUNC('month', r.review_date) AS review_month,
    DATE_TRUNC('year',  r.review_date) AS review_year,
    
    -- Boolean flags for quick filtering
    CASE WHEN r.review_sentiment = 'positive' THEN TRUE ELSE FALSE END AS is_positive_review,
    CASE WHEN r.review_sentiment = 'negative' THEN TRUE ELSE FALSE END AS is_negative_review,
    
    -- Text-based metrics
    LENGTH(r.review_text) AS review_length_chars,
    
    -- Pull in listing context for denormalised analytics
    l.room_type,
    l.price

FROM reviews r
LEFT JOIN listings l
    ON r.listing_id = l.listing_id