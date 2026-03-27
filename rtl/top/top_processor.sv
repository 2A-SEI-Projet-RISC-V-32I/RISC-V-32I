module processor (
    input logic clk,
    input logic rst
);

logic [31:0] o_pc;
logic [31:0] next_pc;
logic [31:0] o_pc_F, o_pc_D, o_pc_E, o_pc_M;
logic [31:0] inst;
logic [31:0] o_inst_F, o_instr_D, o_instr_E, o_instr_M;
logic [6:0] opcode, rd;
logic reg_we_W, reg_we_;
logic [31:0] rs1, rs2, rs1_D, rs2_D;
logic [4:0] rs1_addr, rs2_addr, rd_addr;
logic [31:0] 
logic [31:0]
logic [31:0]
logic [31:0]

pc pc(
    .clk (clk),
    .rst (rst),
    .i_pc (next_pc),
    .o_pc (o_pc),
);

pc_buffer pc_buffer_fetch(
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc),
    .o_pc (o_pc_F),
);

pc_buffer pc_buffer_decode(
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_F),
    .o_pc (o_pc_D),
);

pc_buffer pc_buffer_execute(
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_D),
    .o_pc (o_pc_E),
);

pc_buffer pc_buffer_memory(
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
    .addr(pc_out[11:2]),
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

sign_ext sign_ext(
    .i_inst (inst),
    .i_opcode (opcode),
    .o_immediate_extended (o_sign_ext_D)
);

sign_ext_buffer sign_ext_buffer(

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
);

rs_buffer rs1_buffer_decode(
    .clk (clk),
    .rst (rst),
    .i_rs (rs1),
    .o_rs (rs1_D)
);

rs_buffer rs2_buffer_decode(
    .clk (clk),
    .rst (rst),
    .i_rs (rs2),
    .o_rs (rs2_D)
);

alu_mux alu_mux_A(
    .i_data_1 (o_pc_D),
    .i_data_2 (rs1_D),
    .i_sel (sel_AE),
    .o_data (o_mux_alu_A)
);

alu_mux alu_mux_B_imm(
    .i_data_2 (rs2_D),
    .i_data_1 (o_sign_ext_D),
    .i_sel (sel_BE),
    .o_data (o_mux_alu_B)
  );

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
);



endmodule