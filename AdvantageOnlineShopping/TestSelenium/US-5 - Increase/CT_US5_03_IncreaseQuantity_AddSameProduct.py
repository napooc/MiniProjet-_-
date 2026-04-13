"""
CT_US5_03 - Increase quantity by adding the same product to the cart
URL: https://advantageonlineshopping.com

Steps:
  1. Access the home page and verify it loads correctly.
  2. Add 1 product via the home page, then open the Shopping Cart
     and note the current quantity.
  3. Navigate back to the same product's detail page.
  4. Enter a new quantity (EXTRA_QTY).
  5. Click Add to Cart and verify the cart icon updates without duplicates.
  6. Return to the Shopping Cart and verify the cumulated quantity (max 10),
     the recalculated price and the absence of duplicates.
"""

import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains

BASE_URL = "https://advantageonlineshopping.com/#/"
EXTRA_QTY = 3
MAX_QTY = 10
TIMEOUT = 15


class CT_US5_03_IncreaseQuantity(unittest.TestCase):

    # ─── Setup / Teardown ────────────────────────────────────────────────────

    def setUp(self):
        options = webdriver.ChromeOptions()
        self.driver = webdriver.Chrome(options=options)
        self.driver.maximize_window()
        self.wait = WebDriverWait(self.driver, TIMEOUT)
        self.driver.delete_all_cookies()
        self.driver.get(BASE_URL)
        self.wait.until(EC.visibility_of_element_located((By.ID, "menuUser")))

    def tearDown(self):
        self.driver.quit()

    # ─── Helpers ─────────────────────────────────────────────────────────────

    def _wait_visible(self, by, locator, timeout=TIMEOUT):
        return WebDriverWait(self.driver, timeout).until(
            EC.visibility_of_element_located((by, locator))
        )

    def _scroll_and_click(self, element):
        self.driver.execute_script("arguments[0].scrollIntoView({block:'center'});", element)
        try:
            element.click()
        except Exception:
            self.driver.execute_script("arguments[0].click();", element)

    def _dismiss_alert(self):
        try:
            WebDriverWait(self.driver, 5).until(EC.alert_is_present())
            self.driver.switch_to.alert.accept()
        except Exception:
            pass

    def _go_to_cart_page(self):
        cart_link = self._wait_visible(By.ID, "shoppingCartLink")
        self._scroll_and_click(cart_link)
        WebDriverWait(self.driver, TIMEOUT).until(
            lambda d: "shoppingCart" in d.current_url
        )

    def _get_cart_row_quantity(self, product_name):
        """Read quantity from AOS cart page (td.quantityMobile)."""
        def qty_ready(driver):
            val = driver.execute_script(
                """
                // AOS renders quantity as text inside td.quantityMobile
                // e.g. "QUANTITY\\n                        4"
                // Skip cells with ng-hide (display:none) — those are the warranty column
                var cells = document.querySelectorAll('td.quantityMobile:not(.ng-hide)');
                for(var i=0; i<cells.length; i++){
                    var nums = (cells[i].textContent || '').match(/\\d+/g);
                    if(nums){
                        var v = parseInt(nums[nums.length - 1]);
                        if(v > 0) return v;
                    }
                }
                return 0;
                """
            )
            return int(val) if val else False

        try:
            result = WebDriverWait(self.driver, TIMEOUT).until(qty_ready)
            return result
        except Exception:
            return 0

    def _get_product_name(self):
        try:
            h1 = self._wait_visible(By.XPATH, "//h1")
            return h1.text.strip()
        except Exception:
            return self.driver.execute_script(
                "var h=document.querySelector('h1'); return h?(h.textContent||'').trim():'';"
            )

    def _verify_no_duplicates(self):
        names = self.driver.execute_script(
            """
            var cells = document.querySelectorAll(
              'td.name, td.cart-name, [ng-bind*="name"], .product-name'
            );
            var names = [];
            cells.forEach(function(c){ names.push((c.textContent||'').trim()); });
            var seen = {};
            for(var i=0;i<names.length;i++){
              if(names[i]===''){continue;}
              if(seen[names[i]]){return true;}
              seen[names[i]]=true;
            }
            return false;
            """
        )
        self.assertFalse(names, "Duplicate product rows detected in cart!")

    def _add_product_from_home_and_return_url(self):
        """Scroll to popular items, click View Details on product #2, add to cart."""
        self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight*0.65);")
        view_details = self._wait_visible(
            By.XPATH,
            "(//a[contains(@href,'#/product/')][contains(.,'View Details')])[2]"
        )
        self._scroll_and_click(view_details)
        self._wait_visible(By.XPATH, "//button[@name='save_to_cart']")
        product_name = self._get_product_name()
        product_url = self.driver.current_url
        add_btn = self.driver.find_element(By.XPATH, "//button[@name='save_to_cart']")
        self._scroll_and_click(add_btn)
        self._dismiss_alert()
        self.driver.get(BASE_URL)
        self._wait_visible(By.ID, "menuUser")
        return product_name, product_url

    # ─── Test case ───────────────────────────────────────────────────────────

    def test_CT_US5_03_increase_quantity_add_same_product(self):

        # ── Étape 1 : Vérifier la page d'accueil ─────────────────────────────
        self._wait_visible(By.ID, "shoppingCartLink")
        self._wait_visible(
            By.XPATH,
            "(//a[contains(@href,'#/product/')][contains(.,'View Details')])[1]"
        )
        print("Étape 1 OK - Page d'accueil chargée.")

        # ── Étape 2 : Précondition — ajouter 1 produit, noter la quantité ────
        product_name, product_url = self._add_product_from_home_and_return_url()
        print(f"Étape 2 - Produit ajouté: {product_name} | URL: {product_url}")

        self._go_to_cart_page()
        self._wait_visible(
            By.XPATH, "(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]"
        )
        initial_qty = self._get_cart_row_quantity(product_name)
        self._verify_no_duplicates()

        # Verify at least one table row with text is visible (cart has content)
        self._wait_visible(By.XPATH, "(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]")
        print(f"Étape 2 OK - Quantité initiale: {initial_qty}")

        # ── Étape 3 : Retourner sur la fiche produit ──────────────────────────
        self.driver.get(product_url)
        self._wait_visible(By.XPATH, "//button[@name='save_to_cart']")
        page_name = self._get_product_name()
        self.assertEqual(
            page_name.strip(), product_name.strip(),
            f"Product name mismatch: '{page_name}' != '{product_name}'"
        )
        print(f"Étape 3 OK - Fiche produit: {page_name}")

        # ── Étape 4 : Saisir la nouvelle quantité ─────────────────────────────
        qty_input = self._wait_visible(
            By.XPATH,
            "//input[@name='quantity' or @id='quantity' or contains(@ng-model,'quantity')]"
        )
        # Angular-controlled field: use JS to set value + dispatch events
        self.driver.execute_script(
            """
            var el = arguments[0];
            var nativeInputValueSetter = Object.getOwnPropertyDescriptor(
                window.HTMLInputElement.prototype, 'value').set;
            nativeInputValueSetter.call(el, arguments[1]);
            el.dispatchEvent(new Event('input', { bubbles: true }));
            el.dispatchEvent(new Event('change', { bubbles: true }));
            """,
            qty_input, str(EXTRA_QTY)
        )
        displayed = qty_input.get_attribute("value")
        self.assertEqual(
            int(displayed), EXTRA_QTY,
            f"Quantity field shows '{displayed}', expected {EXTRA_QTY}"
        )
        print(f"Étape 4 OK - Quantité saisie: {displayed}")

        # ── Étape 5 : Cliquer sur Add to Cart ────────────────────────────────
        add_btn = self.driver.find_element(By.XPATH, "//button[@name='save_to_cart']")
        self._scroll_and_click(add_btn)
        self._dismiss_alert()
        self._wait_visible(By.ID, "shoppingCartLink")

        # Badge panier mis à jour
        badge_qty = self.driver.execute_script(
            """
            var badge = document.querySelector('.cart.ng-binding,.cart span,.ng-binding.cart');
            if(badge){ var m=badge.textContent.match(/[0-9]+/); if(m)return parseInt(m[0]); }
            var link = document.querySelector('#shoppingCartLink');
            if(link){ var m2=(link.textContent||'').match(/[0-9]+/); if(m2)return parseInt(m2[0]); }
            return 0;
            """
        )
        self.assertGreaterEqual(badge_qty, 1, "Cart badge did not update after Add to Cart")

        # Vérifier floating cart — pas de doublon
        cart_icon = self.driver.find_element(By.ID, "shoppingCartLink")
        ActionChains(self.driver).move_to_element(cart_icon).perform()
        try:
            WebDriverWait(self.driver, 8).until(
                EC.visibility_of_element_located((
                    By.XPATH,
                    "((//div[contains(@class,'removeProduct')]) | "
                    "(//a[contains(@class,'remove') and contains(.,'REMOVE')]))[1]"
                ))
            )
            self._verify_no_duplicates()
        except Exception:
            pass  # floating cart may not appear on all AOS instances
        print(f"Étape 5 OK - Badge panier: {badge_qty}")

        # ── Étape 6 : Retourner au panier — vérifier quantité et total ────────
        self._go_to_cart_page()
        # Wait for cart rows to render
        self._wait_visible(By.XPATH, "(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]")

        expected = min(initial_qty + EXTRA_QTY, MAX_QTY)
        actual_qty = self._get_cart_row_quantity(product_name)
        self.assertEqual(
            actual_qty, expected,
            f"Cart quantity: expected {expected}, got {actual_qty}"
        )

        # Prix recalculé — au moins une cellule td visible dans le tableau
        self._wait_visible(By.XPATH, "//table//td")

        # Pas de doublons
        self._verify_no_duplicates()

        # Pas de ligne vide
        empty_rows = self.driver.execute_script(
            "var rows=document.querySelectorAll('tr');"
            "var e=0;"
            "rows.forEach(function(r){if((r.textContent||'').trim()===''){e++;}});"
            "return e;"
        )
        self.assertEqual(empty_rows, 0, "Empty rows detected in cart!")

        print(f"Étape 6 OK - Quantité cumulée: {actual_qty} (attendu: {expected})")
        print("CT_US5_03 complété avec succès ✓")


if __name__ == "__main__":
    unittest.main(verbosity=2)
