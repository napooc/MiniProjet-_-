*** Settings ***
Documentation    Centralise tous les imports nécessaires à la suite US-2 Sign In.
...              Importez ce seul fichier depuis vos suites de test.

Library     SeleniumLibrary
Resource    setup_teardown.resource
Resource    ../resources/jdd/signin_data.resource
Resource    ../resources/pages/SigninPage.resource
Resource    ../resources/utils/browser_utils.resource
