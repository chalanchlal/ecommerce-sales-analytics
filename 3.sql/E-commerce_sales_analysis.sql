CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE Dim_Customers (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    State VARCHAR(50),
    City VARCHAR(50),
    Segment VARCHAR(50)
);

CREATE TABLE Dim_Products (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Unit_Price DECIMAL(12,2)
);



CREATE TABLE Dim_Date (
    Date DATE PRIMARY KEY,
    Year INT,
    Month INT,
    Month_Name VARCHAR(20),
    Quarter VARCHAR(5)
);

CREATE TABLE Fact_Orders (
    Order_ID VARCHAR(10) PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Quantity INT,
    Discount DECIMAL(5,2),
    Sales DECIMAL(12,2),
    Profit DECIMAL(12,2),

    FOREIGN KEY (Customer_ID)
        REFERENCES Dim_Customers(Customer_ID),

    FOREIGN KEY (Product_ID)
        REFERENCES Dim_Products(Product_ID),

    FOREIGN KEY (Order_Date)
        REFERENCES Dim_Date(Date)
);

select * from Dim_Customers;

SELECT COUNT(*) AS Customer_Count
FROM Dim_Customers;

SELECT COUNT(*) AS Product_Count
FROM Dim_Products;

SELECT COUNT(*) AS Date_Count
FROM Dim_Date;

SELECT COUNT(*) AS Order_Count
FROM Fact_Orders;

SELECT *
FROM Fact_Orders
LIMIT 10;

SELECT 
    SUM(Sales) AS Total_Sales
FROM Fact_Orders;

select
sum(profit) as total_profit
from fact_orders;

select
    count(distinct order_id) as total_orders
from fact_orders;

SELECT 
    SUM(Sales) / COUNT(DISTINCT Order_ID) AS Average_Order_Value
FROM Fact_Orders;

SELECT 
    (SUM(Profit) / SUM(Sales)) * 100 AS Profit_Margin
FROM Fact_Orders;

SELECT
    p.Category,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Orders f
JOIN Dim_Products p
    ON f.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Sales DESC;

SELECT
    p.Product_Name,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Orders f
JOIN Dim_Products p
    ON f.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    c.State,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Orders f
JOIN Dim_Customers c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.State
ORDER BY Total_Sales DESC;

SELECT
    d.Year,
    d.Month,
    d.Month_Name,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Orders f
JOIN Dim_Date d
    ON f.Order_Date = d.Date
GROUP BY d.Year, d.Month, d.Month_Name
ORDER BY d.Year, d.Month;

SELECT
    c.Segment,
    COUNT(DISTINCT f.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Orders f
JOIN Dim_Customers c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY Total_Sales DESC;

SELECT
    p.Category,
    p.Sub_Category,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Orders f
JOIN Dim_Products p
    ON f.Product_ID = p.Product_ID
GROUP BY p.Category, p.Sub_Category
ORDER BY Total_Sales DESC;

SELECT
    f.Customer_ID,
    c.Customer_Name,
    c.Segment,
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Orders f
JOIN Dim_Customers c
    ON f.Customer_ID = c.Customer_ID
GROUP BY
    f.Customer_ID,
    c.Customer_Name,
    c.Segment
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    Discount,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit) AS Average_Profit
FROM Fact_Orders
GROUP BY Discount
ORDER BY Discount;

CREATE OR REPLACE VIEW vw_sales_analysis AS
SELECT
    f.Order_ID,
    f.Order_Date,
    f.Customer_ID,
    c.Customer_Name,
    c.State,
    c.City,
    c.Segment,
    f.Product_ID,
    p.Product_Name,
    p.Category,
    p.Sub_Category,
    f.Quantity,
    f.Discount,
    f.Sales,
    f.Profit
FROM Fact_Orders f
JOIN Dim_Customers c
    ON f.Customer_ID = c.Customer_ID
JOIN Dim_Products p
    ON f.Product_ID = p.Product_ID;
    
    SELECT *
FROM vw_sales_analysis
LIMIT 10;