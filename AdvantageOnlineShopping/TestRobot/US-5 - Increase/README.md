# US-5 - Augmentation de Quantité dans le Panier

## 📋 Description

Cette User Story automatise le test d'augmentation de la quantité d'un produit dans le panier sur le site **Advantage Online Shopping**.

**Site testé** : https://www.advantageonlineshopping.com

## 🎯 Objectif du Test

Valider que l'utilisateur peut augmenter la quantité d'un produit dans le panier en modifiant manuellement la valeur.

## 📐 Structure du Projet

Le projet suit le pattern **Page Object Model (POM)** avec Robot Framework :

```
US-5 - Increase/
├── config/
│   ├── importResources.robot      # Import centralisé de toutes les ressources
│   └── setupTeardown.robot         # Configuration Setup/Teardown
├── ressources/
│   ├── jdd/
│   │   └── quantity_data.resource  # Jeux de données (valides/invalides)
│   ├── pages/
│   │   ├── HomePage.resource       # Page Object - Page d'accueil
│   │   └── ShoppingCartPage.resource # Page Object - Panier
│   └── utils/
│       └── browser_utils.resource  # Keywords utilitaires navigateur
├── suites/
│   └── CT_US5_01_IncreaseQuantity.robot # Suite de test principale
└── fichiers/                       # Dossier pour outputs (log, report, screenshots)
```

## 🧪 Scénario de Test

1. **Ouvrir** le site Advantage Online Shopping
2. **Ajouter** un produit au panier
3. **Aller** dans le panier
4. **Cliquer** sur EDIT
5. **Modifier** la quantité manuellement
6. **Cliquer** sur ADD TO CART
7. **Vérifier** que la quantité est mise à jour

## 📊 Cas de Test Couverts

### ✅ Tests Valides
- **CT_US5_01** : Augmenter la quantité à 2
- **CT_US5_02** : Augmenter la quantité à 5
- **CT_US5_03** : Augmenter la quantité à 10 (limite supérieure)

### ❌ Tests Invalides
- **CT_US5_04** : Quantité négative (-1)
- **CT_US5_05** : Quantité zéro (0)
- **CT_US5_06** : Quantité trop élevée (999)
- **CT_US5_07** : Caractères texte (abc)
- **CT_US5_08** : Valeur décimale (2.5)

## 🚀 Exécution des Tests

### Pré-requis

- **Python** 3.7+
- **Robot Framework** installé
- **SeleniumLibrary** installée
- **ChromeDriver** (ou autre driver selon le navigateur)

Installation des dépendances :

```bash
pip install robotframework
pip install robotframework-seleniumlibrary
```

### Commandes d'Exécution

#### Exécuter tous les tests

```bash
robot --outputdir "fichiers" suites/CT_US5_01_IncreaseQuantity.robot
```

#### Exécuter uniquement les tests valides

```bash
robot --outputdir "fichiers" --include valid suites/
```

#### Exécuter uniquement les tests invalides (negative tests)

```bash
robot --outputdir "fichiers" --include negative-test suites/
```

#### Exécuter avec log détaillé

```bash
robot --outputdir "fichiers" --loglevel DEBUG suites/
```

## 📦 Jeux de Données

Les données de test sont centralisées dans `ressources/jdd/quantity_data.resource` :

**Données Valides :**
- Quantités : 2, 5, 9, 10

**Données Invalides :**
- Négatives : -1
- Zéro : 0
- Trop élevées : 999
- Texte : abc, @#$
- Décimales : 2.5
- Vides : (empty)

## 🎨 Page Object Model (POM)

### HomePage.resource
Gère les interactions avec la page d'accueil :
- Navigation vers le panier
- Sélection de catégories
- Ajout de produits

### ShoppingCartPage.resource
Gère les interactions avec la page panier :
- Récupération de la quantité
- Édition de la quantité
- Vérification de la mise à jour

### browser_utils.resource
Keywords utilitaires réutilisables :
- Ouverture du navigateur
- Captures d'écran
- Attentes personnalisées

## 📝 Conventions de Code

- **Structure Gherkin** : Given/When/Then dans les tests
- **Nommage clair** : Keywords descriptifs et auto-documentés
- **Séparation des responsabilités** : POM strict
- **Documentation** : Chaque keyword est documenté
- **Tags** : Utilisation de tags pour filtrer les tests

## 🔍 Résultats des Tests

Après exécution, les résultats sont générés dans le dossier `fichiers/` :

- **log.html** : Logs détaillés d'exécution
- **report.html** : Rapport récapitulatif
- **output.xml** : Résultats au format XML
- **screenshots** : Captures d'écran en cas d'échec

## 🛠️ Maintenance

Pour ajouter de nouveaux tests :

1. Ajouter les données dans `jdd/quantity_data.resource`
2. Créer le test case dans la suite
3. Réutiliser les keywords existants ou en créer de nouveaux

## 👤 Auteur

QA Automation Engineer - Robot Framework & SeleniumLibrary

## 📄 Licence

Projet de test automatisé - Usage éducatif
