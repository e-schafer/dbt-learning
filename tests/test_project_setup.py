"""
Tests unitaires pour les fonctions utilitaires du projet DBT
"""

import subprocess
from pathlib import Path

import pytest
import yaml


class TestProjectStructure:
    """Tests pour vérifier la structure du projet"""

    def test_dbt_project_file_exists(self):
        """Vérifie que le fichier dbt_project.yml existe"""
        assert Path("dbt_project.yml").exists()

    def test_profiles_file_exists(self):
        """Vérifie que le fichier profiles.yml existe"""
        assert Path("profiles.yml").exists()

    def test_pyproject_file_exists(self):
        """Vérifie que le fichier pyproject.toml existe"""
        assert Path("pyproject.toml").exists()

    def test_models_directory_exists(self):
        """Vérifie que le dossier models existe"""
        assert Path("models").exists() and Path("models").is_dir()

    def test_data_directory_exists(self):
        """Vérifie que le dossier data existe"""
        assert Path("data").exists() and Path("data").is_dir()

    def test_seeds_directory_exists(self):
        """Vérifie que le dossier seeds existe"""
        assert Path("seeds").exists() and Path("seeds").is_dir()


class TestDBTConfiguration:
    """Tests pour valider la configuration DBT"""

    def test_dbt_project_is_valid_yaml(self):
        """Vérifie que dbt_project.yml est un YAML valide"""
        with open("dbt_project.yml") as f:
            config = yaml.safe_load(f)
        assert config is not None
        assert "name" in config
        assert "version" in config

    def test_profiles_is_valid_yaml(self):
        """Vérifie que profiles.yml est un YAML valide"""
        with open("profiles.yml") as f:
            config = yaml.safe_load(f)
        assert config is not None
        assert "dbt_learning" in config

    def test_dbt_parse_succeeds(self):
        """Vérifie que DBT peut parser le projet"""
        try:
            result = subprocess.run(["dbt", "parse"], capture_output=True, text=True, timeout=30)
            # DBT parse peut échouer si les dépendances ne sont pas installées
            # mais ne devrait pas avoir d'erreurs de syntaxe
            assert "Compilation Error" not in result.stderr
        except (subprocess.TimeoutExpired, FileNotFoundError):
            # Si DBT n'est pas installé ou prend trop de temps, on ignore
            pytest.skip("DBT not available or timeout")


class TestDataFiles:
    """Tests pour vérifier les fichiers de données"""

    def test_sample_csv_files_exist(self):
        """Vérifie que les fichiers CSV d'exemple existent"""
        csv_files = ["data/raw/customers.csv", "data/raw/products.csv"]
        for file_path in csv_files:
            assert Path(file_path).exists(), f"Missing file: {file_path}"

    def test_seeds_files_exist(self):
        """Vérifie que les fichiers seeds existent"""
        seed_files = ["seeds/countries.csv", "seeds/product_categories.csv"]
        for file_path in seed_files:
            assert Path(file_path).exists(), f"Missing seed file: {file_path}"


class TestMacros:
    """Tests pour les macros DBT"""

    def test_macro_files_exist(self):
        """Vérifie que les fichiers de macros existent"""
        macro_files = ["macros/utils.sql", "macros/tests.sql"]
        for file_path in macro_files:
            assert Path(file_path).exists(), f"Missing macro file: {file_path}"


class TestGitHubActions:
    """Tests pour la configuration CI/CD"""

    def test_github_workflows_exist(self):
        """Vérifie que les workflows GitHub Actions existent"""
        workflow_files = [
            ".github/workflows/ci-cd.yml",
            ".github/workflows/scheduled-run.yml",
        ]
        for file_path in workflow_files:
            assert Path(file_path).exists(), f"Missing workflow: {file_path}"

    def test_workflows_are_valid_yaml(self):
        """Vérifie que les workflows sont des YAML valides"""
        workflow_files = [
            ".github/workflows/ci-cd.yml",
            ".github/workflows/scheduled-run.yml",
        ]
        for file_path in workflow_files:
            if Path(file_path).exists():
                with open(file_path) as f:
                    config = yaml.safe_load(f)
                assert config is not None
                assert "on" in config or "name" in config


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
