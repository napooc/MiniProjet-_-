# ═══════════════════════════════════════════════════════════════
#   REQUIREMENTS — US-1 : Sign Up
#   Projet : Advantage Online Shopping
# ═══════════════════════════════════════════════════════════════

## 📄 User Story

```
AS A customer,
I can sign up to the application
SO THAT I have an account created with my personal information
         that I can use to login to the application
```

---

## 🎯 Objectif fonctionnel

Vérifier que le formulaire d'inscription fonctionne correctement :
- Avec des données valides → compte créé avec succès
- Avec des données invalides → messages d'erreur appropriés

---

## 📋 Cas de test

### CT_US1_01 — Inscription avec données valides ✅ (TEST POSITIF)

| Champ | Valeur |
|---|---|
| **ID du cas** | CT_US1_01 |
| **Titre** | Inscription réussie avec données valides |
| **Type** | Test positif |
| **Priorité** | Haute |

**Préconditions :**
- L'utilisateur n'a pas de compte existant
- L'application est accessible sur https://www.advantageonlineshopping.com

**Étapes :**
```
1. Accéder au site Advantage Online Shopping
2. Cliquer sur l'icône utilisateur (menu)
3. Cliquer sur le lien "Create new account" ou "Register"
4. Remplir le champ Username
5. Remplir le champ Email
6. Remplir le champ Password
7. Remplir le champ Confirm Password
8. Remplir les champs personnels (First Name, Last Name, Phone, Country)
9. Cliquer sur le bouton Register / Sign Up
10. Vérifier la confirmation d'inscription
```

**Résultat attendu :**
```
✅ Compte créé avec succès
✅ Redirection vers la page d'accueil ou de confirmation
✅ Nom d'utilisateur affiché dans le menu (connecté automatiquement)
✅ Message de bienvenue visible
```

---

### CT_US1_02 — Inscription avec email déjà utilisé ❌ (TEST NÉGATIF)

**Préconditions :**
- Un compte avec cet email existe déjà

**Étapes :**
```
1. Accéder au formulaire d'inscription
2. Saisir un email déjà enregistré
3. Remplir tous les autres champs valides
4. Cliquer sur Register
```

**Résultat attendu :**
```
❌ Message d'erreur : "Email already exists" ou équivalent
❌ Le compte n'est pas créé
❌ L'utilisateur reste sur la page d'inscription
```

---

### CT_US1_03 — Inscription avec champs vides ❌ (TEST NÉGATIF)

**Étapes :**
```
1. Accéder au formulaire d'inscription
2. Laisser tous les champs vides
3. Cliquer sur Register
```

**Résultat attendu :**
```
❌ Messages d'erreur de validation sur les champs obligatoires
❌ Le compte n'est pas créé
```

---

### CT_US1_04 — Mots de passe non identiques ❌ (TEST NÉGATIF)

**Étapes :**
```
1. Remplir le formulaire avec des données valides
2. Saisir Password = "Test@1234"
3. Saisir Confirm Password = "Different@999"
4. Cliquer sur Register
```

**Résultat attendu :**
```
❌ Message d'erreur : mots de passe non identiques
❌ Le compte n'est pas créé
```

---

## 🔧 XPath utilisés (US-1)

```
// Navigation vers inscription
Icône utilisateur    : //a[@id='menuUserLink'][@aria-label='UserMenu']
Lien Register        : //a[@href='#/register']

// Formulaire d'inscription
Champ Username       : //input[@name='usernameRegisterPage']
Champ Email          : //input[@name='emailRegisterPage']
Champ Password       : //input[@name='passwordRegisterPage']
Champ Confirm Pass   : //input[@name='confirm_passwordRegisterPage']
Champ First Name     : //input[@name='first_nameRegisterPage']
Champ Last Name      : //input[@name='last_nameRegisterPage']
Champ Phone          : //input[@name='phone']
Bouton Register      : //button[@id='register_btn']

// Vérification résultat
Nom affiché connecté : //span[@class='hi-user ng-binding']
Message d'erreur     : //span[@class='ng-binding ng-scope' and contains(.,'error')]
```

---

## 📊 JDD référencé

Fichier : `SDD/03_jdd/jdd_us1_signup.json`

---

## 🔗 Traçabilité

```
US1_requirements.md
    → SDD/03_jdd/jdd_us1_signup.json
    → SDD/04_prompts/prompt_us1.md
    → TestSelenium/US-1 - Sign up/src/test/java/.../CT_US1_01_SignupTest.java
    → TestRobot/US-1 - Sign up/suites/CT_US1_01_signup_valid.robot
```
