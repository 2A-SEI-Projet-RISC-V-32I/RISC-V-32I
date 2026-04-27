# GROUPE 7 : FORWARDING UNIT

# DEPENDANCE ALU-ALU
# On enchaine 4 calculs sans AUCUNE bulle. 
addi x1, x0, 15      # x1 = 15
addi x2, x0, 25      # x2 = 25
add  x3, x1, x2      # x3 = 15 + 25 = 40 (x2 vient de EX/MEM, x1 de MEM/WB)
sub  x4, x3, x1      # x4 = 40 - 15 = 25 (x3 vient de EX/MEM)

# DEPENDANCE ALU-MEMORY
# On calcule l'adresse et la donnee, et on fait le Store immediatement !
addi x5, x0, 8       # x5 = 8  (L'adresse)
addi x6, x0, 99      # x6 = 99 (La donnee)
sw   x6, 0(x5)       # On ecrit 99 a l'adresse 8. 
                     # -> Le 8 et le 99 sont forwardes directement depuis l'ALU !

# VERIFICATION
# On attend un peu que la RAM s'ecrive (Dépendance Load-Use)
nop; nop; nop
lw   x7, 0(x5)       # On relit l'adresse 8. x7 doit valoir 99 !

# BULLES
nop; nop; nop