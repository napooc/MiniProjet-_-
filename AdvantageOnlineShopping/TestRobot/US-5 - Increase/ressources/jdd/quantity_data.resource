*** Settings ***
Documentation    Données de test

*** Variables ***
# Quantités valides
${VALID_QTY_1}              2
${VALID_QTY_2}              5
${VALID_QTY_3}              10
${INITIAL_QTY}              1

# Quantités invalides
${INVALID_QTY_NEGATIVE}     -1
${INVALID_QTY_ZERO}         0
${INVALID_QTY_TOO_HIGH}     999
${INVALID_QTY_TEXT}         abc
${INVALID_QTY_DECIMAL}      2.5

# Produits
${PRODUCT_1_NAME}           HP Roar Mini Wireless Speaker
${PRODUCT_2_NAME}           HP CHROMEBOOK 14 G1(ENERGY STAR)
${PRODUCT_3_NAME}           BEATS STUDIO 2 OVER-EAR MATTE BLACK HEADPHONES

# Catégories
${CATEGORY_SPEAKERS}        SPEAKERS
${CATEGORY_LAPTOPS}         LAPTOPS
${CATEGORY_HEADPHONES}      HEADPHONES


# Xpath des produits
${PRODUCT_1_XPATH}     //img[@id="24"]
${PRODUCT_2_XPATH}     //img[@id="9"]
${PRODUCT_3_XPATH}     //img[@id="13"]