# GROUPE 2 : LOGIQUE ET DECALAGES (AND, SLL, SRAI)


# INITIALISATION
addi x5, x0, 10      # x5 = 10 (0x0A)
addi x6, x0, 12      # x6 = 12 (0x0C)
addi x8, x0, 2       # x8 = 2  (Pour la valeur du décalage)
addi x10, x0, -16    # x10 = -16 (0xFFFFFFF0) -> Nombre négatif pour tester le signe

# BULLES
nop; nop; nop

# AND
# 10 (1010 en binaire) AND 12 (1100 en binaire) = 8 (1000 en binaire)
and  x7, x5, x6      # x7 doit valoir 8

# SLL (Shift Left Logical)
# On décale 10 de 2 bits vers la gauche (10 * 2^2) = 40
sll  x9, x5, x8      # x9 doit valoir 40

# SRAI (Shift Right Arithmetic Immediate)
# On décale -16 de 2 bits vers la droite en GARDANT LE SIGNE (-16 / 4) = -4
# Si ton ALU a un bug et fait un décalage logique au lieu d'arithmétique, 
# tu obtiendras 1073741820 au lieu de -4 !
srai x11, x10, 2     # x11 doit valoir -4 (0xFFFFFFFC)

# BULLES
nop; nop; nop