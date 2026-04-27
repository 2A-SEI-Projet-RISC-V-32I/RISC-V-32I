module top_tb_3;

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

        $readmemh("programs/bin/inst_gr_3.hex", inst_mem.mem);

        clk = 0;
        rst = 1;
        
        #20 rst = 0;

        #350; 


        $display("GROUPE 3");

        // Verif Initialisation
        `ASSERT_EQ("Init x1 (-5)", dut.register_file.registers[1], 32'hFFFFFFFB)
        `ASSERT_EQ("Init x2 (3)",  dut.register_file.registers[2], 32'd3)
        `ASSERT_EQ("Init x3 (-1)", dut.register_file.registers[3], 32'hFFFFFFFF)

        // Verif SLT (Signé) -> -5 < 3 est VRAI (1)
        `ASSERT_EQ("Test SLT Signe (x4 = 1)", dut.register_file.registers[4], 32'd1)

        // Verif SLTIU (Non-Signé Imm) -> 0xFFFFFFFF < 3 est FAUX (0)
        `ASSERT_EQ("Test SLTIU Non-Signe (x5 = 0)", dut.register_file.registers[5], 32'd0)

        // Verif SLTU (Non-Signé Reg) -> 0xFFFFFFFB < 3 est FAUX (0)
        `ASSERT_EQ("Test SLTU Non-Signe (x6 = 0)", dut.register_file.registers[6], 32'd0)

        // Si tout est bon
        $display("");
        $display("SUCCES : Groupe 3");
        $display("");
        
        $finish;
    end
      
    initial begin
        $dumpfile("top_tb_3.vcd");
        $dumpvars(0, top_tb_3);  
    end

endmodule