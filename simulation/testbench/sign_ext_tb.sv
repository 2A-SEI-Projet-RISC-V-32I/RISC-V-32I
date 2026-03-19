`default_nettype none
`timescale 1ns/1ns

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED at %2d in %m: signal != value", $time); \
            $finish; \
        end

module sign_extension_tb;

  reg clk;
  reg [`INST_WIDTH-1:0] inst = 32'h00000000;
  reg [`OPCODE-1:0] opcode = `OP_ALUI;
  wire [`INST_WIDTH-1:0] immediate_extended;

  sign_extension dut (
    .i_inst(inst),
    .i_opcode(opcode),    
    .o_immediate_extended(immediate_extended)
  );

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;
  
  initial begin
      inst = 32'h80000000;
      opcode = `OP_ALUI;
    #10;
      `assert(dut.o_immediate_extended, 32'hfffff800);
      inst = 32'h10100000;
      opcode = `OP_LOAD;
    #10;
      `assert(dut.o_immediate_extended, 32'h00000101);
      inst = 32'h80F80023;
      opcode = `OP_STORE;
    #10;
      `assert(dut.o_immediate_extended, 32'hfffff800);
      inst = 32'h00F80023;
      opcode = `OP_STORE;
    #10;
      `assert(dut.o_immediate_extended, 32'h00000000);
      inst = 32'h000170b7;
      opcode = `OP_LUI;
    #10;
      `assert(dut.o_immediate_extended, 32'h00017000);
      inst = 32'h000170b7;
      opcode = `OP_AUIPC;
    #10;        
      `assert(dut.o_immediate_extended, 32'h00017000);
      inst = 32'h0e80026f;
      opcode = `OP_JAL;
    #10;
      `assert(dut.o_immediate_extended, 32'h000000e8);
      inst = 32'hf19ff26f;
      opcode = `OP_JAL;
    #10;
      `assert(dut.o_immediate_extended, 32'hffffff18);
      inst = 32'h00c00167;
      opcode = `OP_JALR;
    #10;
      `assert(dut.o_immediate_extended, 32'h0000000c);
      inst = 32'hfe4104e3;
      opcode = `OP_BRANCH;
    #10;
      `assert(dut.o_immediate_extended, 32'hffffffe8);
    $finish;

  end

  always @(posedge clk) begin 
    $display("time %2t, inst = %8h, opcode = %7b, inst = %8h", $time, inst, opcode, immediate_extended);
  end 
  
  initial begin
    $dumpfile("sign_extension.vcd");
    $dumpvars;  
  end

endmodule