# Guide de démarrage rapide - DBT Learning

## 🎯 Objectif

Ce projet vous permet d'apprendre DBT de A à Z avec un exemple concret utilisant DuckDB.

## 📋 Prérequis

-   Python 3.9+
-   Git
-   uv (sera installé automatiquement)

## 🚀 Installation en une commande

```bash
./setup.sh
```

Ce script va :

1. ✅ Installer uv si nécessaire
2. 📦 Installer toutes les dépendances Python et DBT
3. 🗃️ Générer des données d'exemple
4. 🔧 Configurer l'environnement
5. 🧪 Valider l'installation

## 🎮 Premiers pas

### 1. Activation de l'environnement

```bash
source .venv/bin/activate
```

### 2. Commandes essentielles DBT

```bash
# Vérifier la configuration
dbt debug

# Exécuter les modèles staging
dbt run --select staging

# Exécuter tous les modèles
dbt run

# Exécuter les tests
dbt test

# Générer et servir la documentation
dbt docs generate
dbt docs serve
```

### 3. Workflow de développement

```bash
# 1. Créer une nouvelle branche
git checkout -b feature/nouveau-modele

# 2. Développer vos modèles dans models/

# 3. Tester vos modèles
dbt run --select +nouveau_modele
dbt test --select +nouveau_modele

# 4. Valider avec les hooks pre-commit
git add .
git commit -m "Ajout du nouveau modèle"

# 5. Pousser et créer une PR
git push origin feature/nouveau-modele
```

## 📊 Structure des données

### Sources (CSV/Parquet)

-   `data/raw/customers.csv` - Données clients
-   `data/raw/orders.parquet` - Données commandes
-   `data/raw/products.csv` - Données produits

### Modèles DBT

-   **Staging** : Nettoyage et standardisation
-   **Intermediate** : Logique métier complexe
-   **Marts** : Tables finales pour l'analyse

### Bases de données DuckDB

-   `database/dbt_learning_dev.duckdb` - Développement
-   `database/dbt_learning_prod.duckdb` - Production

## 🧪 Tests

### Tests DBT intégrés

-   Tests de sources (unicité, non-nullité)
-   Tests de modèles (cohérence des données)
-   Tests personnalisés (règles métier)

### Tests Python

```bash
pytest
```

## 📈 Monitoring et qualité

### Pre-commit hooks

```bash
# Installation automatique avec setup.sh
pre-commit run --all-files
```

### CI/CD GitHub Actions

-   Tests automatiques sur chaque commit
-   Déploiement automatique en production
-   Génération de documentation

## 🔧 Commandes avancées

### Snapshots

```bash
dbt snapshot
```

### Seeds (données de référence)

```bash
dbt seed
```

### Compilation sans exécution

```bash
dbt compile
```

### Freshness des sources

```bash
dbt source freshness
```

## 🆘 Dépannage

### Problème de connexion DuckDB

```bash
dbt debug
```

### Regénérer les données d'exemple

```bash
python scripts/generate_sample_data.py
```

### Nettoyer les artefacts

```bash
dbt clean
```

### Réinstaller les dépendances

```bash
dbt deps --upgrade
```

## 📚 Ressources supplémentaires

-   [Documentation DBT](https://docs.getdbt.com/)
-   [DuckDB Documentation](https://duckdb.org/docs/)
-   [Architecture du projet](docs/architecture.md)
-   [Guide des tests](tests/README.md)

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature
3. Suivre les conventions de code (pre-commit)
4. Ajouter des tests
5. Mettre à jour la documentation
6. Créer une Pull Request

---

🎉 **Bon apprentissage avec DBT !**
