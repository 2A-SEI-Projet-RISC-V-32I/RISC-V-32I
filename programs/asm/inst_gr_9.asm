# GROUPE 9 : Fibonacci Stress Test
# Calcule Fib(5). Le code C correspondant donne (a = 5) a la fin.

# INITIALISATION MEMOIRE
addi x5, x0, 200     # x5 = 200 (Adresse ou on va stocker les variables)
addi x6, x0, 0       
sw   x6, 0(x5)       # a = 0 (Stocké à l'adresse 200)
addi x7, x0, 1       
sw   x7, 4(x5)       # b = 1 (Stocké à l'adresse 204)

# INITIALISATION VARIABLES DE BOUCLE
addi x8, x0, 6       # n = 6
addi x9, x0, 1       # i = 1

# ==========================================
LOOP:
# 1. TEST CONTROL HAZARD (Saut conditionnel)
bge  x9, x8, END     # Si i >= n, on sort de la boucle

# 2. TEST LOAD-USE HAZARD (Stall)
lw   x10, 0(x5)      # x10 = a
lw   x11, 4(x5)      # x11 = b
add  x12, x10, x11   # c = a + b (ATTENTION : x11 vient juste d'etre lu ! STALL OBLIGATOIRE)

# 3. TEST ALU-MEMORY FORWARDING
sw   x11, 0(x5)      # a = b
sw   x12, 4(x5)      # b = c (ATTENTION : x12 vient juste d'etre calculé ! FORWARD OBLIGATOIRE)

addi x9, x9, 1       # i++

# 4. TEST CONTROL HAZARD (Flush de boucle)
jal  x0, LOOP        # Retour au début de la boucle
# ==========================================

END:
lw   x13, 0(x5)      # On recupere 'a' (le resultat de la fonction C) dans x13

# BULLES
nop; nop; nop