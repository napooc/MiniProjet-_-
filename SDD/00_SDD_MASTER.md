# ═══════════════════════════════════════════════════════════════
#        SPEC DRIVEN DEVELOPMENT — MASTER DOCUMENT
#        Projet : Advantage Online Shopping
#        Équipe : QA Interns — Capgemini
#        Date   : Avril 2026
# ═══════════════════════════════════════════════════════════════

## 🎯 Principe SDD dans ce projet

> Le Spec Driven Development signifie que **TOUT** est défini avant qu'une seule ligne de code soit écrite ou générée par l'IA.
> L'IA ne devine rien — on lui donne tout.

---

## 📐 Architecture SDD du projet

```
SDD/
├── 00_SDD_MASTER.md              ← CE FICHIER — Vue d'ensemble complète
├── 01_requirements/
│   ├── US1_requirements.md       ← Specs Sign Up
│   ├── US2_requirements.md       ← Specs Sign In
│   ├── US3_requirements.md       ← Specs Add to Cart
│   ├── US4_requirements.md       ← Specs Delete from Cart
│   └── US5_requirements.md       ← Specs Increase Items
├── 02_skills/
│   ├── technical_skills.md       ← Stack tech + Architecture + Bonnes pratiques
│   └── xpath_catalog.md          ← Tous les XPath du projet AOS
├── 03_jdd/
│   ├── jdd_us1_signup.json       ← Données test US1
│   ├── jdd_us2_signin.json       ← Données test US2
│   ├── jdd_us3_addtocart.json    ← Données test US3
│   ├── jdd_us4_delete.json       ← Données test US4
│   └── jdd_us5_increase.json     ← Données test US5
└── 04_prompts/
    ├── PROMPT_TEMPLATE.md        ← Template prompt senior réutilisable
    ├── prompt_us1.md             ← Prompt complet US1
    ├── prompt_us2.md             ← Prompt complet US2
    ├── prompt_us3.md             ← Prompt complet US3
    ├── prompt_us4.md             ← Prompt complet US4 (= biblio.md enrichi)
    └── prompt_us5.md             ← Prompt complet US5
```

---

## 📦 Les 6 couches SDD — Principe fondamental

| # | Couche | Nom technique | Contenu |
|---|---|---|---|
| 1 | 🎭 Rôle | **Role Prompting** | QA Senior, stack, pédagogie |
| 2 | 📋 Projet | **Grounding** | App, repo, architecture, branche |
| 3 | 📄 Specs | **Requirements** | User Story + Cas de test qTest |
| 4 | 🔧 Technique | **Technical Skills** | XPath, stack, fichiers existants |
| 5 | 📊 Données | **JDD** | Données valides + invalides JSON |
| 6 | 🚧 Limites | **Guardrails** | Ce que l'IA ne doit PAS faire |

---

## 🗂️ Répartition des US par membre

| US | Titre | Stack testée |
|---|---|---|
| US-1 | Sign Up | Selenium Java + Robot Framework |
| US-2 | Sign In | Selenium Java + Robot Framework |
| US-3 | Add to Cart | Selenium Java |
| US-4 | Delete from Cart | Selenium Java |
| US-5 | Increase Items in Cart | Selenium Java |

---

## 🔁 Cycle SDD → IA → Code → Test

```
1. Lire la spec qTest (requirements/)
       ↓
2. Préparer le JDD (jdd/)
       ↓
3. Identifier les XPath (xpath_catalog.md)
       ↓
4. Construire le prompt (prompts/)
   = Role + Grounding + Specs + XPath + JDD + Guardrails
       ↓
5. Générer le code avec l'IA étape par étape
       ↓
6. Valider chaque étape avant de continuer
       ↓
7. Exécuter : mvn test
       ↓
8. Vérifier le rapport HTML ExtentReports
```

---

## ✅ Règles d'or SDD dans ce projet

```
✅ Toujours partir de la spec qTest — jamais improviser
✅ Toujours préparer le JDD avant le prompt
✅ Toujours vérifier les XPath sur l'appli avant de les donner à l'IA
✅ Toujours avancer étape par étape — jamais tout générer d'un coup
✅ Toujours valider le code généré avant de passer à l'étape suivante
✅ Jamais toucher aux fichiers d'un autre membre de l'équipe

❌ Vibe Testing interdit — zéro test sans spec documentée
❌ Zéro XPath inventé — tous extraits de l'application réelle
❌ Zéro données de test inventées à la main — tout dans le JDD JSON
```

---

## 📊 Traçabilité complète

```
qTest CT_US4_01
    → SDD/01_requirements/US4_requirements.md
    → SDD/03_jdd/jdd_us4_delete.json
    → SDD/02_skills/xpath_catalog.md (section US4)
    → SDD/04_prompts/prompt_us4.md
    → TestSelenium/US-4 - Delete/src/test/java/.../CT_US4_01_DeleteProductTest.java
    → TestSelenium/US-4 - Delete/target/reports/TestReport.html
```
