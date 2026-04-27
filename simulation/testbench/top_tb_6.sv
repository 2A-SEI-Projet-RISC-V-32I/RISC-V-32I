module top_tb_6;

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

        $readmemh("programs/bin/inst_gr_6.hex", inst_mem.mem);

        clk = 0;
        rst = 1;
        
        #20 rst = 0;

        #400; 


        $display("GROUPE 6");

        // LUI (Doit valoir 0x12345000)
        `ASSERT_EQ("Test LUI (x5)", dut.register_file.registers[5], 32'h12345000)

        // AUIPC (Doit valoir 0x2000 + 0x10 = 0x2010)
        `ASSERT_EQ("Test AUIPC (x6)", dut.register_file.registers[6], 32'h00002010)

        // JAL (Link et Saut)
        // L'adresse de retour sauvegardée dans x7 doit être 36 (0x24)
        `ASSERT_EQ("Test JAL [Link] (x7 = PC+4)", dut.register_file.registers[7], 32'h00000024)
        // Si x8 vaut 1, on a bien esquivé le piège pour atterrir sur la bonne instruction
        `ASSERT_EQ("Test JAL [Jump] (x8 = 1)", dut.register_file.registers[8], 32'd1)

        // JALR (Link et Saut Absolu)
        // L'adresse de retour sauvegardée dans x10 doit être 84 (0x54)
        `ASSERT_EQ("Test JALR [Link] (x10 = PC+4)", dut.register_file.registers[10], 32'h00000054)
        // Si x11 vaut 1, le processeur a bien suivi l'adresse contenue dans x9
        `ASSERT_EQ("Test JALR [Jump] (x11 = 1)", dut.register_file.registers[11], 32'd1)

        // Si tout est bon
        $display("");
        $display("SUCCES : Groupe 6");
        $display("");
        
        $finish;
    end
      
    initial begin
        $dumpfile("top_tb_6.vcd");
        $dumpvars(0, top_tb_6);  
    end

endmodule