# ═══════════════════════════════════════════════════════════════
#   REQUIREMENTS — US-3 : Add to Cart
#   Projet : Advantage Online Shopping
# ═══════════════════════════════════════════════════════════════

## 📄 User Story

```
AS A customer,
I want to add a product in my cart
SO THAT I buy this product
```

---

## 🎯 Objectif fonctionnel

Vérifier qu'un utilisateur connecté peut ajouter un produit à son panier :
- Depuis la page de catégorie
- Avec une quantité valide
- Le compteur du panier doit être mis à jour

---

## 📋 Cas de test

### CT_US3_01 — Ajout d'un produit au panier ✅ (TEST POSITIF)

| Champ | Valeur |
|---|---|
| **ID du cas** | CT_US3_01 |
| **Titre** | Ajout réussi d'un produit au panier |
| **Type** | Test positif |
| **Priorité** | Haute |

**Préconditions :**
- L'utilisateur est connecté avec un compte valide
- Le produit est disponible en stock

**Étapes :**
```
1. Accéder au site Advantage Online Shopping
2. Se connecter avec identifiants valides
3. Naviguer vers la catégorie "Laptops"
4. Sélectionner le produit HP PAVILION 15-P078NR
5. Sélectionner la quantité souhaitée
6. Cliquer sur "Add to Cart"
7. Vérifier que le produit est dans le panier
8. Vérifier que le compteur du panier est mis à jour
```

**Résultat attendu :**
```
✅ Produit ajouté au panier avec succès
✅ Compteur du panier incrémenté
✅ Message de confirmation affiché
✅ Produit visible dans le panier
```

---

### CT_US3_02 — Ajout sans être connecté ❌ (TEST NÉGATIF)

**Préconditions :**
- L'utilisateur n'est PAS connecté

**Étapes :**
```
1. Accéder au site sans se connecter
2. Naviguer vers un produit
3. Cliquer sur "Add to Cart"
```

**Résultat attendu :**
```
❌ Redirection vers la page de connexion
❌ Produit non ajouté
```

---

## 🔧 XPath utilisés (US-3)

```
// Navigation
Icône utilisateur     : //a[@id='menuUserLink'][@aria-label='UserMenu']
Champ Username        : //input[@name='username']
Champ Password        : //input[@name='password']
Bouton Sign In        : //button[@id='sign_in_btn']
Menu Laptops          : //a[contains(@href,'#/category')]
Produit HP PAVILION   : //a[contains(text(),'HP PAVILION')]

// Page produit
Champ quantité        : //input[@name='quantity']
Bouton Add to Cart    : //button[contains(@class,'add-to-cart')]

// Vérification
Compteur panier       : //span[@class='cart-item-count ng-binding']
Message confirmation  : //div[contains(@class,'cart-confirmation')]
```

---

## 📊 JDD référencé

Fichier : `SDD/03_jdd/jdd_us3_addtocart.json`

---

## 🔗 Traçabilité

```
US3_requirements.md
    → SDD/03_jdd/jdd_us3_addtocart.json
    → SDD/04_prompts/prompt_us3.md
    → TestSelenium/US-3 - ADD/src/test/java/.../CT_US3_01_AddToCartTest.java
```
