use electric_vehicle;

-- 1. Total Sales:
SELECT 
  SUM(EV_Sales_Quantity) 
FROM 
  ev_sales;
  
--   2.State Wise Sales : 
SELECT 
  state, 
  SUM(EV_Sales_Quantity) AS state_wise_sales, 
  ROUND(
    100.0 * SUM(EV_Sales_Quantity) / SUM(
      SUM(EV_Sales_Quantity)
    ) OVER (), 
    2
  ) AS percentage_contribution 
FROM 
  ev_sales 
GROUP BY 
  state 
ORDER BY 
  state_wise_sales DESC;

-- 3.Year - wise sales : 
SELECT 
  YEAR(`Date`) AS sales_year, 
  SUM(EV_Sales_Quantity) AS total_sales 
FROM 
  ev_sales 
GROUP BY 
  sales_year 
ORDER BY 
  SUM(EV_Sales_Quantity) DESC;

-- 4.Distribution of sales by vehicle class (2W, 3W, 4W): 
SELECT 
  Vehicle_Category, 
  SUM(EV_Sales_Quantity) as 'Total Sales' 
from 
  ev_sales 
GROUP BY 
  Vehicle_Category 
ORDER BY 
  SUM(EV_Sales_Quantity) DESC;
  
-- 5.Compare personal vs commercial vs others usage : 
SELECT 
  SUM(EV_Sales_Quantity) AS total_sales, 
  'Personal' AS category 
FROM 
  ev_sales 
WHERE 
  vehicle_type LIKE '%Personal%' 
UNION ALL 
SELECT 
  SUM(EV_Sales_Quantity) AS total_sales, 
  'Commercial' AS category 
FROM 
  ev_sales 
WHERE 
  vehicle_type NOT LIKE '%Personal%' 
  AND vehicle_type <> 'Others' 
UNION ALL 
SELECT 
  SUM(EV_Sales_Quantity) AS total_sales, 
  'Others' AS category 
FROM 
  ev_sales 
WHERE 
  vehicle_type LIKE '%Others%';

-- 6.Elaborate the details of above : 
SELECT 
  vehicle_type, 
  SUM(EV_Sales_Quantity) AS total_sales, 
  'Personal' AS category 
FROM 
  ev_sales 
WHERE 
  vehicle_type LIKE '%Personal%' 
GROUP BY 
  vehicle_type 
UNION ALL 
SELECT 
  vehicle_type, 
  SUM(EV_Sales_Quantity) AS total_sales, 
  'Commercial' AS category 
FROM 
  ev_sales 
WHERE 
  vehicle_type NOT LIKE '%Personal%' 
GROUP BY 
  vehicle_type 
UNION ALL 
SELECT 
  vehicle_type, 
  SUM(EV_Sales_Quantity) AS total_sales, 
  'Others' AS category 
FROM 
  ev_sales 
WHERE 
  vehicle_type LIKE '%Others%' 
GROUP BY 
  vehicle_type 
ORDER BY 
  CASE WHEN category = 'Commercial' THEN 2 WHEN category = 'Personal' THEN 1 WHEN category = 'Others' THEN 3 ELSE 4 END;

-- 7.Identify most popular vehicle types.
SELECT 
  Vehicle_category, 
  Vehicle_Type, 
  SUM(EV_Sales_Quantity) AS total_sales 
FROM 
  ev_sales 
GROUP BY 
  Vehicle_category, 
  Vehicle_type 
ORDER BY 
  total_sales DESC;

-- 8.Most popular vehicle type in each state 
SELECT 
  state, 
  vehicle_type, 
  total_sales 
FROM 
  (
    SELECT 
      state, 
      SUM(EV_Sales_Quantity) AS total_sales, 
      vehicle_type, 
      RANK() OVER (
        PARTITION BY state 
        ORDER BY 
          SUM(EV_Sales_Quantity) DESC
      ) AS sales_rank 
    FROM 
      ev_sales 
    GROUP BY 
      state, 
      vehicle_type
  ) AS sales 
WHERE 
  sales_rank = 1;

