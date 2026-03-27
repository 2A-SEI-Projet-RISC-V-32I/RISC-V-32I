import definitions::*;

`default_nettype none
`timescale 1ns/1ns

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED at %2d in %m: signal != value", $time); \
            $finish; \
        end

module  branch_unit_tb;

  reg clk;
  reg i_branch = 1'b0;
  reg [2:0] i_branch_op = 3'b000;
  reg [DATA_WIDTH-1:0] i_a = 32'h00000000;
  reg [DATA_WIDTH-1:0] i_b = 32'h00000000;
  
  wire o_take;

  branch_unit dut (
    .i_branch(i_branch),
    .i_branch_op(i_branch_op),
    .i_a(i_a),
    .i_b(i_b),
    .o_take(o_take)
  );
  
  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
      i_a = 32'h00000000;
      i_b = 32'h00000000;
      i_branch = 1'b1;
      i_branch_op = BRANCH_BEQ;
    #10;
      `assert(dut.o_take, 1'b1);
      i_branch = 1'b1;
      i_branch_op = BRANCH_BNE;
    #10;
      `assert(dut.o_take, 1'b0);
      i_branch = 1'b1;
      i_branch_op = BRANCH_BNE;
      i_a = 32'h00000000;
      i_b = 32'h00000001;
    #10;
      `assert(dut.o_take, 1'b1);
      i_a = 32'h11111111;
      i_b = 32'h11111110;
      i_branch = 1'b1;
      i_branch_op = BRANCH_BLT;
    #10;
      `assert(dut.o_take, 1'b0);
      i_branch = 1'b1;
      i_branch_op = BRANCH_BGE;  
    #10;
      `assert(dut.o_take, 1'b1);
      i_branch = 1'b1;
      i_branch_op = BRANCH_BLTU;  
    #10;
      `assert(dut.o_take, 1'b0);
      i_branch = 1'b1;
      i_branch_op = BRANCH_BGEU; 
    #10;
      `assert(dut.o_take, 1'b1);
      i_branch = 1'b1;
      i_branch_op = BRANCH_JAL_JALR;  
    #10;
      `assert(dut.o_take, 1'b1);
      i_branch = 1'b0;
      i_branch_op = BRANCH_JAL_JALR;  
    #10;
      `assert(dut.o_take, 1'b0);
    $finish;

  end

  always @(posedge clk) begin 
  	$display("time %2t, i_branch = %b, i_branch_op = %3b, i_a = %8h, i_b = %8h, o_take = %b", $time, i_branch, i_branch_op, i_a, i_b, o_take);
  end 
  
  initial begin
    $dumpfile("branch_unit.vcd");
    $dumpvars;  
  end

endmodule
