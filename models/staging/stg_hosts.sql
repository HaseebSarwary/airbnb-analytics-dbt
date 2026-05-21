WITH raw_hosts AS (
    SELECT * FROM {{ source('airbnb', 'hosts') }}
)

SELECT
    id                  AS host_id,
    name                AS host_name,
    CASE 
        WHEN is_superhost = 't' THEN TRUE
        ELSE FALSE
    END                 AS is_superhost,
    created_at,
    updated_at

FROM raw_hosts