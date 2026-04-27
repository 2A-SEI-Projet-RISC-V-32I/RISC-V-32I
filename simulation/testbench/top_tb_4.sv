module top_tb_4;

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

        $readmemh("programs/bin/inst_gr_4.hex", inst_mem.mem);

        clk = 0;
        rst = 1;
        
        #20 rst = 0;

        #450; 


        $display("GROUPE 4");

        // SW / LW
        `ASSERT_EQ("Test LW (x3 = -500)", dut.register_file.registers[3], 32'hFFFFFE0C)

        // SH / LH / LHU
        `ASSERT_EQ("Test LH Signe (x5 = -2)", dut.register_file.registers[5], 32'hFFFFFFFE)
        `ASSERT_EQ("Test LHU Non-Signe (x6 = 65534)", dut.register_file.registers[6], 32'h0000FFFE)

        // SB / LB / LBU
        `ASSERT_EQ("Test LB Signe (x8 = -5)", dut.register_file.registers[8], 32'hFFFFFFFB)
        `ASSERT_EQ("Test LBU Non-Signe (x9 = 251)", dut.register_file.registers[9], 32'h000000FB)

        // Si tout est bon
        $display("");
        $display("SUCCES : Groupe 4 ");
        $display("");
        
        $finish;
    end
      
    initial begin
        $dumpfile("top_tb_4.vcd");
        $dumpvars(0, top_tb_4);  
    end

endmodule