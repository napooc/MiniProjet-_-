*** Variables ***

# ══════════════════════════════════════════════
# Configuration du navigateur
# ══════════════════════════════════════════════
${BASE_URL}               https://www.advantageonlineshopping.com/#/
${BROWSER}                chrome
${IMPLICIT_WAIT}          5s

# ══════════════════════════════════════════════
# Données de test — CT_US1_01
# IMPORTANT : Le username doit être UNIQUE.
#             Modifiez-le si le compte existe déjà.
# ══════════════════════════════════════════════
${REG_USERNAME}           rimk_signup01
${REG_EMAIL}              rimk.signup01@testmail.com
${REG_PASSWORD}           SecurePass@123
${REG_CONFIRM_PASSWORD}   SecurePass@123
${REG_FIRST_NAME}         Rim
${REG_LAST_NAME}          Kajjoune
${REG_PHONE}              0612345678
${REG_COUNTRY}            United States
${REG_CITY}               Los Angeles
${REG_ADDRESS}            123 Test Avenue
${REG_ZIP}                90001
