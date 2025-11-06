/*
=========================================================================================================
Stored Procedure: Load Silver Layer (Source ->Bronze)
=========================================================================================================
Script Purpose:
	-This script creates tables in the 'silver' schema, dropping existing tables if they already exist.
	-Run this script to re-define the DDL structure of 'silver' tables.
  -The script provides the step-by-step process in cleaning and filling the null values for each column.
  -There is also a short description in each column on what happens after querying the script.

========================================================================================================
*/  

======================================silver.timedim====================================================
-- CAST date_value AS date so it will appear as DATE in Power BI
========================================================================================================
INSERT INTO silver.timedim (
	date_key,
	date_value,
	month,
	month_name,
	quarter,
	year)
SELECT 
	date_key,
	CAST(date_value AS date) AS date_value,
	month,
	month_name,
	quarter,
	year
FROM bronze.timedim;


=========================================silver.trafficsourcedim========================================
========================================================================================================

INSERT INTO silver.trafficsourcedim(
	traffic_source_key,
	channel_group,
	[source],
	[medium])
SELECT
	traffic_source_key,
	channel_group,
	[source],
	[medium]
FROM bronze.trafficsourcedim;

=========================================silver.campaigndim=============================================
========================================================================================================

INSERT INTO silver.campaigndim(
	campaign_key,
	[platform],
	account_id,
	campaign_id_nk,
	campaign_name)
SELECT
	campaign_key,
	[platform],
	account_id,
	campaign_id_nk,
	COALESCE(campaign_name, 'unknown') as campaign_name
	FROM bronze.campaigndim
;


=========================================silver.productdim==============================================
-- Fix the spelling in product_name and flavor column
========================================================================================================
INSERT INTO silver.productdim (
    product_key,
    sku,
    product_name,
    brand,
    category,
    subcategory,
    flavor,
    net_content_g,
    servings_per_unit
)
SELECT
    d.product_key,
    d.sku,
    CASE
        WHEN d.product_name LIKE 'B%h' THEN 'BCAA Splash'
        ELSE d.product_name
    END AS product_name,
    d.brand,
    d.category,
    d.subcategory,
    CASE
        WHEN d.flavor LIKE 'V%' THEN 'Vanilla'
        WHEN d.flavor LIKE 'S%c%l' THEN 'Salted Caramel'
        WHEN d.flavor LIKE 'S%n' THEN 'Sour Watermelon'
        WHEN d.flavor LIKE 'Ice%' THEN 'Iced Tea Peach'
        ELSE d.flavor
    END AS flavor,
    d.net_content_g,
    d.servings_per_unit
FROM (
    SELECT
        product_key,
        sku,
        CASE
            WHEN sku LIKE '%BC%' THEN COALESCE(product_name, 'BCAA Splash')
            WHEN sku LIKE '%RI%' THEN COALESCE(product_name, 'Ripped Burner')
            WHEN sku LIKE '%PR%' THEN COALESCE(product_name, 'Pre-Workout BERSERK')
            WHEN sku LIKE '%WH%' THEN COALESCE(product_name, 'Whey Protein Concentrate (RAW)')
            WHEN sku LIKE '%IS%' THEN COALESCE(product_name, 'Isolate Splash')
            WHEN sku LIKE '%HI%' THEN COALESCE(product_name, 'High Whey')
            WHEN sku LIKE '%EA%' THEN COALESCE(product_name, 'EAA Essentials')
            WHEN sku LIKE '%CR%' THEN COALESCE(product_name, 'Creatine Monohydrate')
            WHEN sku LIKE '%CO%' THEN COALESCE(product_name, 'Collagen Beauty')
            WHEN product_name LIKE 'B%h' THEN 'BCAA Splash'
            ELSE 'unknown'
        END AS product_name,
        brand,
        category,
        subcategory,
        CASE
            WHEN sku LIKE '%IC%' THEN COALESCE(flavor, 'Iced Tea Peach')
            WHEN sku LIKE '%CH%' THEN COALESCE(flavor, 'Chocolate')
            WHEN sku LIKE '%VA%' THEN COALESCE(flavor, 'Vanilla')
            WHEN sku LIKE '%SO%' THEN COALESCE(flavor, 'Sour Watermelon')
            WHEN sku LIKE '%BL%' THEN COALESCE(flavor, 'Blue Raspberry')
            WHEN sku LIKE '%ST%' THEN COALESCE(flavor, 'Strawberry')
            WHEN sku LIKE '%UN%' THEN COALESCE(flavor, 'Unflavored')
            WHEN sku LIKE '%CO%' THEN COALESCE(flavor, 'Cookies & Cream')
            WHEN sku LIKE '%LE%' THEN COALESCE(flavor, 'Lemon Lime')
            WHEN sku LIKE '%SA%' THEN COALESCE(flavor, 'Salted Caramel')
            WHEN flavor LIKE 'V%' THEN 'Vanilla'
            WHEN flavor LIKE 'S%c%l' THEN 'Salted Caramel'
            WHEN flavor LIKE 'S%n' THEN 'Sour Watermelon'
            WHEN flavor LIKE 'Ice%' THEN 'Iced Tea Peach'
            ELSE 'unknown'
        END AS flavor,
        net_content_g,
        servings_per_unit
    FROM bronze.productdim
) AS d;

