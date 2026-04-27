# GROUPE 4 : MEMOIRE (SW/LW, SH/LH/LHU, SB/LB/LBU)


# INITIALISATION
addi x1, x0, 8       # x1 = 8 (Notre adresse mémoire de base)
addi x2, x0, -500    # x2 = -500 (0xFFFFFE0C) -> Mot entier (32 bits)
addi x4, x0, -2      # x4 = -2   (0xFFFFFFFE) -> Demi-mot (16 bits) 
addi x7, x0, -5      # x7 = -5   (0xFFFFFFFB) -> Octet (8 bits)
nop; nop; nop

# SW / LW (Mot Complet de 32 bits)
sw x2, 0(x1)         # On stocke -500 à l'adresse 8
nop; nop; nop
lw x3, 0(x1)         # On le relit et on le met dans x3
nop; nop; nop        # x3 doit valoir 0xFFFFFE0C (-500)

# SH / LH / LHU (Demi-Mot de 16 bits)
sh x4, 4(x1)         # On stocke les 16 bits de poids faible de x4 (0xFFFE) à l'adresse 12
nop; nop; nop
lh x5, 4(x1)         # Load Half-word (Signé). Le processeur voit le MSB à 1, il prolonge les F.
                     # x5 doit valoir 0xFFFFFFFE (-2)
nop; nop; nop
lhu x6, 4(x1)        # Load Half-word (Non-Signé). Le processeur bourre de zéros.
                     # x6 doit valoir 0x0000FFFE (65534)
nop; nop; nop

# SB / LB / LBU (Octet de 8 bits)
sb x7, 8(x1)         # On stocke les 8 bits de poids faible de x7 (0xFB) à l'adresse 16
nop; nop; nop
lb x8, 8(x1)         # Load Byte (Signé). x8 doit valoir 0xFFFFFFFB (-5)
nop; nop; nop
lbu x9, 8(x1)        # Load Byte (Non-Signé). x9 doit valoir 0x000000FB (251)
nop; nop; nop