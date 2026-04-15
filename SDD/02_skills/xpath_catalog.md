# ═══════════════════════════════════════════════════════════════
#   XPATH CATALOG — Tous les XPath du projet AOS
#   Projet : Advantage Online Shopping
#   Source : https://www.advantageonlineshopping.com
# ═══════════════════════════════════════════════════════════════

## ⚠️ Règles d'utilisation

```
✅ Ces XPath ont été vérifiés directement sur l'application
✅ Les donner TELS QUELS à l'IA dans le prompt
❌ Ne JAMAIS inventer un XPath — toujours le vérifier d'abord
❌ Ne pas modifier sans re-vérification sur l'application
```

---

## 🔐 Authentification (commun à toutes les US)

```xpath
# Menu utilisateur
Icône utilisateur          : //a[@id='menuUserLink'][@aria-label='UserMenu']

# Formulaire Sign In
Champ Username             : //input[@name='username']
Champ Password             : //input[@name='password']
Bouton Sign In             : //button[@id='sign_in_btn']

# Vérification connexion
Nom utilisateur connecté   : //span[@class='hi-user ng-binding']
Bouton Sign Out            : //a[contains(@class,'logout')]

# Erreur connexion
Message erreur login       : //span[contains(@class,'login-error')]
```

---

## 📝 Inscription — US-1

```xpath
# Navigation vers inscription
Lien Register/Create Acc   : //a[@href='#/register']

# Formulaire d'inscription
Champ Username             : //input[@name='usernameRegisterPage']
Champ Email                : //input[@name='emailRegisterPage']
Champ Password             : //input[@name='passwordRegisterPage']
Champ Confirm Password     : //input[@name='confirm_passwordRegisterPage']
Champ First Name           : //input[@name='first_nameRegisterPage']
Champ Last Name            : //input[@name='last_nameRegisterPage']
Champ Phone                : //input[@name='phone']

# Sélection pays (dropdown)
Dropdown Country           : //select[@name='countryRegisterPage']
Option France              : //option[text()='France']

# Soumission
Bouton Register            : //button[@id='register_btn']

# Vérification résultat
Confirmation inscription   : //div[contains(@class,'registrationConfirmation')]
Message erreur email       : //span[contains(text(),'already')]
```

---

## 🧭 Navigation Catalogue

```xpath
# Menu principal
Menu principal             : //ul[@class='nav_menu']
Lien Laptops               : //a[contains(@href,'#/category') and contains(.,'LAPTOP')]
Lien Tablets               : //a[contains(@href,'#/category') and contains(.,'TABLET')]
Lien Mice                  : //a[contains(@href,'#/category') and contains(.,'MICE')]
Lien Headphones            : //a[contains(@href,'#/category') and contains(.,'HEADPHONES')]
Lien Speakers              : //a[contains(@href,'#/category') and contains(.,'SPEAKER')]

# Page de catégorie
Produit HP PAVILION        : //a[contains(text(),'HP PAVILION')]
Produit Sony Headphones    : //a[contains(text(),'Sony')]
Produit Samsung            : //a[contains(text(),'Samsung')]

# Tout produit (générique)
N-ième produit             : (//div[@class='product'])[1]
```

---

## 🛒 Page Produit (Ajout au panier) — US-3

```xpath
# Détail produit
Nom du produit             : //h1[@class='product-title']
Prix unitaire              : //span[@class='price ng-binding']

# Quantité
Champ quantité             : //input[@name='quantity']
Bouton + (augmenter)       : //button[contains(@class,'increase-quantity')]
Bouton - (diminuer)        : //button[contains(@class,'decrease-quantity')]

# Ajout
Bouton Add to Cart         : //button[contains(@class,'add-to-cart')]
Message confirmation ajout : //div[contains(@class,'specsAndDescription')]
```

---

## 🛍️ Panier — US-3, US-4, US-5

```xpath
# Navigation panier
Icône panier               : //a[@href='#/shoppingCart']
Compteur panier (badge)    : //span[@class='cart-item-count ng-binding']

# Contenu du panier
Liste produits panier      : //table[contains(@class,'cart-table')]
Ligne produit              : //tr[contains(@class,'cart-item')]
Nom produit dans panier    : //td[contains(@class,'product-name')]
Prix unitaire panier       : //td[contains(@class,'price')]
Quantité dans panier       : //input[contains(@class,'quantity')]
Prix total ligne           : //td[contains(@class,'total')]
Prix total panier          : //span[contains(@class,'cart-total')]

# Suppression — US-4
Bouton supprimer produit   : //a[contains(@class,'remove-from-cart')]
Confirmer suppression      : //button[contains(@class,'confirm-delete')]
Message panier vide        : //div[contains(@class,'cart-empty')]
                           : //span[contains(text(),'empty')]

# Modification quantité — US-5
Champ quantité panier      : //input[contains(@class,'quantity')]
Bouton + dans panier       : //button[contains(@class,'increase')]
Bouton - dans panier       : //button[contains(@class,'decrease')]
```

---

## ✅ Vérifications courantes

```xpath
# Page chargée correctement
Logo AOS                   : //a[@class='logo-home']
Footer présent             : //footer

# Utilisateur connecté (toutes US)
Badge nom connecté         : //span[@class='hi-user ng-binding']

# Succès générique
Toast / message succès     : //div[contains(@class,'success')]
                           : //div[contains(@class,'confirmation')]

# Erreur générique
Message erreur             : //div[contains(@class,'error')]
                           : //span[contains(@class,'error')]
```

---

## 🗂️ Référence par US

| US | XPath principaux |
|---|---|
| **US-1 Sign Up** | `usernameRegisterPage`, `register_btn`, `hi-user` |
| **US-2 Sign In** | `menuUserLink`, `username`, `password`, `sign_in_btn` |
| **US-3 Add Cart** | `add-to-cart`, `cart-item-count`, category links |
| **US-4 Delete** | `remove-from-cart`, `cart-empty`, `cart-item-count` |
| **US-5 Increase** | `quantity` input, `increase` button, `cart-total` |
