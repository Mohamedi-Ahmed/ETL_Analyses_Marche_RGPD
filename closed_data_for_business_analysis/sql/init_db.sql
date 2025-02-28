CREATE DATABASE IF NOT EXISTS ecommerce_warehouse;
USE ecommerce_warehouse;

-- 1. Modélisation du schéma en Constellation
-- Création des tables de dimensions
CREATE TABLE IF NOT EXISTS Dim_Date (
    DateKey INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE UNIQUE NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL
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

-- 2. Création de Data Marts spécifiques
-- Data Mart des Ventes
CREATE VIEW DataMart_Ventes AS
SELECT 
    f.SalesFactKey,
    d.Date,
    p.ProductName,
    p.ProductCategory,
    p.ProductSubCategory,
    c.CustomerSegment,
    f.QuantitySold,
    f.TotalAmount,
    f.DiscountAmount,
    f.NetAmount
FROM SalesFact f
JOIN Dim_Date d ON f.DateKey = d.DateKey
JOIN Dim_Produit p ON f.ProductKey = p.ProductKey
JOIN Dim_Client c ON f.CustomerKey = c.CustomerKey;

-- Data Mart de l’Inventaire
CREATE VIEW DataMart_Stock AS
SELECT 
    f.InventoryFactKey,
    d.Date,
    p.ProductName,
    p.ProductCategory,
    p.ProductSubCategory,
    s.SupplierName,
    s.SupplierLocation,
    f.StockReceived,
    f.StockSold,
    f.StockOnHand
FROM InventoryFact f
JOIN Dim_Date d ON f.DateKey = d.DateKey
JOIN Dim_Produit p ON f.ProductKey = p.ProductKey
JOIN Dim_Fournisseur s ON f.SupplierKey = s.SupplierKey;

-- 3. Sécurité et Audit des Accès
-- Création d'un utilisateur dédié avec accès restreint
CREATE USER IF NOT EXISTS 'analyste'@'%' IDENTIFIED BY 'mot_de_passe';

-- Restriction des droits : accès en lecture uniquement aux Data Marts
GRANT SELECT ON ecommerce_warehouse.DataMart_Ventes TO 'analyste'@'%';
GRANT SELECT ON ecommerce_warehouse.DataMart_Stock TO 'analyste'@'%';

--  4. Audit et Traçabilité des Accès
-- Création de la table d'audit pour enregistrer les accès
CREATE TABLE IF NOT EXISTS AuditLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    User VARCHAR(100) NOT NULL,
    Action VARCHAR(255) NOT NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Audit des Accès en Lecture (SELECT)
DELIMITER $$

CREATE PROCEDURE GetSalesFact()
BEGIN
    -- Enregistrer l'accès dans AuditLog
    INSERT INTO AuditLog (User, Action, Timestamp) 
    VALUES (CURRENT_USER(), 'Accessed SalesFact Data', NOW());

    -- Exécuter la requête SELECT sur SalesFact
    SELECT * FROM SalesFact;
END $$

DELIMITER ;

--  Audit des Modifications (UPDATE) et Suppressions (DELETE)
DELIMITER $$

-- Trigger "LogUpdateSalesFact" : UPDATE sur "SalesFact"
CREATE TRIGGER LogUpdateSalesFact 
AFTER UPDATE ON SalesFact
FOR EACH ROW 
BEGIN
    INSERT INTO AuditLog (User, Action, Timestamp)
    VALUES (CURRENT_USER(), 'Updated SalesFact Data', NOW());
END $$

-- Trigger "LogDeleteSalesFact" : DELETE sur "SalesFact"
CREATE TRIGGER LogDeleteSalesFact 
AFTER DELETE ON SalesFact
FOR EACH ROW 
BEGIN
    INSERT INTO AuditLog (User, Action, Timestamp)
    VALUES (CURRENT_USER(), 'Deleted SalesFact Data', NOW());
END $$

DELIMITER ;
