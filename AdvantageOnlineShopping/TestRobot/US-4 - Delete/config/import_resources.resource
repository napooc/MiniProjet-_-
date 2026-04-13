*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

# US-3 Add Products Resources
Resource    ${US3_IMPORT_RESOURCE}

# US-4 Delete Resources
Resource    ../ressources/utils/browser_utils.resource
Resource    ../ressources/pages/HomePage.resource
Resource    ../ressources/pages/ShoppingCartPage.resource
Resource    ../config/setup_teardown.resource

*** Variables ***
${US3_IMPORT_RESOURCE}    ..${/}..${/}US-3${SPACE}${SPACE}-${SPACE}ADD${/}config${/}import_resources.resource
