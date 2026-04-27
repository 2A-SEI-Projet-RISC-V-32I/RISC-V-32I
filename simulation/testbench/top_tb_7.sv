module top_tb_7;

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

        $readmemh("programs/bin/inst_gr_7.hex", inst_mem.mem);

        clk = 0;
        rst = 1;
        
        #20 rst = 0;

        #300; 


        $display("GROUPE 7");

        // ALU-ALU
        `ASSERT_EQ("Test Init x1", dut.register_file.registers[1], 32'd15)
        `ASSERT_EQ("Test Init x2", dut.register_file.registers[2], 32'd25)
        `ASSERT_EQ("Test Forward ADD (x3 = 40)", dut.register_file.registers[3], 32'd40)
        `ASSERT_EQ("Test Forward SUB (x4 = 25)", dut.register_file.registers[4], 32'd25)

        // ALU-Memory
        // Si x7 vaut 99, cela prouve que le Store a bien recu l'adresse 8 (via x5)
        // et la donnee 99 (via x6) directement depuis l'ALU sans attendre !
        `ASSERT_EQ("Test Forward STORE (Lu via LW dans x7)", dut.register_file.registers[7], 32'd99)

        // Si tout est bon
        $display("");
        $display("SUCCES : Groupe 7");
        $display("");
        
        $finish;
    end
      
    initial begin
        $dumpfile("top_tb_7.vcd");
        $dumpvars(0, top_tb_7);  
    end

endmodule