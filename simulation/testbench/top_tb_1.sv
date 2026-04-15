`timescale 1ns/1ps

module top_tb_1;

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
    // SIGNAUX
    // ==========================================
    reg clk;
    reg rst;

    wire wr_en_M;
    wire [2:0] funct_3_M;
    wire [31:0] rs2_M;
    wire [31:0] o_alu_M;
    wire [31:0] o_data;
    wire [31:0] o_pc;
    wire [31:0] inst;

    // ==========================================
    // INSTANCIATIONS
    // ==========================================
    processor dut (
        .clk(clk),
        .rst(rst),
        .wr_en_M (wr_en_M),
        .funct_3_M (funct_3_M),
        .rs2_M (rs2_M),
        .o_alu_E_top (o_alu_M),
        .i_data_mem (o_data),
        .o_pc_top (o_pc),
        .i_inst_mem (inst)
    );

    data_mem data_mem(
        .i_clk (clk),
        .i_we (wr_en_M),
        .i_func3 (funct_3_M),
        .i_data (rs2_M),
        .i_addr (o_alu_M[11:0]),
        .o_data (o_data)
    );

    inst_mem inst_mem(
        .clk (clk),
        .addr (o_pc[11:2]),
        .inst (inst)
    );

    // ==========================================
    // HORLOGE
    // ==========================================
    always #5 clk = ~clk;

    // ==========================================
    // SCENARIO DE TEST
    // ==========================================
    initial begin

        // Initialisation et Reset
        clk = 0;
        rst = 1;
        
        #20 rst = 0;

        // Attente de l'exécution du programme
        // ~13 instructions * 10ns + marge = 250ns
        #300; 

        // ==========================================
        // VÉRIFICATION AUTOMATIQUE (Backdoor Access)
        // ==========================================
        $display("--- DEBUT DES VERIFICATIONS (GROUPE 1) ---");

        // Verif ADDI
        // ATTENTION : J'ai mis "register_file_inst". Si ton instance dans processor.sv
        // s'appelle juste "register_file" ou "rf", modifie le nom ci-dessous !
        `ASSERT_EQ("Test ADDI (x5 = 10)", dut.register_file.registers[5], 32'd10)
        `ASSERT_EQ("Test ADDI (x6 = 20)", dut.register_file.registers[6], 32'd20)

        // Verif ADD
        `ASSERT_EQ("Test ADD (x7 = 30)", dut.register_file.registers[7], 32'd30)

        // Verif SUB
        `ASSERT_EQ("Test SUB (x8 = 10)", dut.register_file.registers[8], 32'd10)

        // Si tout est bon
        $display("========================================");
        $display("SUCCES : Tous les tests du Groupe 1 sont passes !");
        $display("========================================");
        
        $finish;
    end
      
    // ==========================================
    // DUMP DES COURBES (Optionnel)
    // ==========================================
    initial begin
        $dumpfile("tb_gr_1.vcd");
        $dumpvars(0, tb_gr_1);  
    end

endmodule