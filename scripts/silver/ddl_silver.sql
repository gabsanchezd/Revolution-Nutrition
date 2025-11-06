/*
==============================================================================
DDL Script: Create Silver Tables
This script creates tables in the 'silver' schema layer architecture, dropping
existing tables if they already exist.

Run this script to redefine the DDL structure of 'silver' layer tables.
==============================================================================
*/

IF OBJECT_ID ('silver.timedim' , 'U') IS NOT NULL
    DROP TABLE silver.timedim;
CREATE TABLE silver.timedim (
  date_key       INT PRIMARY KEY,  
  date_value     DATE NOT NULL,
  month          TINYINT,
  month_name     VARCHAR(9),
  quarter        TINYINT,
  year           SMALLINT
);

IF OBJECT_ID ('silver.trafficsourcedim' , 'U') IS NOT NULL
    DROP TABLE silver.trafficsourcedim;
CREATE TABLE silver.trafficsourcedim (
  traffic_source_key INT PRIMARY KEY,
  channel_group      VARCHAR(40),
  source             VARCHAR(100),
  medium             VARCHAR(100),
);


IF OBJECT_ID ('silver.campaigndim' , 'U') IS NOT NULL
    DROP TABLE silver.campaigndim;

CREATE TABLE silver.campaigndim (
  campaign_key    INT PRIMARY KEY,
  platform        VARCHAR(40),      
  account_id      VARCHAR(64),
  campaign_id_nk  VARCHAR(120),
  campaign_name   VARCHAR(255),

);

IF OBJECT_ID ('silver.employeeDim' , 'U') IS NOT NULL
    DROP TABLE silver.employeeDim;
CREATE TABLE silver.employeeDim (
    EmployeeID     INT            NOT NULL PRIMARY KEY,
    EmployeeName   NVARCHAR(100)  NULL,
    [Role]         NVARCHAR(50)   NULL,
    Department     NVARCHAR(50)   NULL,
    SalesRegion    NVARCHAR(100)  NULL,
    CommissionRate DECIMAL(5,2)   NULL
);

IF OBJECT_ID ('silver.productdim' , 'U') IS NOT NULL
    DROP TABLE silver.productdim;
CREATE TABLE silver.productdim (
  product_key     INT PRIMARY KEY,
  sku             VARCHAR(64),
  product_name    VARCHAR(255),
  brand           VARCHAR(120),
  category        VARCHAR(120),
  subcategory     VARCHAR(120),
  flavor          VARCHAR(80),
  net_content_g   INT,
  servings_per_unit DECIMAL(7,2)
);


IF OBJECT_ID ('silver.customerdim' , 'U') IS NOT NULL
    DROP TABLE silver.customerdim;
CREATE TABLE silver.customerdim (
  customer_key             BIGINT PRIMARY KEY,
  customer_id_nk           VARCHAR(64),
  cohort_date_key          INT NULL,
  acquisition_source_key   INT NULL,
  acquisition_campaign_key INT NULL
);

IF OBJECT_ID ('silver.websessionfact' , 'U') IS NOT NULL
    DROP TABLE silver.websessionfact;
CREATE TABLE silver.websessionfact (
  session_key        BIGINT PRIMARY KEY,
  session_id_nk      VARCHAR(64) NOT NULL,
  date_key           INT NOT NULL,
  traffic_source_key INT NULL,
  campaign_key       INT NULL,
  pageviews          INT,
  pdp_views          INT,
  add_to_carts       INT,
  checkout_starts    INT,
  orders_in_session  INT
);


IF OBJECT_ID ('silver.orderfact' , 'U') IS NOT NULL
    DROP TABLE silver.orderfact;
CREATE TABLE silver.orderfact (
  order_key        BIGINT PRIMARY KEY,
  order_id_nk      VARCHAR(64) NOT NULL,
  date_key         INT NOT NULL,
  customer_key     BIGINT NOT NULL,
  session_key      BIGINT NULL,
  campaign_key     INT NULL,
  revenue_amount   DECIMAL(14,2),
  discount_amount  DECIMAL(12,2),
  shipping_amount  DECIMAL(12,2),
  payment_fees     DECIMAL(12,2) NULL,
  cogs_amount      DECIMAL(14,2),
  refund_amount    DECIMAL(14,2) DEFAULT 0
);


IF OBJECT_ID ('silver.orderlinefact' , 'U') IS NOT NULL
    DROP TABLE silver.orderlinefact;
CREATE TABLE silver.orderlinefact (
  order_line_key BIGINT PRIMARY KEY,
  order_key      BIGINT NOT NULL,
  product_key    INT NOT NULL,
  qty            INT,
  item_price     DECIMAL(12,2),
  line_discount  DECIMAL(12,2),
);

IF OBJECT_ID ('silver.marketingspendfact' , 'U') IS NOT NULL
    DROP TABLE silver.marketingspendfact;
CREATE TABLE silver.marketingspendfact (
  spend_key           BIGINT PRIMARY KEY,
  date_key            INT NOT NULL,
  traffic_source_key  INT NOT NULL,
  campaign_key        INT NULL,
  clicks              BIGINT,
  impressions         BIGINT,
  spend_amount        DECIMAL(14,2),
);
