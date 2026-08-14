USE master;
GO

IF EXISTS (SELECT 1 from sys.Databases where name = 'Datawarehouse')
BEGIN
  Alter Database Datawarehouse set single_user with rollback immediate;
  Drop Database Datawarehouse;
END;
GO
CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse; 
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

if OBJECT_ID ('bronze.crm_cust_info', 'u') is not NULL
	drop table bronze.crm_cust_info ;

CREATE TABLE bronze.crm_cust_info(
cst_id int, cst_key nvarchar(50),	cst_firstname nvarchar(50),	cst_lastname nvarchar(50),	cst_marital_status nvarchar(50),	
cst_gndr nvarchar(50),
cst_create_date DATE
);

if OBJECT_ID('bronze.crm_prd_info', 'u') is not null
	drop table bronze.crm_prd_info;
CREATE table bronze.crm_prd_info(
prd_id int,	prd_key nvarchar(50), prd_nm nvarchar(50), prd_cost int, prd_line nvarchar(50), prd_start_dt DATE,prd_end_dt DATE);

if OBJECT_ID('bronze.crm_sales_details', 'u') is not null
	drop table bronze.crm_sales_details;
CREATE table bronze.crm_sales_details( sls_ord_num nvarchar(50),sls_prd_key nvarchar(50),sls_cust_id int,sls_order_dt int, sls_ship_dt int,
sls_due_dt int,	sls_sales int, sls_quantity int, sls_price int);


if OBJECT_ID('bronze.erp_cust_az12', 'u') is not null
	drop table bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
cid nvarchar(50),
BDATE DATE,
GEN nvarchar(50)
);

if OBJECT_ID('bronze.erp_loc_a101', 'u') is not null
	drop table bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
CID	nvarchar(50),
CNTRY nvarchar(50)
);

if OBJECT_ID('bronze.erp_px_cat_g1v2', 'u') is not null
	drop table bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
ID	nvarchar(50),
CAT	nvarchar(50),
SUBCAT nvarchar(50),
MAINTENANCE nvarchar(50)

);
EXEC bronze.load_bronze
CREATE OR ALTER procedure bronze.load_bronze AS
BEGIN
TRUNCATE TABLE bronze.crm_cust_info;
bulk insert bronze.crm_cust_info
from 'C:\Users\rsira\OneDrive\Desktop\SQL data set\cust_info.csv'
with(
	firstrow = 2,
	fieldterminator = ',',
	tablock
);

TRUNCATE TABLE bronze.crm_prd_info;
bulk insert bronze.crm_prd_info
from 'C:\Users\rsira\OneDrive\Desktop\SQL data set\prd_info.csv'
with(
	firstrow = 2,
	fieldterminator = ',',
	tablock
);
TRUNCATE TABLE bronze.crm_sales_details;
bulk insert bronze.crm_sales_details
from 'C:\Users\rsira\OneDrive\Desktop\SQL data set\sales_details.csv'
with(
	firstrow = 2,
	fieldterminator = ',',
	tablock
);
TRUNCATE TABLE bronze.erp_cust_az12;
bulk insert bronze.erp_cust_az12
from 'C:\Users\rsira\OneDrive\Desktop\SQL data set\cust_az12.csv'
with(
	firstrow = 2,
	fieldterminator = ',',
	tablock
);

TRUNCATE TABLE bronze.erp_loc_a101;
bulk insert bronze.erp_loc_a101
from 'C:\Users\rsira\OneDrive\Desktop\SQL data set\loc_a101.csv'
with(
	firstrow = 2,
	fieldterminator = ',',
	tablock
);

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
bulk insert bronze.erp_px_cat_g1v2
from 'C:\Users\rsira\OneDrive\Desktop\SQL data set\px_cat_g1v2.csv'
with(
	firstrow = 2,
	fieldterminator = ',',
	tablock
);
END




