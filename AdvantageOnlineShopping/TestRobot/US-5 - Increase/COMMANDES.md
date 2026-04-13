# Commandes Utiles - Robot Framework

## Installation

```bash
# Installer Robot Framework
pip install robotframework

# Installer SeleniumLibrary
pip install robotframework-seleniumlibrary

# Vérifier l'installation
robot --version
```

## Exécution des Tests

### Commandes de Base

```bash
# Exécuter tous les tests d'une suite
robot --outputdir "fichiers" suites/CT_US5_01_IncreaseQuantity.robot

# Exécuter tous les tests du dossier suites
robot --outputdir "fichiers" suites/

# Exécuter avec un nom de rapport personnalisé
robot --outputdir "fichiers" --name "Tests US-5" suites/
```

### Exécution avec Tags

```bash
# Exécuter uniquement les tests avec le tag "valid"
robot --outputdir "fichiers" --include valid suites/

# Exécuter uniquement les tests avec le tag "negative-test"
robot --outputdir "fichiers" --include negative-test suites/

# Exécuter les tests avec plusieurs tags
robot --outputdir "fichiers" --include validORsmoke suites/

# Exclure certains tests
robot --outputdir "fichiers" --exclude negative-test suites/
```

### Exécution de Tests Spécifiques

```bash
# Exécuter un seul test par son nom
robot --outputdir "fichiers" --test "CT_US5_01*" suites/

# Exécuter plusieurs tests
robot --outputdir "fichiers" --test "CT_US5_01*" --test "CT_US5_02*" suites/
```

### Options de Logging

```bash
# Mode verbose (DEBUG)
robot --outputdir "fichiers" --loglevel DEBUG suites/

# Mode silencieux (WARN)
robot --outputdir "fichiers" --loglevel WARN suites/

# Afficher uniquement les échecs
robot --outputdir "fichiers" --loglevel INFO:WARN suites/
```

### Options Avancées

```bash
# Définir une variable en ligne de commande
robot --outputdir "fichiers" --variable BROWSER:Firefox suites/

# Réexécuter uniquement les tests échoués
robot --outputdir "fichiers" --rerunfailed fichiers/output.xml suites/

# Exécuter en parallèle (nécessite pabot)
pabot --processes 4 --outputdir "fichiers" suites/

# Générer un rapport avec timestamp
robot --outputdir "fichiers" --timestampoutputs suites/
```

## Analyse des Résultats

```bash
# Générer un rapport à partir d'un output.xml existant
rebot --outputdir "fichiers" fichiers/output.xml

# Fusionner plusieurs outputs
rebot --outputdir "fichiers" --name "Merged Report" fichiers/output1.xml fichiers/output2.xml

# Générer uniquement le rapport HTML
rebot --report custom_report.html fichiers/output.xml
```

## Débogage

```bash
# Arrêter l'exécution sur échec
robot --outputdir "fichiers" --exitonfailure suites/

# Mode dry-run (vérification syntaxe sans exécution)
robot --outputdir "fichiers" --dryrun suites/

# Afficher les keywords exécutés
robot --outputdir "fichiers" --loglevel TRACE suites/
```

## Exemples Pratiques pour US-5

```bash
# Smoke tests uniquement
robot --outputdir "fichiers" --include smoke --name "Smoke Tests" suites/

# Tests de régression
robot --outputdir "fichiers" --include regression --name "Regression Tests" suites/

# Tests de limites (boundary)
robot --outputdir "fichiers" --include boundary --name "Boundary Tests" suites/

# Tous les tests valides avec log détaillé
robot --outputdir "fichiers" --include valid --loglevel DEBUG --name "Valid Tests Debug" suites/

# Réexécuter les tests échoués
robot --outputdir "fichiers" --rerunfailed fichiers/output.xml --name "Rerun Failed" suites/
```

## Installation de Pabot (Exécution Parallèle)

```bash
# Installer pabot
pip install robotframework-pabot

# Exécuter en parallèle
pabot --processes 4 --outputdir "fichiers" suites/
```

## Astuces

1. **Capturer une vidéo** : Utiliser une extension comme `robotframework-pabot` avec `--listener`
2. **Nettoyer les outputs** : Supprimer le contenu du dossier `fichiers/` avant chaque run
3. **CI/CD Integration** : Utiliser `--xunit output.xml` pour intégrer avec Jenkins/GitLab CI

## Variables d'Environnement Utiles

```bash
# Windows
set BROWSER=Firefox
set URL=https://www.advantageonlineshopping.com
robot --outputdir "fichiers" suites/

# Linux/Mac
export BROWSER=Firefox
export URL=https://www.advantageonlineshopping.com
robot --outputdir "fichiers" suites/
```
