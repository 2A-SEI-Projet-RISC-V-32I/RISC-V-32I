module top_tb_5;

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

        $readmemh("programs/bin/inst_gr_5.hex", inst_mem.mem);

        clk = 0;
        rst = 1;
        
        #20 rst = 0;

        #400; 


        $display("GROUPE 5");

        // BEQ
        // Si x5 == 99, c'est que le BEQ n'a pas sauté.
        // Si x5 == 1, le BEQ a sauté à l'adresse exacte !
        `ASSERT_EQ("Test BEQ : x5 doit valoir 1", dut.register_file.registers[5], 32'd1)

        // BLT
        `ASSERT_EQ("Test BLT : x6 doit valoir 1", dut.register_file.registers[6], 32'd1)

        // BGEU
        `ASSERT_EQ("Test BGEU : x7 doit valoir 1", dut.register_file.registers[7], 32'd1)

        // Si tout est bon
        $display("");
        $display("SUCCES : Groupe 5");
        $display("");
        
        $finish;
    end
      
    initial begin
        $dumpfile("top_tb_5.vcd");
        $dumpvars(0, top_tb_5);  
    end

endmodule