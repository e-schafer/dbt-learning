# DBT Learning Project

Un projet d'apprentissage DBT utilisant DuckDB comme base de données et supportant les fichiers Parquet et CSV.

## 🚀 Installation

### Prérequis
- Python 3.9+
- uv (gestionnaire de paquets Python moderne)

### Installation avec uv

```bash
# Installer uv si ce n'est pas déjà fait
curl -LsSf https://astral.sh/uv/install.sh | sh

# Cloner le projet et installer les dépendances
uv sync
uv sync --extra dev  # Pour les dépendances de développement
```

## 📁 Structure du projet

```
dbt-learning/
├── dbt_project.yml          # Configuration principale DBT
├── profiles.yml              # Configuration des connexions
├── pyproject.toml           # Configuration Python et dépendances
├── data/                    # Données sources (CSV, Parquet)
│   ├── raw/
│   └── processed/
├── models/                  # Modèles DBT
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── seeds/                   # Données de référence
├── snapshots/              # Snapshots DBT
├── tests/                  # Tests Python
├── macros/                 # Macros DBT personnalisées
├── docs/                   # Documentation
└── .github/                # CI/CD GitHub Actions
```

## 🛠️ Utilisation

### Commandes principales

```bash
# Activer l'environnement virtuel
source .venv/bin/activate

# Installer les dépendances DBT
dbt deps

# Tester la connexion
dbt debug

# Exécuter les modèles
dbt run

# Exécuter les tests
dbt test

# Générer la documentation
dbt docs generate
dbt docs serve
```

### Développement

```bash
# Installer les hooks pre-commit
pre-commit install

# Formater le code
black .
isort .

# Linter le code
flake8 .

# Exécuter les tests Python
pytest
```

## 📊 Sources de données

Le projet supporte :
- **Fichiers CSV** : Placés dans `data/raw/`
- **Fichiers Parquet** : Placés dans `data/raw/`
- **Seeds DBT** : Fichiers CSV de référence dans `seeds/`

## 🧪 Tests

- **Tests DBT** : Tests de qualité des données intégrés dans les modèles
- **Tests Python** : Tests unitaires avec pytest
- **Tests d'intégration** : Validation des pipelines complets

## 🔄 CI/CD

Le projet inclut une configuration GitHub Actions pour :
- Tests automatiques sur chaque commit
- Validation des modèles DBT
- Déploiement automatique
- Génération de la documentation

## 📈 Exemples de modèles

Le projet inclut des exemples pour :
- Staging des données brutes
- Transformations intermédiaires
- Marts finalisés pour l'analyse
- Tests de qualité des données

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push sur la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request
