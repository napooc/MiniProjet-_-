*** Settings ***
Library    SeleniumLibrary
Resource  ../config/setup_teardown.resource
Resource  ../resources/variables.resource
Resource  ../pages/HomePage.resource
Resource  ../pages/CategoryPage.resource
Resource  ../pages/CartPage.resource
Resource  ../pages/ProductPage.resource
Suite Setup       Open Application
Suite Teardown    Close Application
Test Setup        Go To    ${URL}

*** Test Cases ***

CT_US3_01_Add_Product_With_Quantity_Max_Allowed
    Open Category Tablets
    Select Product Tablet
    Select Color     ${COLOR_BLACK}
    Enter Quantity    ${QTE_MAX}
    Add Product To Cart
    Verify Product Added To Cart
    Verify Cart Quantity    ${QTE_MAX}

CT_US3_06_Add_Product_To_Cart_Without_Login
    Open Category Laptops
    Select Product Laptop
    Enter Quantity If Visible    ${QTE_MAX}
    Add Product To Cart
    Verify Product Added To Cart