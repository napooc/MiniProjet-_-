*** Settings ***
Resource    ../ressources/utils/browser_utils.resource

*** Keywords ***
Global Setup
    Open Browser To Application

Global Teardown
    Close Browser

Setup CT01
    Global Setup

Teardown CT01
    Global Teardown

Setup CT02
    Global Setup

Teardown CT02
    Global Teardown