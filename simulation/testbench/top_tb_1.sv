`timescale 1ns/1ps

module tb_gr_1;

    // ==========================================
    // MACRO D'ASSERTION
    // ==========================================
    `define ASSERT_EQ(name, signal, expected) \
        if ((signal) !== (expected)) begin \
            $display("========================================"); \
            $display("[ASSERTION FAILED] %s", name); \
            $display("   Temps   : %0t", $time); \
            $display("   Attendu : %0d (0x%h)", expected, expected); \
            $display("   Obtenu  : %0d (0x%h)", signal, signal); \
            $display("========================================"); \
            $finish; \
        end

    // ==========================================
    // SIGNAUX ET INSTANCIATION
    // ==========================================
    reg clk;
    reg rst;

    // Instanciation de ton processeur
    top dut (
        .clk(clk),
        .rst(rst)
    );

    // Génération de l'horloge (Période = 10ns)
    always #5 clk = ~clk;

    // ==========================================
    // SCENARIO DE TEST
    // ==========================================
    initial begin
        // 1. Initialisation
        clk = 0;
        rst = 1;
        
        // Optionnel : On charge le programme spécifique à ce groupe
        // $readmemh("programs/bin/inst_gr_1.hex", dut.inst_mem_inst.mem);

        // 2. On lâche le reset
        #20 rst = 0;

        // 3. On attend assez de cycles pour que toutes les instructions
        // traversent les 5 étages du pipeline.
        // On a ~13 instructions (avec les NOPs), on attend donc ~200ns
      #300;

        // ==========================================
        // VÉRIFICATION AUTOMATIQUE (Backdoor Access)
        // ==========================================
        $display("--- DEBUT DES VERIFICATIONS (GROUPE 1) ---");

        // Verif ADDI
        `ASSERT_EQ("Test ADDI (x5 = 10)", dut.register_file.registers[5], 32'd10)
        `ASSERT_EQ("Test ADDI (x6 = 20)", dut.register_file.registers[6], 32'd20)

        // Verif ADD
        `ASSERT_EQ("Test ADD (x7 = 30)", dut.register_file.registers[7], 32'd30)

        // Verif SUB
        `ASSERT_EQ("Test SUB (x8 = 10)", dut.register_file.registers[8], 32'd10)

        // Si on arrive ici, c'est qu'aucun $finish n'a été déclenché par une erreur
        $display("========================================");
        $display("SUCCES : Tous les tests du Groupe 1 sont passes !");
        $display("========================================");
        
        $finish;
    end

    // ==========================================
    // GESTION DES COURBES (Au cas où on doit débugger)
    // ==========================================
    initial begin
        $dumpfile("tb_gr_1.vcd");
        $dumpvars(0, tb_gr_1);  
    end

endmodule