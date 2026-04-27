# GROUPE 8 : HAZARD UNIT (Load-Use & Jump)

# DEPENDANCE LOAD-USE
addi x1, x0, 8       # x1 = 8 (Adresse)
addi x2, x0, 42      # x2 = 42 (Donnee)
sw   x2, 0(x1)       # On ecrit 42 a l'adresse 8
lw   x3, 0(x1)       # On charge depuis l'adresse 8 (x3 va valoir 42)

# ALERTE LOAD-USE : Le ADD a besoin de x3 tout de suite ! 
# Hazard control doit mettre STALL a 1 pour geler cette instruction pendant 1 cycle.
add  x4, x3, x2      # x4 = 42 + 42 = 84

# CONTROL HAZARD (Flush sur BEQ)
# Ce saut va reussir. Pendant qu'il se calcule, les deux instructions
# "addi x5, x0, 99" vont entrer dans le pipeline. 
# Hazard control doit envoyer un flush pour les transformer en zéros
beq  x1, x1, TARGET_BEQ
addi x5, x0, 99      # PIEGE : Sera dans l'etage Decode (Doit etre flushé)
addi x5, x0, 99      # PIEGE : Sera dans l'etage Fetch (Doit etre flushé)

TARGET_BEQ:
addi x5, x0, 1       # CIBLE : Si le flush a bien marché, x5 = 1 (Pas 99)

# CONTROL HAZARD (Flush sur JAL)
# Pareille mais avec un saut inconditionnel.
jal  x6, TARGET_JAL
addi x7, x0, 99      # PIEGE (Doit etre flushé)
addi x7, x0, 99      # PIEGE (Doit etre flushé)

TARGET_JAL:
addi x7, x0, 1       # CIBLE : x7 = 1

# BULLES
nop; nop; nop