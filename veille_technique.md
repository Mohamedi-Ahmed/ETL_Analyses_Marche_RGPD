# Veille Technique et Réglementaire sur l’Open Data et la RGPD

## 1. Principes de la RGPD appliqués à l’Open Data

Le Règlement Général sur la Protection des Données (RGPD) impose des règles strictes pour la gestion des données personnelles. Lors de la diffusion en Open Data, il faut s'assurer que les informations personnelles ne permettent pas d’identifier directement ou indirectement un individu.

### Principes fondamentaux à respecter

- **Principe de minimisation des données** → Ne publier que les informations strictement nécessaires.
- **Principe de licéité, loyauté et transparence** → Informer clairement sur l’utilisation des données.
- **Principe de limitation de la conservation** → Définir une durée de vie des données en Open Data.
- **Principe d’intégrité et de confidentialité** → Sécuriser les données contre les accès non autorisés.
- **Principe des droits des individus** → Permettre l'accès, la rectification et la suppression des données si nécessaire.

## 2. Techniques de Protection des Données Personnelles

Lors de l’ouverture des données, deux stratégies majeures sont utilisées pour protéger l’identité des individus.

### Anonymisation : Rendre les données irréversibles

L’anonymisation supprime toute possibilité d’identification, ce qui exclut les données du champ d’application de la RGPD.

**Méthodes :**

- Suppression des identifiants directs (nom, adresse e-mail, numéro de téléphone).
- **Généralisation** → Regroupement des valeurs (ex : âge en tranches "20-30 ans" au lieu de "25 ans").
- **Perturbation** → Ajout d’un bruit statistique pour empêcher la réidentification.

**Exemple :**  
**Avant anonymisation** : "Client = Dupont, Achat = 120€"  
**Après anonymisation** : "Client = Anonyme, Achat = 100-150€"

### Pseudonymisation : Protéger les données avec un identifiant réversible

Contrairement à l’anonymisation, la pseudonymisation remplace les données sensibles par un code chiffré mais permet de retrouver l’information originale avec une clé.

**Méthodes :**

- **Hashing** → Transformer une donnée en code unique (ex: SHA-256).
- **Encodage** → Assigner un identifiant unique remplaçant les informations originales.

**Attention !**  
La pseudonymisation ne supprime pas totalement le risque d’identification et reste sous la RGPD.

## 3. Sécurité des Données et Prévention des Fuites

Pour éviter les fuites de données lors de la diffusion en Open Data, il est essentiel d’implémenter plusieurs niveaux de sécurité.

### Bonnes pratiques de sécurité

- **Contrôle d’accès** : Restreindre les accès aux bases sources avant la publication.
- **Chiffrement** : Appliquer un cryptage fort (AES-256) aux données sensibles en transit et en stockage.
- **Audit et journalisation** : Enregistrer toutes les requêtes d’accès et les modifications de données.
- **Tests de robustesse** : Vérifier régulièrement qu’aucune donnée personnelle ne peut être réidentifiée.

**Exemple de fuite évitée :**  
**Avant correction** : Une base de données d’Open Data contient des noms anonymisés mais des ID clients non modifiés.  
**Après correction** : Suppression des ID et application d’un hashing sur les catégories sensibles.

## 4. Secret Statistique et Protection des Données Agrégées

Les données agrégées (statistiques, indicateurs) peuvent encore permettre d’identifier indirectement des individus, surtout si elles sont très détaillées.

### Méthodes de protection du secret statistique

- **Seuil de diffusion** → Ne publier que des statistiques si elles concernent un nombre suffisant de personnes (ex : minimum 10 observations).
- **Suppression des valeurs extrêmes** → Éviter la diffusion de données qui pourraient cibler un individu unique.
- **Brouillage des données** → Modifier légèrement les chiffres pour masquer des informations trop précises.
- **Synthétisation des données** → Remplacer les données réelles par des jeux de données artificiels respectant les tendances.

**Exemple :**  
**Avant protection** : "Commune X, 1 résident avec un revenu de 500 000€/an"  
**Après protection** : "Commune X, revenus moyens : 40 000 – 50 000€/an"

## 5. Conclusion

L’ouverture des données doit se faire en conformité avec la RGPD et avec une sécurité renforcée pour éviter les réidentifications accidentelles.  
Les techniques d’anonymisation, de pseudonymisation et de secret statistique sont essentielles pour garantir un partage sécurisé des informations.

### Actions recommandées avant toute publication en Open Data

✅ Vérifier que les données ne contiennent aucun identifiant direct ou indirect.  
✅ Appliquer les meilleures pratiques de protection statistique.  
✅ Sécuriser l’accès aux bases de données avant publication.  
✅ Effectuer des tests de réidentification avant de diffuser les données publiquement.
