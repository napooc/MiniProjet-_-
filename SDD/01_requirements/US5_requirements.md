# ═══════════════════════════════════════════════════════════════
#   REQUIREMENTS — US-5 : Increase Items in Cart
#   Projet : Advantage Online Shopping
# ═══════════════════════════════════════════════════════════════

## 📄 User Story

```
AS A customer,
I want to increase the number of items of a specific product in my cart
SO THAT I can buy multiple items of the same product
```

---

## 🎯 Objectif fonctionnel

Vérifier qu'un utilisateur connecté peut modifier la quantité d'un produit dans son panier :
- La quantité doit être mise à jour correctement
- Le prix total doit être recalculé
- Les valeurs invalides doivent être rejetées

---

## 📋 Cas de test

### CT_US5_01 — Augmentation de la quantité ✅ (TEST POSITIF)

| Champ | Valeur |
|---|---|
| **ID du cas** | CT_US5_01 |
| **Titre** | Augmentation réussie de la quantité d'un produit |
| **Type** | Test positif |
| **Priorité** | Haute |

**Préconditions :**
- L'utilisateur est connecté
- Le panier contient HP PAVILION avec quantité = 1

**Étapes :**
```
1. Accéder au site et se connecter
2. Ajouter HP PAVILION au panier (quantité 1)
3. Accéder au panier
4. Modifier la quantité de 1 à 3
5. Confirmer la mise à jour (clic ou touche Entrée)
6. Vérifier que la quantité affichée = 3
7. Vérifier que le prix total est recalculé
```

**Résultat attendu :**
```
✅ Quantité mise à jour à 3
✅ Prix total = prix unitaire × 3
✅ Compteur panier mis à jour
```

---

### CT_US5_02 — Quantité négative ❌ (TEST NÉGATIF)

**Étapes :**
```
1. Se connecter et ajouter un produit au panier
2. Tenter de modifier la quantité à -1
3. Confirmer
```

**Résultat attendu :**
```
❌ Erreur : quantité invalide
❌ Quantité non modifiée
```

---

### CT_US5_03 — Quantité supérieure au stock ❌ (TEST NÉGATIF)

**Étapes :**
```
1. Tenter de modifier la quantité à 9999
```

**Résultat attendu :**
```
❌ Erreur : stock insuffisant ou quantité limitée
❌ Quantité non modifiée
```

---

### CT_US5_04 — Valeur non numérique ❌ (TEST NÉGATIF)

**Étapes :**
```
1. Saisir "abc" dans le champ quantité
```

**Résultat attendu :**
```
❌ Champ rejette la valeur non numérique
❌ Quantité non modifiée
```

---

## 🔧 XPath utilisés (US-5)

```
// Connexion
Icône utilisateur     : //a[@id='menuUserLink'][@aria-label='UserMenu']
Champ Username        : //input[@name='username']
Champ Password        : //input[@name='password']
Bouton Sign In        : //button[@id='sign_in_btn']

// Navigation produit
Menu Laptops          : //a[contains(@href,'#/category')]
Produit HP PAVILION   : //a[contains(text(),'HP PAVILION')]

// Panier - modification quantité
Icône panier          : //a[@href='#/shoppingCart']
Champ quantité cart   : //input[contains(@class,'quantity')]
Bouton augmenter (+)  : //button[contains(@class,'increase')]
Prix total            : //span[contains(@class,'total-price')]
Compteur panier       : //span[@class='cart-item-count ng-binding']
```

---

## 📊 JDD référencé

Fichier : `SDD/03_jdd/jdd_us5_increase.json`

---

## 🔗 Traçabilité

```
US5_requirements.md
    → SDD/03_jdd/jdd_us5_increase.json
    → SDD/04_prompts/prompt_us5.md
    → TestSelenium/US-5 - Delete/src/test/java/.../CT_US5_01_IncreaseItemsTest.java
```
