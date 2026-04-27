# GROUPE 3 : COMPARAISONS (SLT, SLTIU, SLTU)

# INITIALISATION
addi x1, x0, -5      # x1 = -5 (0xFFFFFFFB)
addi x2, x0, 3       # x2 = 3  (0x00000003)
addi x3, x0, -1      # x3 = -1 (0xFFFFFFFF)

# BULLES
nop; nop; nop

# SLT (Set Less Than Signé)
# Est-ce que -5 est inférieur à 3 ? OUI ! Donc le résultat doit être 1.
slt  x4, x1, x2      # x4 doit valoir 1

# BULLES
nop; nop; nop

# SLTIU (Set Less Than Immediate Non-Signé)
# Est-ce que x3 (-1) est inférieur à 3 en non-signé ?
# En non-signé, -1 est lu comme 4 294 967 295 ! Donc c'est FAUX. Le résultat doit être 0.
sltiu x5, x3, 3      # x5 doit valoir 0

# BULLES
nop; nop; nop

# SLTU (Set Less Than Non-Signé avec registres)
# Est-ce que -5 (lu comme un nombre énorme) est inférieur à 3 ? FAUX (0).
sltu x6, x1, x2      # x6 doit valoir 0

# BULLES
nop; nop; nop