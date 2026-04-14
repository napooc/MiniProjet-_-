*** Variables ***
${URL}              http://advantageonlineshopping.com/#/
${BROWSER}          Chrome

# Common
${CartLink_xpath}   //a[@id="shoppingCartLink"]
${Button_xpath}     //button[@name="save_to_cart"]
${QTE_MAX}          10

# CT_US3_01 - Add tablet with color
${CATEGORY_01}      TABLETS
${CATEGORY_01_XPATH}   //div[@id="tabletsImg"]
${PRODUCT_01_ID}    18
${PRODUCT_01_NAME}  HP Pro Tablet 608 G1
${PRODUCT_01_ASSERT}  HP Pro Tablet
${COLOR_BLACK}      BLACK

# CT_US3_06 - Add laptop without login
${CATEGORY_06}      LAPTOPS
${CATEGORY_06_XPATH}   //div[@id="laptopsImg"]
${PRODUCT_06_ID}    1
${PRODUCT_06_NAME}  HP Pavilion 15z Laptop
${PRODUCT_06_ASSERT}  HP Pavilion
