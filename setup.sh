#!/bin/bash

# Script de démarrage pour le projet DBT Learning
set -e

echo "🚀 Initialisation du projet DBT Learning"
echo "=========================================="

# Vérification des prérequis
echo "📋 Vérification des prérequis..."

# Vérifier que uv est installé
if ! command -v uv &> /dev/null; then
    echo "❌ uv n'est pas installé. Installation..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

echo "✅ uv trouvé: $(uv --version)"

# Installation des dépendances
echo "📦 Installation des dépendances..."
uv sync
uv sync --extra dev

echo "✅ Dépendances installées"

# Activation de l'environnement virtuel
echo "🔧 Activation de l'environnement virtuel..."
source .venv/bin/activate

# Installation des dépendances DBT
echo "📊 Installation des dépendances DBT..."
dbt deps

# Génération des données d'exemple
echo "🗃️  Génération des données d'exemple..."
python scripts/generate_sample_data.py

# Test de la configuration
echo "🔍 Test de la configuration DBT..."
dbt debug

# Installation des hooks pre-commit
echo "🔒 Installation des hooks pre-commit..."
pre-commit install

echo ""
echo "🎉 Projet initialisé avec succès!"
echo ""
echo "📖 Commandes utiles:"
echo "   dbt run              # Exécuter tous les modèles"
echo "   dbt test             # Exécuter tous les tests"
echo "   dbt docs generate    # Générer la documentation"
echo "   dbt docs serve       # Servir la documentation"
echo "   pytest               # Exécuter les tests Python"
echo ""
echo "🔗 Pour plus d'informations, consultez le README.md"