=========================================silver.orderfact===============================================
-- Fix the null in payment fees column, replace null with 0
========================================================================================================
  
INSERT INTO silver.orderfact(
order_key,
order_id_nk,
date_key,
customer_key,
session_key,
campaign_key,
revenue_amount,
discount_amount,
shipping_amount,
payment_fees,
cogs_amount,
refund_amount)

SELECT
o.order_key,
o.order_id_nk,
o.date_key,
o.customer_key,
o.session_key,
w.campaign_key,
o.revenue_amount,
o.discount_amount,
o.shipping_amount,
COALESCE(o.payment_fees, '0') as payment_fees,
o.cogs_amount,
o.refund_amount
FROM bronze.websessionfact w
INNER JOIN bronze.orderfact o
ON o.session_key = w.session_key

=========================================silver.websessionfact==========================================
-- Fix null values in session_key, replacing it with a custom value key.
========================================================================================================

INSERT INTO silver.websessionfact(
session_key,
session_id_nk,
date_key,
traffic_source_key,
campaign_key,
pageviews,
pdp_views,
add_to_carts,
checkout_starts,
orders_in_session)

SELECT 
session_key,
session_id_nk,
date_key,
traffic_source_key,
campaign_key,
pageviews,
pdp_views,
add_to_carts,
checkout_starts,
orders_in_session
FROM bronze.websessionfact

UPDATE w
SET w.session_id_nk =
    'S-' +
    RIGHT('00000000' + ISNULL(CONVERT(varchar(8), w.date_key), '00000000'), 8) +
    '-' + CONVERT(varchar(20), w.session_key)
FROM silver.websessionfact AS w
WHERE w.session_id_nk LIKE ''

=========================================silver.customerdim===============================================
-- Replace "unknown date" with custom date, for easy filter in Power BI.
==========================================================================================================

INSERT INTO silver.customerdim(
customer_key,
customer_id_nk,
cohort_date_key,
acquisition_source_key,
acquisition_campaign_key)

UPDATE c
SET c.cohort_date_key =
  (SELECT MIN(o.date_key)
   FROM silver.orderfact o
   WHERE o.customer_key = c.customer_key)
FROM silver.customerdim AS c
LEFT JOIN silver.timedim t ON t.date_key = c.cohort_date_key
WHERE (c.cohort_date_key IS NULL OR t.date_key IS NULL)
  AND EXISTS (SELECT 1 FROM silver.orderfact o WHERE o.customer_key = c.customer_key);

DECLARE @unk_date INT = 19000101;

FROM silver.customerdim AS c
WHERE c.acquisition_source_key IS NULL;

SELECT
  c.customer_key,
  c.acquisition_source_key AS current_source_key,
  w.traffic_source_key     AS suggested_source_key
FROM silver.customerdim c
JOIN (
  SELECT d.customer_key, MIN(o.order_key) AS first_order_key
  FROM (
    SELECT customer_key, MIN(date_key) AS first_date_key
    FROM silver.orderfact
    GROUP BY customer_key
  ) d
  JOIN silver.orderfact o
    ON o.customer_key = d.customer_key
   AND o.date_key     = d.first_date_key
  GROUP BY d.customer_key
) fo
  ON fo.customer_key = c.customer_key
JOIN silver.orderfact o1
  ON o1.order_key = fo.first_order_key
LEFT JOIN silver.websessionfact w
  ON w.session_key = o1.session_key
LEFT JOIN silver.trafficsourcedim ts
  ON ts.traffic_source_key = c.acquisition_source_key
WHERE c.acquisition_source_key IS NULL
   OR ts.traffic_source_key IS NULL;

=========================================silver.orderlinefact===============================================
-- Replace line_discount NULL with 0
============================================================================================================

INSERT INTO silver.orderlinefact(
order_line_key,
order_key,
product_key,
qty,
item_price,
line_discount)


SELECT *
FROM bronze.orderlinefact

UPDATE ol
SET line_discount =
      CASE
        WHEN ol.line_discount IS NULL OR ol.line_discount < 0 THEN 0
        WHEN ol.line_discount > COALESCE(ol.item_price,0) * COALESCE(ol.qty,0)
          THEN COALESCE(ol.item_price,0) * COALESCE(ol.qty,0)
        ELSE ol.line_discount
      END
FROM silver.orderlinefact ol;

=========================================silver.marketingspendfact==========================================
-- Fill in some of the NULL values using JOIN from another table.
============================================================================================================

INSERT INTO silver.marketingspendfact(
spend_key,
date_key,
traffic_source_key,
campaign_key,
clicks,
impressions,
spend_amount)

SELECT *
FROM bronze.marketingspendfact


;WITH ranked AS (
  SELECT
    traffic_source_key,
    campaign_key,
    COUNT(*) AS cnt,
    ROW_NUMBER() OVER (
      PARTITION BY traffic_source_key
      ORDER BY COUNT(*) DESC, MIN(spend_key) ASC
    ) AS rn
  FROM silver.marketingspendfact
  WHERE campaign_key IS NOT NULL
  GROUP BY traffic_source_key, campaign_key
)
UPDATE ms
SET ms.campaign_key = d.campaign_key
FROM silver.marketingspendfact AS ms
JOIN ranked AS d
  ON d.traffic_source_key = ms.traffic_source_key
WHERE ms.campaign_key IS NULL
  AND d.rn = 1;
