-- Création de la base Open Data
CREATE DATABASE IF NOT EXISTS open_data;
USE open_data;

-- Table Open Data des Ventes (Données anonymisées et agrégées)
CREATE TABLE IF NOT EXISTS open_data_ventes (
    Date VARCHAR(7) NOT NULL,
    ProductCategory VARCHAR(255) NOT NULL,
    TotalVentes INT NOT NULL,
    TotalRevenue DECIMAL(10,2) NOT NULL,
    EncryptedRevenue VARBINARY(255),  -- Chiffrement des revenus
    PRIMARY KEY (Date, ProductCategory)
);

-- Table Open Data de l'Inventaire (Données agrégées sans informations fournisseurs)
CREATE TABLE IF NOT EXISTS open_data_stock (
    Date VARCHAR(7) NOT NULL,
    ProductCategory VARCHAR(255) NOT NULL,
    StockDisponible INT NOT NULL,
    PRIMARY KEY (Date, ProductCategory)
);

-- Ajout d'index pour améliorer les performances des requêtes
CREATE INDEX idx_ventes_date ON open_data_ventes (Date);
CREATE INDEX idx_ventes_category ON open_data_ventes (ProductCategory);
CREATE INDEX idx_stock_date ON open_data_stock (Date);
CREATE INDEX idx_stock_category ON open_data_stock (ProductCategory);