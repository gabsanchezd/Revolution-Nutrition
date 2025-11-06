/*
=========================================================================================================
Stored Procedure: Load Gold Layer (Source ->Silver)
=========================================================================================================
Script Purpose:
	-This script creates view in the 'gold' schema, creating views for metrics being tracked.
	-The script joins necessary table in order to track the KPIs requested by the stakeholders.
    -The script provides the step-by-step process in calculating the metrics needed for presentation in 
      Power BI.

========================================================================================================
*/  

=======================================gold.marketingbycampaign=========================================
CREATE OR ALTER VIEW gold.marketingbycampaign AS
SELECT
    ms.date_key,
    t.date_value, t.year, t.quarter, t.month, t.month_name,
    ms.traffic_source_key,
    ts.channel_group, ts.source, ts.medium,
    ms.campaign_key,
    cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name,
    SUM(COALESCE(ms.impressions,0)) AS impressions,
    SUM(COALESCE(ms.clicks,0))      AS clicks,
    SUM(COALESCE(ms.spend_amount,0)) AS spend
FROM silver.marketingspendfact ms
LEFT JOIN silver.timedim t           ON t.date_key = ms.date_key
LEFT JOIN silver.trafficsourcedim ts ON ts.traffic_source_key = ms.traffic_source_key
LEFT JOIN silver.campaigndim cam     ON cam.campaign_key = ms.campaign_key
GROUP BY
    ms.date_key, t.date_value, t.year, t.quarter, t.month, t.month_name,
    ms.traffic_source_key, ts.channel_group, ts.source, ts.medium,
    ms.campaign_key, cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name;
GO

=======================================gold.sessionsbychannel===========================================
CREATE OR ALTER VIEW gold.sessionsbychannel AS
SELECT
    w.date_key,
    t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key,
    ts.channel_group, ts.source, ts.medium,
    COUNT_BIG(*)                               AS sessions,
    SUM(COALESCE(w.pageviews,0))               AS pageviews,
    SUM(COALESCE(w.pdp_views,0))               AS pdp_views,
    SUM(COALESCE(w.add_to_carts,0))            AS add_to_carts,
    SUM(COALESCE(w.checkout_starts,0))         AS checkout_starts,
    SUM(COALESCE(w.orders_in_session,0))       AS orders_in_session
FROM silver.websessionfact w
LEFT JOIN silver.timedim t           ON t.date_key = w.date_key
LEFT JOIN silver.trafficsourcedim ts ON ts.traffic_source_key = w.traffic_source_key
GROUP BY
    w.date_key, t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key, ts.channel_group, ts.source, ts.medium;
GO

=======================================gold.salesbychannel==============================================
CREATE OR ALTER VIEW gold.salesbychannel AS
SELECT
    o.date_key,
    t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key,
    ts.channel_group, ts.source, ts.medium,
    COUNT_BIG(*) AS orders,
    COUNT_BIG(DISTINCT o.customer_key) AS customers_ordered,
    SUM(COALESCE(o.revenue_amount,0) - COALESCE(o.discount_amount,0) - COALESCE(o.refund_amount,0)) AS net_revenue,
    SUM(COALESCE(o.cogs_amount,0)) AS cogs
FROM silver.orderfact o
LEFT JOIN silver.websessionfact w   ON w.session_key = o.session_key
LEFT JOIN silver.timedim t          ON t.date_key = o.date_key
LEFT JOIN silver.trafficsourcedim ts ON ts.traffic_source_key = w.traffic_source_key
GROUP BY
    o.date_key, t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key, ts.channel_group, ts.source, ts.medium;
GO

=======================================gold.productdaily================================================
CREATE OR ALTER VIEW gold.productdaily AS
SELECT
    o.date_key,
    t.date_value, t.year, t.quarter, t.month, t.month_name,
    p.product_key, p.sku, p.product_name, p.brand, p.category, p.subcategory, p.flavor,
    SUM(COALESCE(ol.qty,0)) AS units,
    SUM(COALESCE(ol.item_price,0) * COALESCE(ol.qty,0) - COALESCE(ol.line_discount,0)) AS line_net_revenue,
    SUM(COALESCE(ol.line_discount,0)) AS line_discount,
    SUM(
        CASE WHEN NULLIF(o.revenue_amount,0) IS NULL THEN 0
             ELSE COALESCE(o.cogs_amount,0) *
                  (CAST(COALESCE(ol.item_price,0) * COALESCE(ol.qty,0) AS float) / NULLIF(o.revenue_amount,0))
        END
    ) AS line_cogs_est
FROM silver.orderlinefact ol
JOIN silver.orderfact o  ON o.order_key = ol.order_key
LEFT JOIN silver.timedim t ON t.date_key = o.date_key
JOIN silver.productdim p ON p.product_key = ol.product_key
GROUP BY
    o.date_key, t.date_value, t.year, t.quarter, t.month, t.month_name,
    p.product_key, p.sku, p.product_name, p.brand, p.category, p.subcategory, p.flavor;
GO

=======================================gold.sessionsbycampaign==========================================
CREATE OR ALTER VIEW gold.sessionsbycampaign AS
SELECT
    w.date_key,
    t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key,
    ts.channel_group, ts.source, ts.medium,
    w.campaign_key,
    cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name,
    COUNT_BIG(*)                       AS sessions,
    SUM(COALESCE(w.pageviews,0))       AS pageviews,
    SUM(COALESCE(w.pdp_views,0))       AS pdp_views,
    SUM(COALESCE(w.add_to_carts,0))    AS add_to_carts,
    SUM(COALESCE(w.checkout_starts,0)) AS checkout_starts,
    SUM(COALESCE(w.orders_in_session,0)) AS orders_in_session
