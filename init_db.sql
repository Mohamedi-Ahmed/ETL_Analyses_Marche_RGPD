-- Initialisation de la base de données MySQL

CREATE DATABASE IF NOT EXISTS ecommerce_warehouse;
USE ecommerce_warehouse;

-- Création des tables de dimensions
CREATE TABLE IF NOT EXISTS Dim_Date (
    DateKey INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE UNIQUE,
    Year INT,
    Month INT,
    Day INT
);

CREATE TABLE IF NOT EXISTS Dim_Produit (
    ProductKey INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255),
    ProductCategory VARCHAR(255),
    ProductSubCategory VARCHAR(255),
    UNIQUE(ProductName, ProductCategory, ProductSubCategory)
);

CREATE TABLE IF NOT EXISTS Dim_Client (
    CustomerKey INT PRIMARY KEY AUTO_INCREMENT,
    CustomerSegment VARCHAR(50) UNIQUE
);

CREATE TABLE IF NOT EXISTS Dim_Fournisseur (
    SupplierKey INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(255),
    SupplierLocation VARCHAR(255),
    SupplierContact VARCHAR(100),
    UNIQUE(SupplierName, SupplierLocation, SupplierContact)
);

CREATE TABLE IF NOT EXISTS Dim_Transporteur (
    ShipperKey INT PRIMARY KEY AUTO_INCREMENT,
    ShipperName VARCHAR(255),
    ShippingMethod VARCHAR(50),
    UNIQUE(ShipperName, ShippingMethod)
);

-- Création des tables de faits
CREATE TABLE IF NOT EXISTS SalesFact (
    SalesFactKey INT PRIMARY KEY AUTO_INCREMENT,
    DateKey INT,
    ProductKey INT,
    CustomerKey INT,
    SupplierKey INT,
    ShipperKey INT,
    QuantitySold INT,
    TotalAmount DECIMAL(10, 2),
    DiscountAmount DECIMAL(10, 2),
    NetAmount DECIMAL(10, 2),
    FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
    FOREIGN KEY (ProductKey) REFERENCES Dim_Produit(ProductKey),
    FOREIGN KEY (CustomerKey) REFERENCES Dim_Client(CustomerKey),
    FOREIGN KEY (SupplierKey) REFERENCES Dim_Fournisseur(SupplierKey),
    FOREIGN KEY (ShipperKey) REFERENCES Dim_Transporteur(ShipperKey)
);

CREATE TABLE IF NOT EXISTS InventoryFact (
    InventoryFactKey INT PRIMARY KEY AUTO_INCREMENT,
    DateKey INT,
    ProductKey INT,
    SupplierKey INT,
    StockReceived INT,
    StockSold INT,
    StockOnHand INT,
    FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
    FOREIGN KEY (ProductKey) REFERENCES Dim_Produit(ProductKey),
    FOREIGN KEY (SupplierKey) REFERENCES Dim_Fournisseur(SupplierKey)
);

-- Création d'un utilisateur dédié avec accès en lecture pour la partie securite
CREATE USER IF NOT EXISTS 'analyste'@'%' IDENTIFIED BY 'mot_de_passe';
GRANT SELECT ON ecommerce_warehouse.* TO 'analyste'@'%';