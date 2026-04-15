# ═══════════════════════════════════════════════════════════════
#   TECHNICAL SKILLS — Stack & Architecture
#   Projet : Advantage Online Shopping
# ═══════════════════════════════════════════════════════════════

## 🛠️ Stack Technique Complète

### Selenium Java (US-3, US-4, US-5)

| Technologie | Version | Rôle |
|---|---|---|
| **Java** | 11+ | Langage de programmation |
| **Selenium WebDriver** | 4.x | Automatisation navigateur |
| **TestNG** | 7.x | Framework de test |
| **Maven** | 3.x | Gestion des dépendances + build |
| **ExtentReports** | 5.x | Reporting HTML |
| **ChromeDriver** | Auto (WebDriverManager) | Pilote Chrome |

### Robot Framework (US-1, US-2)

| Technologie | Version | Rôle |
|---|---|---|
| **Python** | 3.8+ | Langage de base |
| **Robot Framework** | 6.x | Framework de test |
| **SeleniumLibrary** | 6.x | Librairie Selenium pour RF |
| **Browser Library** | optionnel | Alternative moderne |

---

## 🏗️ Architecture Page Object Model (POM)

### Principe POM

```
❌ Sans POM — Anti-pattern
──────────────────────────
public void test() {
    driver.findElement(By.xpath("//button[@id='sign_in_btn']")).click();
    driver.findElement(By.xpath("//input[@name='username']")).sendKeys("user");
    // XPath éparpillés partout dans les tests
    // Un changement XPath = modifier 10 fichiers
}

✅ Avec POM — Bonne pratique
─────────────────────────────
public void test() {
    loginPage.enterUsername("user");
    loginPage.clickSignIn();
    // Les XPath sont dans LoginPage.java
    // Un changement XPath = modifier 1 seul fichier
}
```

### Structure POM du projet

```
src/
├── main/java/com/aos/usX/
│   └── pages/
│       ├── LoginPage.java        ← Encapsule les actions de connexion
│       ├── CartPage.java         ← Encapsule les actions du panier
│       ├── ProductPage.java      ← Encapsule les actions produit
│       └── RegisterPage.java     ← Encapsule le formulaire d'inscription
│
└── test/java/com/aos/usX/
    ├── base/
    │   └── BaseTest.java         ← Setup/Teardown commun à tous les tests
    ├── tests/
    │   ├── CT_USX_01_NomTest.java
    │   └── CT_USX_02_NomTest.java
    └── utils/
        ├── ConfigReader.java     ← Lit config.properties
        ├── DriverFactory.java    ← Crée/détruit le WebDriver
        └── ScreenshotHelper.java ← Capture screenshot en Base64
```

---

## 📄 Fichiers existants — NE PAS RECRÉER

### BaseTest.java (existant dans US-4)

```java
// Ce que BaseTest.java fait déjà :
@BeforeSuite  → Crée le rapport ExtentReports HTML
@BeforeMethod → Lance Chrome + navigue vers l'URL
@AfterMethod  → Screenshot si échec + log Pass/Fail/Skip
@AfterSuite   → Sauvegarde le rapport HTML final

// Méthodes utilitaires disponibles :
logStep(String)  → Log une étape dans le rapport
logPass(String)  → Log un succès
logFail(String)  → Log un échec
```

### ConfigReader.java — Lecture config.properties

```java
// Usage dans les tests :
ConfigReader.get("base.url")      // → https://www.advantageonlineshopping.com
ConfigReader.get("browser")       // → chrome
ConfigReader.get("report.path")   // → target/reports
ConfigReader.get("report.name")   // → TestReport.html
ConfigReader.get("username")      // → JohnDoe2026
ConfigReader.get("password")      // → Test@1234
```

### DriverFactory.java — Gestion WebDriver

```java
// Usage dans BaseTest :
DriverFactory.initDriver()   // Crée le driver selon le browser en config
DriverFactory.getDriver()    // Retourne le driver courant
DriverFactory.quitDriver()   // Ferme le navigateur proprement
```

### config.properties (US-4 existant)

```properties
base.url     = https://www.advantageonlineshopping.com
browser      = chrome
report.path  = target/reports
report.name  = TestReport.html
username     = JohnDoe2026
password     = Test@1234
```

---

## 📐 Conventions de nommage

### Fichiers Java

| Type | Convention | Exemple |
|---|---|---|
| Page Object | `NomPage.java` | `CartPage.java` |
| Test | `CT_USXX_YY_NomTest.java` | `CT_US4_01_DeleteProductTest.java` |
| Utils | `NomHelper.java` | `ScreenshotHelper.java` |
| Base | `BaseTest.java` | `BaseTest.java` |

### Méthodes Java

| Type | Convention | Exemple |
|---|---|---|
| Action | `verbNom()` | `clickDeleteButton()` |
| Vérification | `isNom()` | `isCartEmpty()` |
| Attente | `waitForNom()` | `waitForCartToLoad()` |
| Saisie | `enterNom(String val)` | `enterUsername(String u)` |

### Fichiers Robot Framework

| Type | Convention | Exemple |
|---|---|---|
| Suite | `CT_USXX_YY_nom.robot` | `CT_US1_01_signup_valid.robot` |
| Resource page | `NomPage.resource` | `SignupPage.resource` |
| Resource JDD | `nom_data.resource` | `signup_data.resource` |

---

## ⏳ Gestion des attentes WebDriver

```java
// ✅ À utiliser — WebDriverWait (attente explicite)
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[@id='sign_in_btn']")));

// ❌ À éviter — Thread.sleep (attente fixe non fiable)
Thread.sleep(3000); // INTERDIT sauf cas exceptionnel documenté
```

---

## 🔧 Dépendances Maven (pom.xml)

```xml
<!-- Selenium -->
<dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>4.15.0</version>
</dependency>

<!-- TestNG -->
<dependency>
    <groupId>org.testng</groupId>
    <artifactId>testng</artifactId>
    <version>7.8.0</version>
    <scope>test</scope>
</dependency>

<!-- ExtentReports -->
<dependency>
    <groupId>com.aventstack</groupId>
    <artifactId>extentreports</artifactId>
    <version>5.1.1</version>
</dependency>

<!-- WebDriverManager (gestion auto ChromeDriver) -->
<dependency>
    <groupId>io.github.bonigarcia</groupId>
    <artifactId>webdrivermanager</artifactId>
    <version>5.6.3</version>
</dependency>
```

---

## 🚀 Commandes d'exécution

```bash
# Exécuter tous les tests
mvn test

# Exécuter un test spécifique
mvn test -Dtest=CT_US4_01_DeleteProductTest

# Exécuter avec un browser spécifique
mvn test -Dbrowser=chrome

# Générer rapport uniquement
mvn surefire-report:report

# Robot Framework
robot suites/CT_US1_01_signup_valid.robot
```
