# GROUPE 6 : JUMPS ET MANIPULATION DU PC

# LUI
# Adresse 0 :
lui x5, 0x12345      # Charge 0x12345 dans le haut. x5 doit valoir 0x12345000.
nop; nop; nop        # Adresses 4, 8, 12

# AUIPC
# Adresse 16 (0x10) :
auipc x6, 2          # Immédiat = 2. On le décale de 12 (0x2000) et on l'ajoute au PC (0x10).
                     # x6 doit valoir 0x2010 (8208 en décimal).
nop; nop; nop        # Adresses 20, 24, 28

# JAL (Jump And Link)
# Adresse 32 (0x20) :
jal x7, TARGET_JAL   # Saute à TARGET_JAL (+16 octets plus bas). 
                     # x7 (Link) doit sauvegarder PC+4 (32+4 = 36 = 0x24)

# Adresse 36 (0x24) :
addi x8, x0, 99      # PIEGE : Ne doit pas s'exécuter
jal x0, END_JAL      # Saute par-dessus la cible si on tombe ici par erreur
nop                  # Adresse 44

TARGET_JAL:          # Adresse 48 (0x30) :
addi x8, x0, 1       # SUCCES : x8 = 1. Preuve qu'on a bien atterri.

END_JAL:             # Adresse 52 :
nop; nop; nop        # Adresses 52, 56, 60

# JALR (Jump And Link Register)
# Adresse 64 (0x40) :
addi x9, x0, 88      # On prépare manuellement l'adresse cible absolue 88 (0x58) dans x9
nop; nop; nop        # Adresses 68, 72, 76

# Adresse 80 (0x50) :
jalr x10, x9, 0      # Saute à l'adresse (x9 + 0) = 88.
                     # x10 (Link) doit sauvegarder PC+4 (80+4 = 84 = 0x54)

# Adresse 84 (0x54) :
addi x11, x0, 99     # PIEGE : Ne doit pas s'exécuter

TARGET_JALR:         # Adresse 88 (0x58) :
addi x11, x0, 1      # SUCCES : x11 = 1. Preuve qu'on a bien atterri.

# Adresses 92, 96, 100 :
nop; nop; nop