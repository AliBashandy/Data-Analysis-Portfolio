SELECT 
    *
FROM
    walmart_sales_raw;

-- Create table from the raw data to work on
DROP TABLE walmart_sales_clone ;
CREATE TABLE walmart_sales_clone 
SELECT * 
FROM
    walmart_sales_raw;

-- 1st Cleaning phase
SELECT * 
From
	walmart_sales_clone;

-- Updating date format in date column
select `Date`,
-- date_format(`Date`, '%Y/%m/%d')
str_to_date(`Date`, '%Y-%m-%d')
From walmart_sales_clone;
UPDATE walmart_sales_clone
SET `Date` = str_to_date(`Date`, '%Y-%m-%d');
ALTER TABLE walmart_sales_clone
MODIFY COLUMN `Date` DATE;

-- Updating time format in time column only modify the schema type
ALTER TABLE walmart_sales_clone
MODIFY COLUMN `Time` TIME;

-- standarize column names to be easier in query
ALTER TABLE walmart_sales_clone
RENAME COLUMN `Invoice ID` to invoice_id, 
RENAME COLUMN `Branch` to branch, 
RENAME COLUMN City to city, 
RENAME COLUMN `Customer type` to customer_type, 
RENAME COLUMN Gender to gender, 
RENAME COLUMN `Product line` to product_line, 
RENAME COLUMN `Unit price` to unit_price, 
RENAME COLUMN Quantity to quantity, 
RENAME COLUMN `Tax 5%` to tax_5_percent,
RENAME COLUMN Total to total, 
RENAME COLUMN `Date` to `date`,
RENAME COLUMN `Time` to `time`, 
RENAME COLUMN Payment to payment, 
RENAME COLUMN `gross margin percentage` to gross_marg_percentage, 
RENAME COLUMN `gross income` to gross_income,
RENAME COLUMN Rating to rating
;

-- Checking for duplicates
WITH duplicate_checker AS
	(
    SELECT*,
	ROW_NUMBER()OVER( 
        PARTITION BY invoice_id, branch, city, customer_type, gender,
        product_line, unit_price, quantity, tax_5_percent, total, 
        `date`, `time`, payment, cogs, gross_marg_percentage, gross_income, rating
					) AS row_num
	FROM walmart_sales_clone
    )
    SELECT *
FROM duplicate_checker
where row_num > 1;
-- there is no duplicates

-- format the number to 2 decimal places
UPDATE walmart_sales_clone
SET tax_5_percent = ROUND(tax_5_percent, 2),
total = ROUND(total, 2),
gross_marg_percentage = ROUND(gross_marg_percentage, 2),
gross_income = ROUND(gross_income, 2);