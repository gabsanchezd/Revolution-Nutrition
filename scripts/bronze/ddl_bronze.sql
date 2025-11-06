/*
==============================================================================
DDL Script: Create Bronze Tables
This script creates tables in the 'bronze' schema layer architecture, dropping
existing tables if they already exist.

Run this script to redefine the DDL structure of 'bronze' layer tables.
==============================================================================
*/

IF OBJECT_ID ('bronze.timedim' , 'U') IS NOT NULL
    DROP TABLE bronze.timedim;
CREATE TABLE bronze.timedim (
  date_key       INT PRIMARY KEY,  
  date_value     DATE NOT NULL,
  month          TINYINT,
  month_name     VARCHAR(9),
  quarter        TINYINT,
  year           SMALLINT
);

IF OBJECT_ID ('bronze.trafficsourcedim' , 'U') IS NOT NULL
    DROP TABLE bronze.trafficsourcedim;
CREATE TABLE bronze.trafficsourcedim (
  traffic_source_key INT PRIMARY KEY,
  channel_group      VARCHAR(40),
  source             VARCHAR(100),
  medium             VARCHAR(100),
);


IF OBJECT_ID ('bronze.campaigndim' , 'U') IS NOT NULL
    DROP TABLE bronze.campaigndim;

CREATE TABLE bronze.campaigndim (
  campaign_key    INT PRIMARY KEY,
  platform        VARCHAR(40),      
  account_id      VARCHAR(64),
  campaign_id_nk  VARCHAR(120),
  campaign_name   VARCHAR(255),

);

IF OBJECT_ID ('bronze.employeeDim' , 'U') IS NOT NULL
    DROP TABLE bronze.employeeDim;
CREATE TABLE bronze.employeeDim (
    EmployeeID     INT            NOT NULL PRIMARY KEY,
    EmployeeName   NVARCHAR(100)  NULL,
    [Role]         NVARCHAR(50)   NULL,
    Department     NVARCHAR(50)   NULL,
    SalesRegion    NVARCHAR(100)  NULL,
    CommissionRate DECIMAL(5,2)   NULL
);

IF OBJECT_ID ('bronze.productdim' , 'U') IS NOT NULL
    DROP TABLE bronze.productdim;
CREATE TABLE bronze.productdim (
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


IF OBJECT_ID ('bronze.customerdim' , 'U') IS NOT NULL
    DROP TABLE bronze.customerdim;
CREATE TABLE bronze.customerdim (
  customer_key             BIGINT PRIMARY KEY,
  customer_id_nk           VARCHAR(64),
  cohort_date_key          INT NULL,
  acquisition_source_key   INT NULL,
  acquisition_campaign_key INT NULL
);

IF OBJECT_ID ('bronze.websessionfact' , 'U') IS NOT NULL
    DROP TABLE bronze.websessionfact;
CREATE TABLE bronze.websessionfact (
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


IF OBJECT_ID ('bronze.orderfact' , 'U') IS NOT NULL
    DROP TABLE bronze.orderfact;
CREATE TABLE bronze.orderfact (
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


IF OBJECT_ID ('bronze.orderlinefact' , 'U') IS NOT NULL
    DROP TABLE bronze.orderlinefact;
CREATE TABLE bronze.orderlinefact (
  order_line_key BIGINT PRIMARY KEY,
  order_key      BIGINT NOT NULL,
  product_key    INT NOT NULL,
  qty            INT,
  item_price     DECIMAL(12,2),
  line_discount  DECIMAL(12,2),
);

IF OBJECT_ID ('bronze.marketingspendfact' , 'U') IS NOT NULL
    DROP TABLE bronze.marketingspendfact;
CREATE TABLE bronze.marketingspendfact (
  spend_key           BIGINT PRIMARY KEY,
  date_key            INT NOT NULL,
  traffic_source_key  INT NOT NULL,
  campaign_key        INT NULL,
  clicks              BIGINT,
  impressions         BIGINT,
  spend_amount        DECIMAL(14,2),
);
