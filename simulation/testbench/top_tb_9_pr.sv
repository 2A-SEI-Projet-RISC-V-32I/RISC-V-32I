`timescale 1ns / 1ps

module top_tb_9_pr;

    `define ASSERT_EQ(name, signal, expected) \
        if ((signal) !== (expected)) begin \
            $display("========================================"); \
            $display("[ASSERTION FAILED] %s", name); \
            $display("   Temps   : %0t", $time); \
            $display("   Attendu : %0d (0x%h)", expected, expected); \
            $display("   Obtenu  : %0d (0x%h)", signal, signal); \
            $display("========================================"); \
            $stop; \
        end else begin \
            $display("[OK] %s", name); \
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

    always #25 clk = ~clk;

    initial begin
        $sdf_annotate("asic/par/Innovus/RESULTS/design.sdf", dut);
        $display("SDF Annotation terminée.");
    end

    initial begin
        $readmemh("programs/bin/inst_gr_9_pr.hex", inst_mem.mem);

        clk = 0;
        rst = 1;
        
        #50 rst = 0;

        #100000; 

        $display("--- DEBUT DES VERIFICATIONS POST-ROUTAGE ---");

        `ASSERT_EQ("Test Ultime Fibonacci (a = 5 à l'index 1)", data_mem.memory[1], 32'd5)

        $display("");
        $display("STRESS TEST PASSED");
        $display("");
        
        $stop;
    end
      
    initial begin
        $dumpfile("top_tb_9_pr.vcd");
        $dumpvars(0, top_tb_9_pr);  
    end

endmodule