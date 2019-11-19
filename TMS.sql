DROP DATABASE IF EXISTS TMS;

CREATE DATABASE TMS;

USE TMS;

CREATE TABLE Department(
	Department_Id INT AUTO_INCREMENT,
    Department_Name VARCHAR(64),
    PRIMARY KEY (Department_Id)
    );
    
CREATE TABLE City(
	City_Id INT AUTO_INCREMENT,
    City VARCHAR(255),
    PRIMARY KEY (City_Id)
    );

CREATE TABLE Province(
	Province_Id INT AUTO_INCREMENT,
    Province VARCHAR(255),
    PRIMARY KEY(Province_Id)
    );

CREATE TABLE Address(
	Address_Id INT AUTO_INCREMENT,
    Street_Address VARCHAR(255),
    City_Id INT,
    Province_Id INT,
    Postal_Code VARCHAR(8),
    PRIMARY KEY (Address_Id),
    FOREIGN KEY(City_Id) REFERENCES City(City_Id),
    FOREIGN KEY(Province_Id) REFERENCES Province(Province_Id)
    );
    
CREATE TABLE Person(
	Person_Id INT AUTO_INCREMENT,
    First_Name VARCHAR(255),
    Last_Name VARCHAR(255),
    Phone VARCHAR(32),
    Email VARCHAR(255),
    Address_Id INT,
    PRIMARY KEY(Person_Id),
    FOREIGN KEY(Address_Id) REFERENCES Address(Address_Id)
    );
    
CREATE TABLE Customer(
	Customer_Id INT,
    Address_Id INT, 
    PRIMARY KEY (Customer_Id),
    FOREIGN KEY (Customer_Id) REFERENCES Person(Person_Id),
    FOREIGN KEY (Address_Id) REFERENCES Address(Address_Id)
    );
    
CREATE TABLE Employee(
	Employee_Id INT,
	Address_Id INT,
    Department_Id INT,
    PRIMARY KEY (Employee_Id),
    FOREIGN KEY (Address_Id) REFERENCES Address(Address_Id),
    FOREIGN KEY (Department_Id) REFERENCES Department(Department_Id)
    );
CREATE TABLE _Order(
	Order_Id INT AUTO_INCREMENT,
	Start_Date DATE NOT NULL,
	End_Date DATE,
	Origin VARCHAR(32),
    Destination VARCHAR(32),
    Job_Type BOOL,
    Van_Type BOOL,
    Order_Status INT,
    Customer_Id INT,
	PRIMARY KEY (Order_Id),
    FOREIGN KEY (Customer_Id) REFERENCES Customer(Customer_Id)
	);
CREATE TABLE Invoice(
	Invoice_Id INT AUTO_INCREMENT,
    Order_Id INT NOT NULL,
	Date_Issued DATE NOT NULL,
	Amount_Due Decimal(10,2),
	Invoice_Status INT NOT NULL,
	PRIMARY KEY(Invoice_Id),
    FOREIGN KEY(Order_Id) REFERENCES _Order(Order_Id)
	);

CREATE TABLE Carrier(
	Carrier_Id INT AUTO_INCREMENT,
    Carrier_Name VARCHAR(255) NOT NULL,
    Phone VARCHAR(32),
    Email VARCHAR(255),
    Address_Id INT,
    LTL_Rate DECIMAL(10,2),
    FTL_Rate DECIMAL(10,2),
    PRIMARY KEY(Carrier_ID),
    FOREIGN KEY(Address_Id) REFERENCES Address(Address_Id)
    );
    
CREATE TABLE Order_Carrier(
	Order_Id INT,
    Carrier_Id INT,
    FOREIGN KEY(Order_Id) REFERENCES _Order(Order_Id),
    FOREIGN KEY(Carrier_Id) REFERENCES Carrier(Carrier_Id)
    );
 
CREATE TABLE Order_Employee(
	Order_Id INT,
    Employee_Id INT,
    PRIMARY KEY(Order_Id, Employee_Id),
    FOREIGN KEY(Order_Id) REFERENCES _Order(Order_Id),
    FOREIGN KEY(Employee_Id) REFERENCES Employee(Employee_Id)
    );

CREATE TABLE Depot(
	Depot_Id INT AUTO_INCREMENT,
	Carrier_Id INT,
    Delivery_City_Id INT,
    PRIMARY KEY (Depot_Id),
	FOREIGN KEY(Carrier_Id) REFERENCES Carrier(Carrier_Id),
    FOREIGN KEY(Delivery_City_Id) REFERENCES City(City_Id)
    );
    
CREATE TABLE Waiting_Truck(
	Truck_Id INT AUTO_INCREMENT,
    Time_to_Leave DATE,
    Depot_Id INT, 
    Quantity INT,
    PRIMARY KEY (Truck_Id),
    FOREIGN KEY(Depot_Id) REFERENCES Depot(Depot_Id)
    );

CREATE TABLE Waiting_Truck_Order (    
	Truck_Id INT,
    Order_Id INT,
    PRIMARY KEY (Truck_Id, Order_Id),
    FOREIGN KEY(Truck_Id) REFERENCES Waiting_Truck(Truck_Id),
	FOREIGN KEY(Order_Id) REFERENCES _Order(Order_Id)
    );

CREATE TABLE Connected_City(
	City_Id INT,
    Connected_City_Id INT,
    KM INT,
    Travel_Time INT,
    Direction INT,
    PRIMARY KEY (City_Id, Connected_City_Id),
    FOREIGN KEY(City_Id) REFERENCES City(City_Id),
    FOREIGN KEY(Connected_City_Id) REFERENCES City(City_Id)
    );

CREATE TABLE Trips(
	Trip_Id INT AUTO_INCREMENT,
    Carrier_Id INT,
    KM INT,
    Travel_Time INT,
    PRIMARY KEY (Trip_Id),
    FOREIGN KEY (Carrier_Id) REFERENCES Carrier(Carrier_Id)
    );
    
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Conestoga'; 
GRANT ALL PRIVILEGES ON tms TO 'admin'@'localhost';

CREATE USER 'buyer'@'localhost' IDENTIFIED BY 'Conestoga'; 
GRANT SELECT, INSERT, DELETE, UPDATE ON tms.* TO 'buyer'@'localhost';

CREATE USER 'planner'@'localhost' IDENTIFIED BY 'Conestoga'; 
GRANT SELECT, INSERT, DELETE, UPDATE ON tms.* TO 'planner'@'localhost';
