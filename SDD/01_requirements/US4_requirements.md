# ═══════════════════════════════════════════════════════════════
#   REQUIREMENTS — US-4 : Delete from Cart
#   Projet : Advantage Online Shopping
# ═══════════════════════════════════════════════════════════════

## 📄 User Story

```
AS A customer,
I want to delete a product from my cart
SO THAT I cancel buying this product
```

---

## 🎯 Objectif fonctionnel

Vérifier qu'un utilisateur connecté peut supprimer un produit de son panier :
- Le produit doit disparaître du panier
- Le compteur du panier doit être mis à jour
- Si dernier produit → panier vide affiché

---

## 📋 Cas de test

### CT_US4_01 — Suppression d'un produit du panier ✅ (TEST POSITIF)

| Champ | Valeur |
|---|---|
| **ID du cas** | CT_US4_01 |
| **Titre** | Suppression réussie d'un produit du panier |
| **Type** | Test positif |
| **Priorité** | Haute |

**Préconditions :**
- L'utilisateur est connecté avec un compte valide
- Le panier contient au moins 1 produit (HP PAVILION 15-P078NR)

**Étapes :**
```
1. Accéder au site Advantage Online Shopping
2. Se connecter avec identifiants valides
3. Naviguer vers la catégorie Laptops
4. Ajouter HP PAVILION 15-P078NR au panier
5. Accéder au panier via l'icône panier
6. Cliquer sur le bouton de suppression du produit
7. Confirmer la suppression si nécessaire
8. Vérifier que le panier est vide
9. Vérifier que le compteur est à 0
```

**Résultat attendu :**
```
✅ Produit supprimé du panier
✅ Panier vide affiché (message ou icône panier vide)
✅ Compteur du panier = 0
✅ Le produit n'apparaît plus dans la liste du panier
```

---

### CT_US4_02 — Suppression d'un produit parmi plusieurs ✅ (TEST POSITIF)

**Préconditions :**
- L'utilisateur est connecté
- Le panier contient 2+ produits

**Étapes :**
```
1. Se connecter et ajouter plusieurs produits
2. Accéder au panier
3. Supprimer uniquement un produit
4. Vérifier que les autres produits restent
```

**Résultat attendu :**
```
✅ Seulement le produit ciblé est supprimé
✅ Les autres produits restent dans le panier
✅ Compteur mis à jour correctement
```

---

### CT_US4_03 — Suppression sans être connecté ❌ (TEST NÉGATIF)

**Préconditions :**
- L'utilisateur n'est PAS connecté

**Résultat attendu :**
```
❌ Redirection vers la page de connexion
❌ Aucune suppression possible
```

---

## 🔧 XPath utilisés (US-4)

```
// Connexion
Icône utilisateur     : //a[@id='menuUserLink'][@aria-label='UserMenu']
Champ Username        : //input[@name='username']
Champ Password        : //input[@name='password']
Bouton Sign In        : //button[@id='sign_in_btn']
Nom affiché connecté  : //span[@class='hi-user ng-binding']

// Navigation produit
Menu Laptops          : //a[contains(@href,'#/category')]
Produit HP PAVILION   : //a[contains(text(),'HP PAVILION')]

// Panier
Icône panier          : //a[@href='#/shoppingCart']
Bouton supprimer      : //a[contains(@class,'remove-from-cart')]
Panier vide message   : //div[contains(@class,'cart-empty')]
Compteur panier       : //span[@class='cart-item-count ng-binding']
```

---

## 📊 JDD référencé

Fichier : `SDD/03_jdd/jdd_us4_delete.json`

---

## 🔗 Traçabilité

```
US4_requirements.md
    → SDD/03_jdd/jdd_us4_delete.json
    → SDD/02_skills/xpath_catalog.md (section US4)
    → SDD/04_prompts/prompt_us4.md
    → TestSelenium/US-4 - Delete/src/test/java/com/aos/us4/tests/CT_US4_01_DeleteProductTest.java
    → TestSelenium/US-4 - Delete/target/reports/TestReport.html
```
