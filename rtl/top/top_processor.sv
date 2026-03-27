module processor (
    input logic clk,
    input logic rst
);

logic [31:0] o_pc;
logic [31:0] next_pc;
logic [31:0] o_pc_F, o_pc_D, o_pc_E, o_pc_M;
logic [31:0] inst;
logic [31:0] o_inst_F, o_instr_D, o_instr_E, o_instr_M;
logic [6:0] opcode
logic reg_we_W, reg_we_;
logic [31:0] rs1, rs2;
logic [31:0]
logic [31:0]
logic [31:0]
logic [31:0]
logic [31:0]

// a definir
    .i_rd (rd),
    .i_rd_addr (rd_addr),
    .i_rs1_addr (rs1_addr),
    .i_rs2_addr (rs2_addr),

pc pc (
    .clk (clk),
    .rst (rst),
    .i_pc (next_pc),
    .o_pc (o_pc),
);

pc_buffer pc_buffer_fetch (
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc),
    .o_pc (o_pc_F),
);

pc_buffer pc_buffer_decode (
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_F),
    .o_pc (o_pc_D),
);

pc_buffer pc_buffer_execute (
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_D),
    .o_pc (o_pc_E),
);

pc_buffer pc_buffer_memory (
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_E),
    .o_pc (o_pc_M),
);

/*pc_mux pc_mux_fetch (
      .pc_out(pc_out),
      .alu_result(alu_buffer_execute_out),
      .br_true(br_true),
      .jump_en(jump_enE),
      .epc_taken(epc_taken),
      .epc(epc),
      .next_pc(next_pc)
  );*/

inst_mem inst_mem(
    .clk (clk),
    .addr(pc_out),
    .data(inst)
);

im_buffer im_buffer_fetch(
    .clk (clk),
    .rst (rst),
    .i_instr (inst),
    .o_instr (o_inst_F)
);

im_buffer im_buffer_decode(
    .clk (clk),
    .rst (rst),
    .i_instr (o_inst_F),
    .o_instr (o_inst_D)
);

im_buffer im_buffer_execute(
    .clk (clk),
    .rst (rst),
    .i_instr (o_inst_D),
    .o_instr (o_inst_E)
);

im_buffer im_buffer_memory(
    .clk (clk),
    .rst (rst),
    .i_instr (o_inst_E),
    .o_instr (o_inst_M)
);

register_file register_file(
    .i_clk (clk),
    .i_rst (rst),
    .i_we (reg_we_W),
    .i_rd (rd),
    .i_rd_addr (rd_addr),
    .i_rs1_addr (rs1_addr),
    .i_rs2_addr (rs2_addr),
    .o_rs1 (rs1),
    .o_rs2 (rs2),
)

controller controller(
    .i_inst (),
    .o_opcode (opcode),
    .o_branch (),
    .o_result_mux (),
    .o_branch_op (),
    .o_mem_write (),
    .o_alu_src_a (),
    .o_alu_src_b (),
    .o_reg_write (),    
    .o_alu_op (),
    .o_funct_3 (),
    .o_rs1_addr (),
    .o_rs2_addr (),
    .o_rd_addr ()
)

endmodule