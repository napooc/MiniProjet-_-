*** Settings ***
Documentation    Centralise tous les imports nécessaires à la suite US-1 Sign Up.
...              Importez ce seul fichier depuis vos suites de test.

Library     SeleniumLibrary
Resource    setup_teardown.resource
Resource    ../resources/jdd/signup_data.resource
Resource    ../resources/pages/SignupPage.resource
Resource    ../resources/utils/browser_utils.resource
