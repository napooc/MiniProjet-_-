# ═══════════════════════════════════════════════════════════════
#   REQUIREMENTS — US-2 : Sign In
#   Projet : Advantage Online Shopping
# ═══════════════════════════════════════════════════════════════

## 📄 User Story

```
AS A registered customer,
I can sign into the application using my valid credentials
SO THAT I can navigate with my personal account through the application
```

---

## 🎯 Objectif fonctionnel

Vérifier que la connexion fonctionne correctement :
- Avec des identifiants valides → accès au compte
- Avec des identifiants invalides → accès refusé
- Après déconnexion → possibilité de se reconnecter

---

## 📋 Cas de test

### CT_US2_01 — Connexion avec identifiants valides ✅ (TEST POSITIF)

| Champ | Valeur |
|---|---|
| **ID du cas** | CT_US2_01 |
| **Titre** | Connexion réussie avec identifiants valides |
| **Type** | Test positif |
| **Priorité** | Haute |

**Préconditions :**
- L'utilisateur possède un compte valide sur l'application
- L'application est accessible sur https://www.advantageonlineshopping.com

**Étapes :**
```
1. Accéder au site Advantage Online Shopping
2. Cliquer sur l'icône utilisateur (menu)
3. Saisir le Username valide
4. Saisir le Password valide
5. Cliquer sur le bouton Sign In
6. Vérifier que l'utilisateur est connecté
```

**Résultat attendu :**
```
✅ Connexion réussie
✅ Nom de l'utilisateur affiché dans le header
✅ Accès aux fonctionnalités du compte
✅ Redirection vers la page d'accueil
```

---

### CT_US2_02 — Connexion après déconnexion ✅ (TEST POSITIF)

**Préconditions :**
- L'utilisateur est connecté
- L'utilisateur vient de se déconnecter

**Étapes :**
```
1. Se connecter avec identifiants valides
2. Cliquer sur le menu utilisateur
3. Cliquer sur Sign Out / Logout
4. Vérifier la déconnexion
5. Se reconnecter avec les mêmes identifiants
6. Vérifier la reconnexion réussie
```

**Résultat attendu :**
```
✅ Déconnexion réussie (nom utilisateur disparaît)
✅ Reconnexion réussie
✅ Nom utilisateur réaffiché après reconnexion
```

---

### CT_US2_03 — Connexion avec mot de passe incorrect ❌ (TEST NÉGATIF)

**Étapes :**
```
1. Accéder à la page de connexion
2. Saisir un username valide
3. Saisir un mot de passe incorrect
4. Cliquer sur Sign In
```

**Résultat attendu :**
```
❌ Message d'erreur : identifiants incorrects
❌ Accès refusé
❌ L'utilisateur reste sur la page de connexion
```

---

### CT_US2_04 — Connexion avec champs vides ❌ (TEST NÉGATIF)

**Étapes :**
```
1. Laisser les champs username et password vides
2. Cliquer sur Sign In
```

**Résultat attendu :**
```
❌ Validation des champs obligatoires
❌ Connexion impossible
```

---

## 🔧 XPath utilisés (US-2)

```
// Navigation vers connexion
Icône utilisateur     : //a[@id='menuUserLink'][@aria-label='UserMenu']

// Formulaire de connexion
Champ Username        : //input[@name='username']
Champ Password        : //input[@name='password']
Bouton Sign In        : //button[@id='sign_in_btn']

// Vérification résultat
Nom affiché connecté  : //span[@class='hi-user ng-binding']
Bouton Sign Out       : //a[contains(@class,'logout')]

// Message d'erreur
Erreur connexion      : //span[contains(@class,'login-error')]
```

---

## 📊 JDD référencé

Fichier : `SDD/03_jdd/jdd_us2_signin.json`

---

## 🔗 Traçabilité

```
US2_requirements.md
    → SDD/03_jdd/jdd_us2_signin.json
    → SDD/04_prompts/prompt_us2.md
    → TestSelenium/US-2 - Sign In/src/test/java/.../CT_US2_01_SigninTest.java
    → TestRobot/US-2 - Sign In/suites/CT_US2_01_signin_valid.robot
    → TestRobot/US-2 - Sign In/suites/CT_US2_02_signin_after_logout.robot
```
