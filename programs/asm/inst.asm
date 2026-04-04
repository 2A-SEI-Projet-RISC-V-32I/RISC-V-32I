# ==========================================
# TEST BENCH ASSEMBLEUR RISC-V (RV32I)
# ==========================================

# --- INITIALISATION ---
addi x1, x0, 10      # Registre de base 1
addi x2, x0, 20      # Registre de base 2
nop; nop; nop

# ------------------------------------------
# 1. TEST : ADDI
# ------------------------------------------
addi x3, x0, 30      # On charge 30, la valeur qu'on attendra pour l'addition
nop; nop; nop

# ------------------------------------------
# 2. TEST : ADD
# ------------------------------------------
add x4, x1, x2       # 10 + 20 = 30
nop; nop; nop
bne x4, x3, ECHEC    # Si x4 != 30, le processeur a foiré, on saute à ECHEC
nop; nop; nop

# ------------------------------------------
# 3. TEST : SUB
# ------------------------------------------
sub x5, x2, x1       # 20 - 10 = 10
nop; nop; nop
bne x5, x1, ECHEC    # Si x5 != 10 (la valeur de x1), on saute à ECHEC
nop; nop; nop

# ------------------------------------------
# 4. TEST : SLLI (Shift Left Logical Imm)
# ------------------------------------------
slli x6, x1, 1       # 10 décalé de 1 bit à gauche = 20
nop; nop; nop
bne x6, x2, ECHEC    # Si x6 != 20, on saute
nop; nop; nop

# ------------------------------------------
# 5. TEST : AND
# ------------------------------------------
addi x7, x0, 0       # x7 = 0
nop; nop; nop
and x8, x1, x2       # 10 (1010) AND 20 (10100) = 0
nop; nop; nop
bne x8, x7, ECHEC
nop; nop; nop

# ------------------------------------------
# 6 & 7. TEST : SW (Store Word) & LW (Load Word)
# ------------------------------------------
addi x9, x0, 8       # x9 = 8 (Adresse mémoire)
nop; nop; nop
sw x2, 0(x9)         # On écrit 20 à l'adresse 8
nop; nop; nop
lw x10, 0(x9)        # On lit l'adresse 8, x10 doit valoir 20
nop; nop; nop
bne x10, x2, ECHEC   # Si x10 != 20, la mémoire est cassée
nop; nop; nop

# ------------------------------------------
# 8. TEST : BEQ (Branch Equal)
# ------------------------------------------
beq x1, x1, PASS_BEQ # 10 == 10, le saut DOIT se faire
nop; nop; nop
jal x0, ECHEC        # S'il ne saute pas, il tombe ici et échoue
nop; nop; nop
PASS_BEQ:
nop; nop; nop

# ------------------------------------------
# 9. TEST : BNE (Branch Not Equal)
# ------------------------------------------
bne x1, x2, PASS_BNE # 10 != 20, le saut DOIT se faire
nop; nop; nop
jal x0, ECHEC        # Sinon, échec
nop; nop; nop
PASS_BNE:
nop; nop; nop

# ------------------------------------------
# 10. TEST : LUI (Load Upper Immediate)
# ------------------------------------------
lui x11, 0x12345     # x11 doit valoir 0x12345000
addi x12, x0, 0      # Pour tester, on va juste vérifier qu'il n'est pas nul
nop; nop; nop
beq x11, x12, ECHEC  # S'il est nul, le LUI a raté
nop; nop; nop


# ==========================================
# FIN DU PROGRAMME : GESTION DU RESULTAT
# ==========================================

# --- VICTOIRE ---
SUCCES:
addi x30, x0, 1         # On charge 1 (Code Succès)
addi x31, x0, 255       # Adresse de validation (255)
nop; nop; nop
sw x30, 0(x31)          # On écrit 1 à l'adresse 255 !
FIN_SUCCES:
jal x0, FIN_SUCCES      # Boucle infinie

# --- DEFAITE ---
ECHEC:
addi x30, x0, 0         # On charge 0 (Code Échec)
addi x31, x0, 255       # Adresse de validation (255)
nop; nop; nop
sw x30, 0(x31)          # On écrit 0 à l'adresse 255
FIN_ECHEC:
jal x0, FIN_ECHEC       # Boucle infinie