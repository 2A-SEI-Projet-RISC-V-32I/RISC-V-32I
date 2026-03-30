module top_tb;
    reg clk;
    reg rst;

    wire wr_en_M;
    wire [2:0] funct_3_M;
    wire [31:0] rs2_E;
    wire [31:0] o_alu_E;
    wire [31:0] o_data;
    wire [31:0] o_pc;
    wire [31:0] inst;

    processor dut (
        .clk(clk),
        .rst(rst),
        .wr_en_M (wr_en_M),
    	.funct_3_M (funct_3_M),
    	.rs2_E (rs2_E),
    	.o_alu_E_top (o_alu_E),
    	.i_data_mem (o_data),
    	.o_pc_top (o_pc),
    	.i_inst_mem (inst)
    );

    data_mem data_mem(
	.i_clk (clk),
    	.i_we (wr_en_M),
    	.i_func3 (funct_3_M),
    	.i_data (rs2_E),
    	.i_addr (o_alu_E[11:0]),
    	.o_data (o_data)
    );

    inst_mem inst_mem(
	.clk (clk),
    	.addr (o_pc[11:2]),
    	.inst (inst)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        
        #20 rst = 0;


        #10000; 
        $display("Timeout : Le programme est trop long ou bloqué !");
        $finish;
    end
      
    initial begin
        $dumpfile("top_processor.vcd");
        $dumpvars;  
    end

endmodule

