*** Variables ***

# ══════════════════════════════════════════════
# Configuration du navigateur
# ══════════════════════════════════════════════
${BASE_URL}           https://www.advantageonlineshopping.com/#/
${BROWSER}            chrome
${IMPLICIT_WAIT}      5s

# ══════════════════════════════════════════════
# Données de test — CT_US2_01
# PRÉREQUIS : Ce compte doit exister avant l'exécution.
#             Créez le compte via CT_US1_01 en définissant username=rimkQA2026x
#             puis lancez CT_US2_01. Password max 12 chars.
# ══════════════════════════════════════════════
${LOGIN_USERNAME}     rimkQA2026x
${LOGIN_PASSWORD}     SecPass123
