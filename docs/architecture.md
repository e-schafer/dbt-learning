# Documentation des modèles DBT

## 📊 Architecture des données

### Couches de données

1. **Sources** (`_sources.yml`)

    - Données brutes en CSV et Parquet
    - Définition des tests de qualité de base

2. **Staging** (`staging/`)

    - Nettoyage et standardisation des données
    - Renommage des colonnes
    - Types de données cohérents
    - Tests de qualité élémentaires

3. **Intermediate** (`intermediate/`)

    - Logique métier complexe
    - Agrégations et calculs
    - Jointures entre entités

4. **Marts** (`marts/`)
    - Tables finales pour l'analyse
    - Dimensions et faits
    - Optimisées pour les requêtes

### Diagramme de flux

```
Sources (CSV/Parquet)
        ↓
    Staging Views
        ↓
  Intermediate Views
        ↓
    Marts Tables
```

## 🧪 Stratégie de tests

### Tests automatiques

-   **Tests de schéma** : Colonnes requises, types de données
-   **Tests de qualité** : Unicité, non-nullité, valeurs acceptées
-   **Tests de cohérence** : Intégrité référentielle, logique métier
-   **Tests personnalisés** : Règles métier spécifiques

### Types de tests implémentés

1. Tests DBT natifs (`unique`, `not_null`, `accepted_values`)
2. Tests personnalisés dans `macros/tests.sql`
3. Tests SQL dans `tests/`
4. Tests Python avec pytest

## 📈 Métriques et KPIs

### Métriques clients

-   Nombre total de commandes
-   Montant total dépensé
-   Valeur moyenne des commandes
-   Taux de livraison réussie
-   Segmentation client
-   Statut d'activité

### Métriques produits

-   Revenus par produit
-   Quantités vendues
-   Marges par produit
-   Performance par catégorie

### Métriques temporelles

-   Revenus quotidiens
-   Croissance jour par jour
-   Tendances saisonnières
-   Métriques mobiles

## 🔄 Déploiement et CI/CD

### Environnements

-   **dev** : Développement local
-   **test** : Tests automatisés (en mémoire)
-   **prod** : Production

### Pipeline CI/CD

1. **Lint** : Vérification du code (black, isort, flake8)
2. **Parse** : Validation de la syntaxe DBT
3. **Test staging** : Tests sur les modèles de base
4. **Test complet** : Tests sur tous les modèles
5. **Déploiement** : Mise en production automatique
6. **Documentation** : Génération et publication

### Workflows GitHub Actions

-   **ci-cd.yml** : Pipeline principal
-   **scheduled-run.yml** : Exécution quotidienne

## 📚 Documentation automatique

La documentation est générée automatiquement par DBT et inclut :

-   Diagramme de lignage des données
-   Description des modèles et colonnes
-   Résultats des tests
-   Métriques de qualité

Accès : `dbt docs generate && dbt docs serve`

## 🛠️ Maintenance

### Snapshots

-   Capture de l'évolution des données clients
-   Historisation des changements

### Macros utilitaires

-   Fonctions de nettoyage
-   Calculs métier réutilisables
-   Tests personnalisés

### Monitoring

-   Tests de cohérence des données
-   Alertes sur les métriques anormales
-   Logs d'exécution
