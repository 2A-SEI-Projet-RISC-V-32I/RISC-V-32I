`default_nettype none
`timescale 1ns/1ns

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED at %2d in %m: signal != value", $time); \
            $finish; \
        end

module  alu_tb;

  reg clk;
  reg [5:0] i_alu_op = 5'b00000;
  reg [`DATA_WIDTH-1:0] i_a = 32'h00000000;
  reg [`DATA_WIDTH-1:0] i_b = 32'h00000000;
  
  wire [`DATA_WIDTH-1:0] o_c;

  alu dut (
    .i_alu_op(i_alu_op),
    .i_a(i_a),
    .i_b(i_b),
    .o_c(o_c)
  );
  
  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
        i_a = 32'h00000001;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_ADD;
      #10;
        `assert(dut.o_c, 32'h00000002);
        i_a = 32'h00000001;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_SUB;
      #10;
        `assert(dut.o_c, 32'h00000000);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_AND;
      #10;
        `assert(dut.o_c, 32'h00000001);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_OR;
      #10;
        `assert(dut.o_c, 32'h00010101);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_XOR;
      #10;
        `assert(dut.o_c, 32'h00010100);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_SLT;
      #10;
        `assert(dut.o_c, 32'h00000001);
        i_a = 32'h00010001;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_SLTU;
      #10;
        `assert(dut.o_c, 32'h00000000);
        i_a = 32'h00000001;
        i_b = 32'h00000010;
        i_alu_op = `OP_ALU_SLL;
      #10;
        `assert(dut.o_c, 32'h00010000);
        i_a = 32'h00000001;
        i_b = 32'h00000021; // 33 en décimal (32 + 1)
        i_alu_op = `OP_ALU_SLL;
      #10;
       `assert(o_c, 32'h00000002);
    
    // Test équivalent pour le décalage à droite (SRL)
   
        i_a = 32'h00000004;
        i_b = 32'h00000022; // 34 en décimal
        i_alu_op = `OP_ALU_SRL;
      
        #10;
       `assert(o_c, 32'h00000001);

        i_a = 32'h00000100;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_SRL;
      #10;
        `assert(dut.o_c, 32'h00000080);
        i_a = 32'hfffffff0;
        i_b = 32'h00000003;
        i_alu_op = `OP_ALU_SRA;
      #10;
        `assert(dut.o_c, 32'hfffffffe);
         i_a = 32'h80000000;
         i_b = 32'h0000001f;
         i_alu_op = `OP_ALU_SRA;
       #10;
        `assert(dut.o_c, 32'hffffffff);
   
    $finish;

  end

  always @(posedge clk) begin 
    $display("time %2t, i_alu_op = %5b, i_a = %8h, i_b = %8h, o_c = %8h", $time, i_alu_op, i_a, i_b, o_c);
  end 
  
  initial begin
    $dumpfile("alu.vcd");
    $dumpvars;  
  end

endmodule