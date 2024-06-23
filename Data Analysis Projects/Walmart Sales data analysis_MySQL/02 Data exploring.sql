SELECT * FROM walmart_sales.walmart_sales_clone;

-- Table for Revenue, costs, and gross income
SELECT 
    branch,
    city,
    ROUND(SUM(total), 2) AS total_revenue,
    ROUND(SUM(cogs), 2) AS total_cost,
    ROUND(SUM(gross_income), 2) AS total_gross_income
FROM
    walmart_sales_clone
GROUP BY branch , city
ORDER BY total_revenue DESC
;

-- Customer type numbers per branch
SELECT 
    tb1.branch,
     avg_rating,
    female_members_count,
    female_members_avg_rating,
    male_members_count,
    male_members_avg_rating,
	female_normal_customers,
    female_ncustomer_avg_rating,
    male_normal_customers,
    male_ncustomer_avg_rating
FROM
    (SELECT 
        branch, 
        COUNT(customer_type) AS female_members_count,
        ROUND(AVG(rating), 2) AS female_members_avg_rating
    FROM
        walmart_sales_clone
    WHERE
        customer_type = 'Member'
            AND gender = 'Female'
    GROUP BY branch) tb1
LEFT JOIN
    (SELECT 
        branch,
        COUNT(customer_type) AS male_members_count,
        ROUND(AVG(rating), 2) AS male_members_avg_rating
    FROM
        walmart_sales_clone
    WHERE
        customer_type = 'Member'
            AND gender = 'Male'
    GROUP BY branch) tb2 
ON tb1.branch = tb2.branch
LEFT JOIN
    (SELECT 
        branch,
        COUNT(customer_type) AS female_normal_customers,
        ROUND(AVG(rating), 2) AS female_ncustomer_avg_rating
    FROM
        walmart_sales_clone
    WHERE
        customer_type = 'Normal'
            AND gender = 'Female'
    GROUP BY branch) tb3 
ON tb1.branch = tb3.branch
LEFT JOIN
    (SELECT 
        branch, 
        COUNT(customer_type) AS male_normal_customers,
        ROUND(AVG(rating), 2) AS male_ncustomer_avg_rating
    FROM
        walmart_sales_clone
    WHERE
        customer_type = 'Normal'
            AND gender = 'Male'
    GROUP BY branch) tb4 
ON tb1.branch = tb4.branch
    LEFT JOIN
    (SELECT 
		branch, 
		ROUND(AVG(rating), 2) AS avg_rating
	FROM walmart_sales_clone
	GROUP BY branch) tb5
ON tb1.branch = tb5.branch
;

-- Revenue, cost and gross profit by prodution line
SELECT 
    product_line,
    COUNT(DISTINCT invoice_id) AS number_of_orders,
    SUM(quantity) AS items_sold_qty,
    ROUND(SUM(total), 2) AS total_revenue,
    ROUND(SUM(cogs),2) AS total_cost,
    ROUND(SUM(gross_income),2) AS total_gross_income
FROM
    walmart_sales_clone
GROUP BY product_line
ORDER BY total_revenue DESC
;

-- Check sales per weekdays
SELECT 
    DAYNAME(`date`) AS week_day,
    ROUND(SUM(total), 2) AS total_revenue,
    COUNT(invoice_id) AS number_of_orders
FROM
    walmart_sales_clone
GROUP BY week_day
ORDER BY total_revenue DESC
;

-- check sales per shift from 8AM to 4PM shift_1, from 4PM to 12AM shift_2, from 12AM to 8AM shift_3
SELECT 
CASE
WHEN `time` BETWEEN '08:00:00' AND '16:00:00' THEN 'morning_shift'
WHEN `time` BETWEEN '16:01:00' AND '23:59:59' THEN 'evening_shift'
END AS daily_shifts,
ROUND(SUM(total), 2) AS total_revenue,
    COUNT(invoice_id) AS number_of_orders
FROM walmart_sales_clone
GROUP BY daily_shifts
; 

-- Sorting orders quantity by product line and gender
SELECT tb1.product_line, orders_by_males, orders_by_females
FROM
(SELECT 
    product_line,
    COUNT(gender) AS orders_by_males
FROM
    walmart_sales_clone
    WHERE gender = 'Male'
GROUP BY product_line) tb1
LEFT JOIN (SELECT 
    product_line,
    COUNT(gender) AS orders_by_females
FROM
    walmart_sales_clone
    WHERE gender = 'Female'
GROUP BY product_line) tb2
ON tb1.product_line = tb2.product_line
;

-- AVG rating per branch and product line
SELECT branch, product_line,
ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_sales_clone
GROUP BY branch, product_line
ORDER BY branch ASC , avg_rating DESC
;

-- Prefered payment method
SELECT payment, COUNT(payment) AS number_of_orders
FROM walmart_sales_clone
GROUP BY payment
;

-- Gross income per product line
SELECT 
    product_line,
    ROUND(SUM(cogs), 2) AS cogs_product,
    ROUND(SUM(gross_income), 2) AS gross_income_product
FROM
    walmart_sales_clone
GROUP BY product_line
ORDER BY gross_income_product DESC
;