CREATE TABLE Customers (
  Customer_Id NUMBER PRIMARY KEY,
  First_Name VARCHAR2(50) NOT NULL,
  Last_Name VARCHAR2(50) NOT NULL,
  Address VARCHAR2(100) NOT NULL,
  Email VARCHAR2(50) NOT NULL UNIQUE,
  Phone VARCHAR2(15)
);


CREATE TABLE Products (
  Product_Id NUMBER PRIMARY KEY,
  Product_Name VARCHAR2(50) NOT NULL,
  Category VARCHAR2(50) NOT NULL,
  Product_Description VARCHAR2(100),
  Quantity NUMBER DEFAULT 0 CHECK (Quantity >= 0),
  Price NUMBER NOT NULL CHECK (Price > 0)
);

CREATE TABLE Orders (
  Order_Id NUMBER PRIMARY KEY,
  Order_Date DATE DEFAULT SYSDATE,
  Order_Amount NUMBER NOT NULL CHECK (Order_Amount > 0),
  Customer_Id NUMBER NOT NULL,
  CONSTRAINT fk_customer FOREIGN KEY (Customer_Id) REFERENCES Customers (Customer_Id)
);


CREATE TABLE Order_Details (
  Order_Details_Id NUMBER NOT NULL PRIMARY KEY,
  Product_Id NUMBER NOT NULL,
  Order_Id NUMBER NOT NULL,
  Quantity NUMBER NOT NULL,
  CONSTRAINT fk_product FOREIGN KEY (Product_Id) REFERENCES Products (Product_Id),
  CONSTRAINT fk_order FOREIGN KEY (Order_Id) REFERENCES Orders (Order_Id)
);

INSERT INTO Customers VALUES (1,'Ashwani', 'Ranjan', 'Near Myntra office','ashwani@gmail.com','123456789');
INSERT INTO Customers VALUES (2,'Ranjan','singh', 'Opposite Myntra office','ranjan@gmail.com','897456789');

INSERT INTO Products VALUES (101, 'headphone','Electronics','This is the onEar headset',10,10000);
INSERT INTO Products VALUES (102, 'Laptop','Electronics','This is the best model',5,90000);

INSERT INTO Orders VALUES (10, TO_DATE('2025-10-11', 'YYYY-MM-DD'), 50000, 1);
INSERT INTO Orders VALUES (11, TO_DATE('2025-10-12', 'YYYY-MM-DD'), 70000, 2);

INSERT INTO Order_Details VALUES (01,101,10,2);
INSERT INTO Order_Details VALUES (02,102,11,10);



--Other Required Queries
--1. Retrieve Product with low stock quantity
SELECT * FROM Products WHERE Stock_Quantity < 20;

--2. To get amount spent by each customer
SELECT First_Name, SUM(O.Order_Total) as Total_Amount_Spent 
FROM Customers C INNER JOIN Orders O on C.Customer_Id = O.Customer_Id 
GROUP BY C.First_Name; 

--3. To update the product quantity
UPDATE Products P
SET P.Stock_Quantity = P.Stock_Quantity - (
  SELECT SUM(OD.Quantity)
  FROM OrderDetails OD
  WHERE OD.Product_Id = P.Product_Id
)
WHERE P.Product_Id IN (SELECT DISTINCT Product_Id FROM OrderDetails);
