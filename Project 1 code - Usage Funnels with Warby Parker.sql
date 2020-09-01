--2. Quiz Funnel
--2.1 Columns on the Survey table
SELECT *
FROM survey
LIMIT 10;

-- 2.2 Number of responses for each question (bar graph completed on Excel)
SELECT question AS Question, 
	COUNT(user_id) AS 'Number of responses'
FROM survey
GROUP BY 1;

--3. Home Try-On Funnel
--3.1 Looking at the data (limit to 5 rows)
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

--3.2 Home_Try_On_Funnel table
WITH home_try_on_funnel AS (
 SELECT DISTINCT q.user_id, 
   CASE
     WHEN h.user_id IS NOT NULL THEN 'True'
     ELSE 'False'
     END AS 'is_home_try_on', 
   CASE
     WHEN h.number_of_pairs IS NULL THEN 'N/A'
     ELSE h.number_of_pairs
     END AS 'number_of_pairs',
   CASE
     WHEN p.user_id IS NOT NULL THEN 'True'
     ELSE 'False'
     END AS 'is_purchase'
 FROM quiz AS q
 LEFT JOIN home_try_on AS h
 	ON h.user_id = q.user_id
 LEFT JOIN purchase AS p
 	ON p.user_id = q.user_id)
SELECT *
FROM home_try_on_funnel
LIMIT 10;

--4. Actionable Insights
--Slide 15 (column D calculated on Excel)
WITH home_try_on_funnel AS(
 SELECT DISTINCT q.user_id, 
   CASE
     WHEN h.user_id IS NOT NULL THEN 'True'
     ELSE 'False'
     END AS 'is_home_try_on', 
   h.number_of_pairs,
   CASE
     WHEN p.user_id IS NOT NULL THEN 'True'
     ELSE 'False'
     END AS 'is_purchase'
 FROM quiz AS q
 LEFT JOIN home_try_on AS h
 	ON h.user_id = q.user_id
 LEFT JOIN purchase AS p
 	ON p.user_id = q.user_id)
SELECT number_of_pairs, is_purchase,
  COUNT(is_purchase) AS 'Number of purchases'
FROM home_try_on_funnel
GROUP BY 1, 2
HAVING number_of_pairs IS NOT NULL;

--Slide 16 (columns D-F calculated on Excel)
WITH home_try_on_funnel AS(
 SELECT DISTINCT q.user_id, 
   CASE
     WHEN h.user_id IS NOT NULL THEN 'True'
     ELSE 'False'
     END AS 'is_home_try_on', 
   h.number_of_pairs,
   CASE
     WHEN p.user_id IS NOT NULL THEN 'True'
     ELSE 'False'
     END AS 'is_purchase'
 FROM quiz AS q
 LEFT JOIN home_try_on AS h
 	ON h.user_id = q.user_id
 LEFT JOIN purchase AS p
 	ON p.user_id = q.user_id)
SELECT COUNT(user_id) AS 'Users that completed the quiz', 
  COUNT(number_of_pairs) AS 'Users that did at home try-on',
  (SELECT COUNT(is_purchase) 
  FROM home_try_on_funnel 
  WHERE is_purchase = 'True') AS 'Users that made a purchase'
FROM home_try_on_funnel;

--Purchases by color (results from the code below were used to produce the graph on excel)
SELECT color 
FROM purchase
GROUP BY 1;

SELECT CASE
    WHEN color LIKE '%Tortoise%' THEN 'Tortoise'
    WHEN color LIKE '%Crystal%' THEN 'Crystal'
    WHEN color LIKE '%Fade%' THEN 'Fade'
    WHEN color LIKE '%Black%' THEN 'Black'
    ELSE 'Gray'
    END AS 'group_color',
  COUNT(*) AS 'number of purchases'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

--Purchases by price (results from the code below were used to produce the graph on excel)
SELECT price, 
  COUNT(*) AS 'number of purchases'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

--Slide 18
SELECT model_name, color, price
FROM purchase
GROUP BY 1, 2
ORDER BY 3 DESC;
