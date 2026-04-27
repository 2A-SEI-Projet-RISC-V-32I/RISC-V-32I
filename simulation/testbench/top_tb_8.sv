module top_tb_8;

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

    reg clk;
    reg rst;

    wire wr_en_M;
    wire [2:0] funct_3_M;
    wire [31:0] rs2_M;
    wire [31:0] o_alu_M;
    wire [31:0] o_data;
    wire [31:0] o_pc;
    wire [31:0] inst;


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


    always #5 clk = ~clk;


    initial begin

        $readmemh("programs/bin/inst_gr_8.hex", inst_mem.mem);

        clk = 0;
        rst = 1;
        
        #20 rst = 0;


        #350; 


        $display("--- DEBUT DES VERIFICATIONS (GROUPE 8 - HAZARD UNIT) ---");

        // LOAD-USE STALL
        // Si x4 vaut 84, c'est que le processeur s'est bien mis en pause 1 cycle pour attendre le LW.
        // S'il vaut 42, c'est que le STALL a échoué et qu'il a lu l'ancienne valeur de x3 (0).
        `ASSERT_EQ("Test Stall Load-Use (x4 = 84)", dut.register_file.registers[4], 32'd84)

        // CONTROL HAZARD (BEQ)
        // Si x5 vaut 99, c'est que le FLUSH n'a pas marché.
        `ASSERT_EQ("Test Flush BEQ (x5 = 1)", dut.register_file.registers[5], 32'd1)

        // CONTROL HAZARD (JAL)
        // Si x7 vaut 99, c'est que le FLUSH n'a pas marché.
        `ASSERT_EQ("Test Flush JAL (x7 = 1)", dut.register_file.registers[7], 32'd1)

        // Si tout est bon
        $display("");
        $display("SUCCES : Groupe 8");
        $display("");
        
        $finish;
    end
      
    initial begin
        $dumpfile("top_tb_8.vcd");
        $dumpvars(0, top_tb_8);  
    end

endmodule