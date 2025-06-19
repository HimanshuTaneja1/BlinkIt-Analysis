SELECT * FROM blinkit_data

SELECT COUNT(*) FROM blinkit_data

UPDATE blinkit_data
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT (Item_Fat_Content) FROM blinkit_data


-- conversion of Total sales in Millions -------
SELECT CONCAT(CAST(SUM(Sales)/1000000 AS Decimal(10,2)), ' M') AS Total_Sales_Millions
FROM blinkit_data;

----- Average Sales--------------
SELECT CONCAT(CAST(AVG(Sales) AS DECIMAL (10,0)), ' M') AS Avg_Sales FROM blinkit_data

-----------Total Items ---------------
SELECT COUNT(*) AS No_Of_Items FROM blinkit_data


------Averagge Rating ----------
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM blinkit_data



---------------Total Sales by Fat Content ------------------------

SELECT Item_Fat_Content , 
    CONCAT(CAST(SUM(Sales)/1000 AS DECIMAL(10,2)), ' K') AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL (10,2)) AS Avg_Rating
From blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC


------------------Total Sales by Item type----------------------

SELECT TOP 5 Item_Type , 
    CAST(SUM(Sales)/1000 AS DECIMAL(10,2))AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL (10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC



---------------------FAT CONTENT BY TOTAL SALES AND OUTLET ------------------


SELECT Outlet_Location_Type,Item_Fat_Content, 
    CAST(SUM(Sales)/1000 AS DECIMAL(10,2))AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL (10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Outlet_Location_Type,Item_Fat_Content
ORDER BY Total_Sales ASC

--------------------------------------------------------

SELECT Outlet_Location_Type,
ISNULL([Low Fat], 0) AS Low_Fat,
ISNULL ([Regular],0) AS Regular
FROM
(SELECT Outlet_Location_Type,Item_Fat_Content,
        CAST(SUM(Sales) AS Decimal(10,2)) AS Total_Sales
		FROM blinkit_data
		GROUP BY Outlet_Location_Type,Item_Fat_Content
		) AS SourceTable
		PIVOT
(
SUM(Total_Sales)
FOR Item_Fat_Content IN ([Low Fat],[Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


----------------------------Total Sales by Outlet Establishment --------------------------------------------



SELECT Outlet_Establishment_Year, 
    CAST(SUM(Sales)/1000 AS DECIMAL(10,2))AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL (10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC

-------------------------------Percentage of Sales by Outet Size-------------------------------------------------


SELECT Outlet_Size,
CAST(SUM(Sales) AS DECIMAL(10,2) ) AS Total_Sales,
CAST((SUM(Sales)* 100.0/SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
From blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


---------------------------------Outlet_Location_Type---------------------

SELECT Outlet_Location_Type,
     CAST(SUM(Sales) AS DECIMAL(10,2) ) AS Total_Sales,
     CAST((SUM(Sales)* 100.0/SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
     COUNT(*) AS No_Of_Items,
     CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
From blinkit_data
WHERE Outlet_Establishment_Year =2022
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;


-------------------------------ALL METRICS BY OUTLET TYPE---------------------------

SELECT Outlet_Type,
     CAST(SUM(Sales) AS DECIMAL(10,2) ) AS Total_Sales,
     CAST((SUM(Sales)* 100.0/SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
	 CAST(AVG(Sales) AS Decimal(10,2)) AS Avg_Rating,
     COUNT(*) AS No_Of_Items,
     CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
From blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
