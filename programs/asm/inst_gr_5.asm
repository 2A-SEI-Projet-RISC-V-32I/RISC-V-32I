# GROUPE 5 : BRANCHEMENTS CONDITIONNELS (BEQ, BLT, BGEU)

# INITIALISATION
addi x1, x0, 10      # x1 = 10
addi x2, x0, 10      # x2 = 10
addi x3, x0, -5      # x3 = -5
addi x4, x0, 5       # x4 = 5
nop; nop; nop


# BEQ (10 == 10) -> Doit sauter

beq x1, x2, TARGET_BEQ    # Si x1 == x2, saute par-dessus le piège
nop; nop; nop             # (Attente pour purger le pipeline)

addi x5, x0, 99           # PIEGE : Si on ne saute pas, x5 = 99 (ECHEC)
jal x0, END_BEQ           # On évite d'exécuter la suite par erreur

TARGET_BEQ:               
addi x5, x0, 1            # CIBLE : Si on a bien sauté, x5 = 1 (SUCCES)
END_BEQ:
nop; nop; nop

# BLT (-5 < 5 Signé) -> Doit sauter

blt x3, x4, TARGET_BLT    # Si -5 < 5, saute
nop; nop; nop

addi x6, x0, 99           # PIEGE : x6 = 99
jal x0, END_BLT

TARGET_BLT:               
addi x6, x0, 1            # CIBLE : x6 = 1 (SUCCES)
END_BLT:
nop; nop; nop

# BGEU (-5 >= 5 Non-Signé) -> Doit sauter
# Rappel : En non-signé, -5 est lu comme 4 294 967 291 !
# Donc 4 294 967 291 >= 5 est VRAI.

bgeu x3, x4, TARGET_BGEU  # Si -5 >= 5 (non-signé), saute
nop; nop; nop

addi x7, x0, 99           # PIEGE : x7 = 99
jal x0, END_BGEU

TARGET_BGEU:              
addi x7, x0, 1            # CIBLE : x7 = 1 (SUCCES)
END_BGEU:
nop; nop; nop