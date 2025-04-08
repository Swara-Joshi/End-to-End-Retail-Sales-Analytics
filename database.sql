-- First, either create a new database (if you don't have one yet)
CREATE DATABASE SALES_RETAIL_DB;

-- Then use the database
USE DATABASE SALES_RETAIL_DB;

-- Dimension Table: DimDate
CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    DayOfWeek VARCHAR(10),
    Month VARCHAR(10),
    Quarter INT,
    Year INT,
    IsWeekend BOOLEAN
);

-- Dimension Table: DimCustomer
CREATE TABLE DimCustomer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(10),
    DateOfBirth DATE,
    Email VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Country VARCHAR(50),
    LoyaltyProgramID INT
);

-- Dimension Table: DimProduct
CREATE TABLE DimProduct (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    UnitPrice DECIMAL(10, 2)
);

-- Dimension Table: DimStore
CREATE TABLE DimStore (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    StoreName VARCHAR(100),
    StoreType VARCHAR(50),
    StoreOpeningDate DATE,
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Country VARCHAR(50),
    ManagerName VARCHAR(100)
);

-- Dimension Table: DimLoyaltyProgram
CREATE TABLE DimLoyaltyProgram (
    LoyaltyProgramID INT PRIMARY KEY,
    ProgramName VARCHAR(100),
    ProgramTier VARCHAR(50),
    PointsAccrued INT
);

-- Fact Table: FactOrders
CREATE TABLE FactOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    StoreID INT,
    QuantityOrdered INT,
    OrderAmount DECIMAL(10, 2),
    DiscountAmount DECIMAL(10, 2),
    ShippingCost DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (StoreID) REFERENCES DimStore(StoreID)
);

CREATE WAREHOUSE IF NOT EXISTS MY_WAREHOUSE
WITH 
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE;
    
USE WAREHOUSE MY_WAREHOUSE;

-- 1. Insert data into DimDate table (sample dates for 2023)
INSERT INTO DimDate (DateID, Date, DayOfWeek, Month, Quarter, Year, IsWeekend)
VALUES
    (20230101, '2023-01-01', 'Sunday', 'January', 1, 2023, TRUE),
    (20230102, '2023-01-02', 'Monday', 'January', 1, 2023, FALSE),
    (20230115, '2023-01-15', 'Sunday', 'January', 1, 2023, TRUE),
    (20230220, '2023-02-20', 'Monday', 'February', 1, 2023, FALSE),
    (20230315, '2023-03-15', 'Wednesday', 'March', 1, 2023, FALSE),
    (20230410, '2023-04-10', 'Monday', 'April', 2, 2023, FALSE),
    (20230505, '2023-05-05', 'Friday', 'May', 2, 2023, FALSE),
    (20230620, '2023-06-20', 'Tuesday', 'June', 2, 2023, FALSE),
    (20230704, '2023-07-04', 'Tuesday', 'July', 3, 2023, FALSE),
    (20230815, '2023-08-15', 'Tuesday', 'August', 3, 2023, FALSE);

-- 2. Insert data into DimLoyaltyProgram table (as you already have)
INSERT INTO DimLoyaltyProgram (LoyaltyProgramID, ProgramName, ProgramTier, PointsAccrued)
VALUES
    (1, 'Gold Rewards', 'Gold', 1500),
    (2, 'Platinum Perks', 'Platinum', 2500),
    (3, 'Silver Savers', 'Silver', 800),
    (4, 'Bronze Benefits', 'Bronze', 400),
    (5, 'Exclusive Elite', 'Elite', 3000);

