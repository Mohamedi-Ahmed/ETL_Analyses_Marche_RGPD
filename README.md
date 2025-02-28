# Projet Open Data - ETL, Sécurisation et Conformité RGPD

## 1. Contexte du Projet
Ce projet vise à structurer et sécuriser les données d’un grand groupe national afin d’améliorer leur accessibilité et leur analyse tout en respectant les exigences du RGPD.

L’entreprise a fixé deux objectifs clés :

1. **Optimisation des données internes** pour permettre aux équipes métiers d’avoir des analyses précises et rapides.
2. **Mise en place d’une base Open Data** conforme aux réglementations en vigueur, tout en protégeant les données sensibles.

Pour cela, une **architecture robuste** a été mise en place avec un **entrepôt de données** et une **base Open Data**, le tout sécurisé avec un **système d’audit des accès**.

---

## 2. Architecture du Projet
### I. Entrepôt de Données optimisé pour l’analyse métier
1. **Processus ETL**
   - Extraction des données et gestion des valeurs manquantes.
   - Transformation des données avec **un pipeline optimisé**.
   - Chargement des données dans un **entrepôt SQL performant**.

2. **Modélisation en schéma Constellation**
   - **Tables de dimensions** : `Dim_Date`, `Dim_Produit`, `Dim_Client`, `Dim_Fournisseur`, `Dim_Transporteur`.
   - **Tables de faits** : `SalesFact` (ventes) et `InventoryFact` (stocks).

3. **Création de Data Marts spécifiques**
   - **Data Mart des Ventes** : transactions, produits, clients.
   - **Data Mart de l’Inventaire** : produits, fournisseurs, niveaux de stock.

### II. Mise en place d’une base Open Data
1. **Modélisation de la base Open Data**
   - Création d’un **schéma anonymisé** des données.
   - **Exclusion des informations sensibles** tout en gardant une utilité analytique.

2. **Extraction et transformation des données**
   - Implémentation des requêtes SQL pour anonymiser et agréger les données.
   - Export des données en **formats CSV et JSON**.

---

## 3. Sécurisation et Conformité RGPD
### 3.1 Anonymisation et Protection des Données
- Suppression des **informations personnelles** (nom, téléphone, email).
- Agrégation des ventes et des stocks **par catégorie de produit**.
- Ajout d’un **seuil minimal de diffusion** pour éviter la réidentification.

### 3.2 Sécurisation des Accès et Journalisation
Un **système d’audit** a été mis en place pour tracer les accès et les modifications effectuées sur la base.

#### 1. Création de la table d’audit
```sql
CREATE TABLE IF NOT EXISTS AuditLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    User VARCHAR(100),
    Action VARCHAR(255),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 2. Audit des accès aux données sensibles (SELECT)
```sql
DELIMITER $$

CREATE PROCEDURE GetSalesFact()
BEGIN
    INSERT INTO AuditLog (User, Action, Timestamp) 
    VALUES (CURRENT_USER(), 'Accessed SalesFact Data', NOW());
    
    SELECT * FROM SalesFact;
END $$

DELIMITER ;
```
**Utilisation** :  
```sql
CALL GetSalesFact();
```

#### 3. Audit des mises à jour (UPDATE) et suppressions (DELETE)
```sql
DELIMITER $$

CREATE TRIGGER LogUpdateSalesFact 
AFTER UPDATE ON SalesFact
FOR EACH ROW 
BEGIN
    INSERT INTO AuditLog (User, Action, Timestamp)
    VALUES (CURRENT_USER(), 'Updated SalesFact Data', NOW());
END $$

CREATE TRIGGER LogDeleteSalesFact 
AFTER DELETE ON SalesFact
FOR EACH ROW 
BEGIN
    INSERT INTO AuditLog (User, Action, Timestamp)
    VALUES (CURRENT_USER(), 'Deleted SalesFact Data', NOW());
END $$

DELIMITER ;
```

**Vérifier les logs :**  
```sql
SELECT * FROM AuditLog ORDER BY Timestamp DESC;
```

---

## 4. Tests et Vérification
### Tester l’Audit des accès (SELECT)
```sql
CALL GetSalesFact();
SELECT * FROM AuditLog ORDER BY Timestamp DESC;
```

### Tester l’Audit des mises à jour (UPDATE)
```sql
UPDATE SalesFact SET QuantitySold = 30 WHERE SalesFactKey = 2;
SELECT * FROM AuditLog ORDER BY Timestamp DESC;
```

### Tester l’Audit des suppressions (DELETE)
```sql
DELETE FROM SalesFact WHERE SalesFactKey = 3;
SELECT * FROM AuditLog ORDER BY Timestamp DESC;
```

---

## 5. Résumé des Mesures de Sécurité
| Sécurité Implémentée | Description |
|----------------------|-------------|
| Audit des accès (SELECT) | Via la procédure `GetSalesFact()`, chaque consultation est enregistrée. |
| Audit des mises à jour (UPDATE) | Un trigger `LogUpdateSalesFact` enregistre chaque modification. |
| Audit des suppressions (DELETE) | Un trigger `LogDeleteSalesFact` enregistre chaque suppression. |
| Restrictions d’accès | L’utilisateur `analyste` ne peut voir que les **Data Marts** et non les tables brutes. |
| Journalisation des actions | Tous les accès et modifications sont enregistrés dans `AuditLog`. |

---

## Conclusion
Ce projet assure une **transformation des données conforme aux standards de sécurité et du RGPD** tout en garantissant une **traçabilité des accès**.