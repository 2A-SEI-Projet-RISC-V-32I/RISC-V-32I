`default_nettype none
`timescale 1ns/1ns

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED at %2d in %m: signal != value", $time); \
            $finish; \
        end

module register_file_tb;

  reg clk;
  reg rst;
  reg we;
  reg [$clog2(`NUM_REGISTER)-1:0] rd_addr = 32'h00000000;
  reg [`DATA_WIDTH-1:0] rd = 32'h00000000;

  reg [$clog2(`NUM_REGISTER)-1:0] rs1_addr = 32'h00000000;
  reg [$clog2(`NUM_REGISTER)-1:0] rs2_addr = 32'h00000000;

  wire [`DATA_WIDTH-1:0] rs1;
  wire [`DATA_WIDTH-1:0] rs2;

  register_file dut (
    .i_clk(clk),
    .i_rst(rst),
    .i_we(we),
    .i_rd_addr(rd_addr),
    .i_rd(rd),
    .i_rs1_addr(rs1_addr),
    .i_rs2_addr(rs2_addr),
    .o_rs1(rs1),
    .o_rs2(rs2)
  );

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;
  
  initial begin

    rst = 1'b1; 

    #15; 

    rst = 1'b0;

    #5;
        we = 1'b0;
        rst = 1'b0;
        rs1_addr = 5'b00000;
        rs2_addr = 5'b00000;
    #10;
        `assert(dut.o_rs1, 32'h00000000);
        `assert(dut.o_rs2, 32'h00000000);
        rs1_addr = 5'b00001;
        rs2_addr = 5'b00010;
    #10;
        `assert(dut.o_rs1, 32'h00000000);
        `assert(dut.o_rs2, 32'h00000000);
        rs1_addr = 5'b11111;
        rs2_addr = 5'b00000;
        we = 1'b1;
        rd_addr = 5'b11111;
        rd = 32'hffffffff;
    #10;
        `assert(dut.o_rs1, 32'hffffffff);
        `assert(dut.o_rs2, 32'h00000000);
        rs1_addr = 5'b11111;
        rs2_addr = 5'b00000;
        we = 1'b1;
        rd_addr = 5'b0000;
    #10;
        `assert(dut.o_rs1, 32'hffffffff);
        `assert(dut.o_rs2, 32'h00000000);
        we = 1'b0;
    #10;
    $display("Test fini");
    $finish;

  end

  always @(posedge clk) begin 
    $display("time %2t, clk = %b, rst = %b, we = %b, rd_addr = %5b, rd = %8h, rs1_addr = %5b, rs2_addr = %5b, rs1 = %8h, rs2 = %8h", $time, clk, rst, we, rd_addr, rd, rs1_addr, rs2_addr, rs1, rs2);
  end 
  
  initial begin
    $dumpfile("register_file.vcd");
    $dumpvars;  
  end

endmodule