FROM silver.websessionfact w
LEFT JOIN silver.timedim t            ON t.date_key = w.date_key
LEFT JOIN silver.trafficsourcedim ts  ON ts.traffic_source_key = w.traffic_source_key
LEFT JOIN silver.campaigndim cam      ON cam.campaign_key      = w.campaign_key
GROUP BY
    w.date_key, t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key, ts.channel_group, ts.source, ts.medium,
    w.campaign_key, cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name;
GO

=======================================gold.salesbycampaign=============================================
CREATE OR ALTER VIEW gold.salesbycampaign AS
SELECT
    o.date_key,
    t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key,
    ts.channel_group, ts.source, ts.medium,
    COALESCE(o.campaign_key, w.campaign_key) AS campaign_key,
    cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name,
    COUNT_BIG(*) AS orders,
    COUNT_BIG(DISTINCT o.customer_key) AS customers_ordered,
    SUM(COALESCE(o.revenue_amount,0) - COALESCE(o.discount_amount,0) - COALESCE(o.refund_amount,0)) AS net_revenue,
    SUM(COALESCE(o.cogs_amount,0)) AS cogs
FROM silver.OrderFact o
LEFT JOIN silver.websessionfact w   ON w.session_key = o.session_key
LEFT JOIN silver.timedim t          ON t.date_key = o.date_key
LEFT JOIN silver.trafficsourcedim ts ON ts.traffic_source_key = w.traffic_source_key
LEFT JOIN silver.campaigndim cam     ON cam.campaign_key      = COALESCE(o.campaign_key, w.campaign_key)
GROUP BY
    o.date_key, t.date_value, t.year, t.quarter, t.month, t.month_name,
    w.traffic_source_key, ts.channel_group, ts.source, ts.medium,
    COALESCE(o.campaign_key, w.campaign_key), cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name;
GO

=======================================gold.cohortmonthly===============================================
CREATE OR ALTER VIEW gold.cohortmonthly AS
WITH cohorts AS (
    SELECT
        c.customer_key,
        DATEFROMPARTS(t.year, t.month, 1) AS cohort_month,
        c.acquisition_source_key AS traffic_source_key,
        c.acquisition_campaign_key AS campaign_key
    FROM silver.customerdim c
    JOIN silver.timedim t ON t.date_key = c.cohort_date_key
    WHERE c.cohort_date_key IS NOT NULL
),
ord AS (
    SELECT
        o.customer_key,
        DATEFROMPARTS(td.year, td.month, 1) AS order_month,
        SUM(COALESCE(o.revenue_amount,0) - COALESCE(o.discount_amount,0) - COALESCE(o.refund_amount,0)) AS net_revenue,
        SUM(COALESCE(o.cogs_amount,0)) AS cogs,
        COUNT_BIG(*) AS orders
    FROM silver.orderfact o
    JOIN silver.timedim td ON td.date_key = o.date_key
    GROUP BY o.customer_key, DATEFROMPARTS(td.year, td.month, 1)
)
SELECT
    c.cohort_month,
    DATEDIFF(MONTH, c.cohort_month, o.order_month) AS months_since,
    c.traffic_source_key,
    c.campaign_key,
    COUNT(DISTINCT c.customer_key)                               AS customers_in_cohort,
    COUNT(DISTINCT CASE WHEN o.orders > 0 THEN c.customer_key END) AS active_customers,
    SUM(COALESCE(o.orders,0))                                    AS orders,
    SUM(COALESCE(o.net_revenue,0))                               AS net_revenue,
    SUM(COALESCE(o.cogs,0))                                      AS cogs
FROM cohorts c
LEFT JOIN ord o ON o.customer_key = c.customer_key
GROUP BY c.cohort_month, DATEDIFF(MONTH, c.cohort_month, o.order_month),
         c.traffic_source_key, c.campaign_key;
GO

=======================================gold.cohortacquisitionspend======================================
CREATE OR ALTER VIEW gold.cohortacquisitionspend AS
SELECT
    DATEFROMPARTS(t.year, t.month, 1) AS cohort_month,
    ms.traffic_source_key,
    ms.campaign_key,
    SUM(COALESCE(ms.spend_amount,0)) AS acquisition_spend
FROM silver.marketingspendfact ms
JOIN silver.timeDim t ON t.date_key = ms.date_key
GROUP BY DATEFROMPARTS(t.year, t.month, 1), ms.traffic_source_key, ms.campaign_key;
GO

CREATE OR ALTER VIEW gold.newcustomersbycampaign AS
SELECT
    c.cohort_date_key            AS date_key,
    t.date_value, t.year, t.quarter, t.month, t.month_name,
    c.acquisition_source_key     AS traffic_source_key,
    ts.channel_group, ts.source, ts.medium,
    c.acquisition_campaign_key   AS campaign_key,
    cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name,
    COUNT_BIG(*)                 AS new_customers
FROM silver.customerdim c
LEFT JOIN silver.timedim t           ON t.date_key = c.cohort_date_key
LEFT JOIN silver.trafficsourcedim ts ON ts.traffic_source_key = c.acquisition_source_key
LEFT JOIN silver.campaigndim cam     ON cam.campaign_key      = c.acquisition_campaign_key
GROUP BY
    c.cohort_date_key, t.date_value, t.year, t.quarter, t.month, t.month_name,
    c.acquisition_source_key, ts.channel_group, ts.source, ts.medium,
    c.acquisition_campaign_key, cam.platform, cam.account_id, cam.campaign_id_nk, cam.campaign_name;
GO
