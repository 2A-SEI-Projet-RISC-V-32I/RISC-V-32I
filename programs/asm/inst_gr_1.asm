# ==========================================
# GROUPE 1 : FONDATIONS (ADDI, ADD, SUB)
# ==========================================

# --- INITIALISATION (Test ADDI) ---
addi x5, x0, 10      # Test ADDI : x5 = 10
addi x6, x0, 20      # Test ADDI : x6 = 20

# --- BULLES (Attente d'écriture dans le RegFile) ---
nop
nop
nop

# --- ADDITION (Test ADD) ---
add  x7, x5, x6      # Test ADD : x7 = 10 + 20 = 30

# --- BULLES ---
nop
nop
nop

# --- SOUSTRACTION (Test SUB) ---
sub  x8, x6, x5      # Test SUB : x8 = 20 - 10 = 10

# --- BULLES FINALES (Pour laisser le Write-Back se finir) ---
nop
nop
nop