-- 3. Insert data into DimCustomer table
INSERT INTO DimCustomer (FirstName, LastName, Gender, DateOfBirth, Email, Address, City, State, ZipCode, Country, LoyaltyProgramID)
VALUES
    ('John', 'Smith', 'Male', '1985-03-15', 'john.smith@email.com', '123 Main St', 'New York', 'NY', '10001', 'USA', 1),
    ('Emma', 'Johnson', 'Female', '1990-07-22', 'emma.j@email.com', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 2),
    ('Michael', 'Brown', 'Male', '1982-11-30', 'michael.b@email.com', '789 Pine Rd', 'Chicago', 'IL', '60007', 'USA', 3),
    ('Sophia', 'Williams', 'Female', '1995-04-18', 'sophia.w@email.com', '101 Maple Dr', 'Houston', 'TX', '77001', 'USA', 4),
    ('James', 'Miller', 'Male', '1988-09-05', 'james.m@email.com', '202 Cedar Ln', 'Philadelphia', 'PA', '19019', 'USA', 5),
    ('Olivia', 'Davis', 'Female', '1992-12-10', 'olivia.d@email.com', '303 Birch Blvd', 'Phoenix', 'AZ', '85001', 'USA', 1),
    ('Robert', 'Garcia', 'Male', '1979-06-28', 'robert.g@email.com', '404 Elm St', 'San Antonio', 'TX', '78201', 'USA', 2),
    ('Ava', 'Martinez', 'Female', '1993-02-14', 'ava.m@email.com', '505 Walnut Ave', 'San Diego', 'CA', '92101', 'USA', 3);

-- 4. Insert data into DimProduct table
INSERT INTO DimProduct (ProductName, Category, Brand, UnitPrice)
VALUES
    ('Smartphone X12', 'Electronics', 'TechGiant', 899.99),
    ('Wireless Earbuds Pro', 'Electronics', 'SoundMaster', 149.99),
    ('Designer Jeans', 'Apparel', 'FashionStyle', 79.99),
    ('Leather Wallet', 'Accessories', 'LuxLeather', 49.99),
    ('Espresso Machine', 'Home Goods', 'BrewPerfect', 299.99),
    ('Fitness Tracker', 'Electronics', 'FitTech', 129.99),
    ('Vitamin Complex', 'Health', 'VitalLife', 24.99),
    ('Gaming Laptop', 'Electronics', 'GameEdge', 1299.99),
    ('Kitchen Knife Set', 'Home Goods', 'ChefChoice', 199.99),
    ('Yoga Mat', 'Sports', 'FlexFit', 39.99);

-- 5. Insert data into DimStore table
INSERT INTO DimStore (StoreName, StoreType, StoreOpeningDate, Address, City, State, ZipCode, Country, ManagerName)
VALUES
    ('Downtown Flagship', 'Flagship', '2015-03-15', '100 Main Plaza', 'New York', 'NY', '10001', 'USA', 'Robert Johnson'),
    ('Westfield Mall', 'Mall', '2017-07-22', '200 Shopping Center', 'Los Angeles', 'CA', '90001', 'USA', 'Sarah Williams'),
    ('Lakeside Outlet', 'Outlet', '2018-11-30', '300 Lake Drive', 'Chicago', 'IL', '60007', 'USA', 'David Brown'),
    ('Suburban Plaza', 'Strip Mall', '2019-04-18', '400 Suburb Road', 'Houston', 'TX', '77001', 'USA', 'Jennifer Miller'),
    ('City Center', 'Downtown', '2016-09-05', '500 Central Ave', 'Philadelphia', 'PA', '19019', 'USA', 'Thomas Davis');

-- 6. Insert data into FactOrders table
INSERT INTO FactOrders (DateID, CustomerID, ProductID, StoreID, QuantityOrdered, OrderAmount, DiscountAmount, ShippingCost, TotalAmount)
VALUES
    (20230101, 1, 1, 1, 1, 899.99, 0.00, 9.99, 909.98),
    (20230102, 2, 3, 2, 2, 159.98, 10.00, 5.99, 155.97),
    (20230115, 3, 5, 3, 1, 299.99, 15.00, 12.99, 297.98),
    (20230220, 4, 7, 4, 3, 74.97, 5.00, 4.99, 74.96),
    (20230315, 5, 9, 5, 1, 199.99, 0.00, 15.99, 215.98),
    (20230410, 6, 2, 1, 1, 149.99, 25.00, 0.00, 124.99),
    (20230505, 7, 4, 2, 2, 99.98, 0.00, 7.99, 107.97),
    (20230620, 8, 6, 3, 1, 129.99, 13.00, 5.99, 122.98),
    (20230704, 1, 8, 4, 1, 1299.99, 100.00, 0.00, 1199.99),
    (20230815, 2, 10, 5, 2, 79.98, 8.00, 6.99, 78.97);

-- Verify data in all tables
SELECT * FROM DimDate;
SELECT * FROM DimLoyaltyProgram;
SELECT * FROM DimCustomer;
SELECT * FROM DimProduct;
SELECT * FROM DimStore;
SELECT * FROM FactOrders;