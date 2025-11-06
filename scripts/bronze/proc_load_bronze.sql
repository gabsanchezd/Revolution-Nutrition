/*
=========================================================================================================
Stored Procedure: Load Bronze Layer (Source ->Bronze)
=========================================================================================================
Script Purpose:
  The stored procedure loads data into the `bronze` schema layer from external CSV files.
  It performs the functions:
    -Truncates the bronze tables before loading data.
    -Uses the `BULK INSERT` command to load data from csv files to bronze tables.

Usage Example:
  EXEC bronze.load_bronze;

========================================================================================================
*/  

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
	PRINT '=============================================================';
	PRINT 'Loading Bronze Layer';
	PRINT '=============================================================';

	PRINT '-------------------------------------------------------------';
	PRINT 'Loading bronze.ChannelDim';
	PRINT '-------------------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT '>>>>Truncating Table: bronze.timedim';
	TRUNCATE TABLE bronze.timedim;

	PRINT '>>>>Inserting Data Into: bronze.timedim';
	BULK INSERT bronze.timedim
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\timedim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time = GETDATE();
	PRINT '>>>>Truncating Table: bronze.trafficsourcedim';
	TRUNCATE TABLE bronze.trafficsourcedim;

	PRINT '>>>>Inserting Data Into: bronze.trafficsourcedim';
	BULK INSERT bronze.trafficsourcedim
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\trafficsourcedim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.campaigndim';
	TRUNCATE TABLE bronze.campaigndim;

	PRINT '>>>>Inserting Data Into: campaigndim';
	BULK INSERT bronze.campaigndim
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\campaigndim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.productdim';
	TRUNCATE TABLE bronze.productdim;

	PRINT '>>>>Inserting Data Into: productdim';
	BULK INSERT bronze.productdim
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\productdim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: customerdim';
	TRUNCATE TABLE bronze.customerdim;

	PRINT '>>>>Inserting Data Into: bronze.crm_cust_info';
	BULK INSERT bronze.customerdim
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\customerdim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: websessionfact';
	TRUNCATE TABLE bronze.websessionfact;

	PRINT '>>>>Inserting Data Into: websessionfact';
	BULK INSERT bronze.websessionfact
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\websessionfact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.orderfact';
	TRUNCATE TABLE bronze.orderfact;

	PRINT '>>>>Inserting Data Into: bronze.orderfact';
	BULK INSERT bronze.orderfact
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\orderfact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: orderlinefact';
	TRUNCATE TABLE bronze.orderlinefact;

	PRINT '>>>>Inserting Data Into: bronze.orderlinefact';
	BULK INSERT bronze.orderlinefact
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\orderlinefact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.marketingspendfact';
	TRUNCATE TABLE bronze.marketingspendfact;

	PRINT '>>>>Inserting Data Into: bronze.marketingspendfact';
	BULK INSERT bronze.marketingspendfact
	FROM 'C:\Users\Patrick Sanchez\Downloads\revolution_nutrition_rn_dataset\marketingspendfact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

		SET @batch_end_time = GETDATE();
		PRINT '================================================================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '     - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================================='
	END TRY
	BEGIN CATCH
		PRINT '================================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '================================================================='
	END CATCH
END
