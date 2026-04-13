# Dossier Fichiers (Outputs)

Ce dossier est destiné à recevoir les fichiers générés lors de l'exécution des tests :

- **output.xml** : Résultats détaillés au format XML
- **log.html** : Logs d'exécution au format HTML
- **report.html** : Rapport de test au format HTML
- **screenshots** : Captures d'écran en cas d'échec de test

## Commande d'exécution

Pour exécuter les tests et générer les rapports dans ce dossier :

```bash
robot --outputdir "fichiers" suites/CT_US5_01_IncreaseQuantity.robot
```

Ou pour exécuter tous les tests du dossier suites :

```bash
robot --outputdir "fichiers" suites/
```

## Options utiles

```bash
# Exécuter uniquement les tests avec un tag spécifique
robot --outputdir "fichiers" --include valid suites/

# Exécuter en mode verbeux
robot --outputdir "fichiers" --loglevel DEBUG suites/

# Exécuter avec un nom personnalisé pour le rapport
robot --outputdir "fichiers" --name "Tests US-5 Increase Quantity" suites/
```
