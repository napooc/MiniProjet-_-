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
#             Vous pouvez utiliser le compte créé par CT_US1_01 :
#             username = rimk_signup01 / password = SecurePass@123
# ══════════════════════════════════════════════
${LOGIN_USERNAME}     rimk_signup01
${LOGIN_PASSWORD}     SecurePass@123
