WITH raw_reviews AS (
    SELECT * FROM {{ source('airbnb', 'reviews') }}
),

deduplicated AS (
    SELECT
        listing_id,
        date,
        reviewer_name,
        comments,
        sentiment,
        ROW_NUMBER() OVER (
            PARTITION BY listing_id, date, reviewer_name, comments
            ORDER BY date
        ) AS row_num
    FROM raw_reviews
)

SELECT
    listing_id,
    date                AS review_date,
    reviewer_name,
    comments            AS review_text,
    sentiment           AS review_sentiment

FROM deduplicated
WHERE row_num = 1