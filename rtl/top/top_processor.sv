module processor (
    input logic clk,
    input logic rst,

    //data mem
    output logic wr_en_M,
    output logic [2:0] funct_3_M,
    output logic [31:0] rs2_M,
    output logic [31:0] o_alu_E_top,
    input logic [31:0] i_data_mem,

    //inst mem
    output logic [31:0] o_pc_top,
    input logic [31:0] i_inst_mem
);

logic [31:0] o_pc;
logic [31:0] next_pc;
logic [31:0] o_pc_W, o_pc_D, o_pc_E, o_pc_M;
logic [31:0] o_inst_W, o_inst_D, o_inst_E, o_inst_M;
logic [6:0] opcode;
logic [31:0] rs1, rs2, rs1_E, rs2_E;
logic [4:0] rs1_addr, rs2_addr, rd_addr, rd_addr_D, rd_addr_E, rd_addr_M;
logic [31:0] o_sign_ext, o_sign_ext_E;
logic [5:0] alu_op_E, alu_op_D;
logic [31:0] o_alu, o_alu_W, o_alu_M;
logic [31:0] o_data_W;
logic [1:0] wb_sel_W, wb_sel_E, wb_sel_M, wb_sel_D;
logic [31:0] o_wb;
logic sel_B_E, sel_A_E, sel_A_D, sel_B_D;
logic br, branch_E, o_branch; 
logic [2:0] branch_type_E, branch_type;
logic [2:0] funct_3_D, funct_3_E;
logic reg_we_W, reg_we_M, reg_we_D, reg_we_E;
logic wr_en_D, wr_en_E;
logic [31:0] o_mux_alu_A, o_mux_alu_B;
logic [4:0]  wb_rd_addr;

assign o_pc_top    = o_pc;
assign o_alu_E_top = o_alu_M;

pc pc(
    .clk (clk),
    .rst (rst),
    .i_pc (next_pc),
    .o_pc (o_pc)
);

pc_buffer pc_buffer_FD(
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc),
    .o_pc (o_pc_D)
);

pc_buffer pc_buffer_DE(
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_D),
    .o_pc (o_pc_E)
);

pc_buffer pc_buffer_EM(
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_E),
    .o_pc (o_pc_M)
);

pc_buffer pc_buffer_MW(
    .clk (clk),
    .rst (rst),
    .i_pc (o_pc_M),
    .o_pc (o_pc_W)
);

pc_mux pc_mux(
    .i_alu_out (o_alu_E),
    .i_pc_out (o_pc),
    .br_true (o_branch),
    .o_data (next_pc)
);

im_buffer im_buffer_FD(
    .clk (clk),
    .rst (rst),
    .i_instr (i_inst_mem),
    .o_instr (o_inst_D)
);

im_buffer im_buffer_DE(
    .clk (clk),
    .rst (rst),
    .i_instr (o_inst_D),
    .o_instr (o_inst_E)
);

im_buffer im_buffer_EM(
    .clk (clk),
    .rst (rst),
    .i_instr (o_inst_E),
    .o_instr (o_inst_M)
);

im_buffer im_buffer_MW(
    .clk (clk),
    .rst (rst),
    .i_instr (o_inst_M),
    .o_instr (o_inst_W)
);

sign_ext sign_ext(
    .i_inst (o_inst_D),
    .i_opcode (opcode),
    .o_immediate_extended (o_sign_ext)
);

sign_ext_buffer sign_ext_buffer(
    .clk (clk),
    .rst (rst),
    .i_immediate (o_sign_ext),
    .o_immediate (o_sign_ext_E)
);

register_file register_file(
    .i_clk (clk),
    .i_rst (rst),
    .i_we (reg_we_W),
    .i_rd (o_wb),
    .i_rd_addr (o_inst_W[11:7]),
    .i_rs1_addr (rs1_addr),
    .i_rs2_addr (rs2_addr),
    .o_rs1 (rs1),
    .o_rs2 (rs2)
);

rs_buffer rs1_buffer_DE(
    .clk (clk),
    .rst (rst),
    .i_rs (rs1),
    .o_rs (rs1_E)
);

rs_buffer rs2_buffer_DE(
    .clk (clk),
    .rst (rst),
    .i_rs (rs2),
    .o_rs (rs2_E)
);

branch branch(
    .i_branch (branch_E),
    .i_branch_op (branch_type_E),
    .i_a (rs1_E),
    .i_b (rs2_E),
    .o_take (o_branch)
);

alu_mux alu_mux_A_pc(
    .i_data_1 (o_pc_E),
    .i_data_2 (rs1_E),
    .i_sel (sel_A_E),
    .o_data (o_mux_alu_A)
);

alu_mux alu_mux_B_imm(
    .i_data_2 (rs2_E),
    .i_data_1 (o_sign_ext_E),
    .i_sel (sel_B_E),
    .o_data (o_mux_alu_B)
);

alu alu(
    .i_alu_op (alu_op_E),
    .i_a (o_mux_alu_A),
    .i_b (o_mux_alu_B),
    .o_c (o_alu)
);

alu_buffer alu_buffer_EM(
    .clk (clk),
    .rst (rst),
    .i_addr (o_alu),
    .o_addr (o_alu_M)
);

alu_buffer alu_buffer_MW(
    .clk (clk),
    .rst (rst),
    .i_addr (o_alu_M),
    .o_addr (o_alu_W)
);

wd_buffer wd_buffer_EM(
    .clk (clk),
    .rst (rst),
    .i_data (rs2_E),
    .o_data (rs2_M)
);


rd_buffer rd_buffer_MW(
    .clk (clk),
    .rst (rst),
    .i_data (i_data_mem),   
    .o_data (o_data_W)
);

wb_mux wb_mux(
    .pc (o_pc_W),
    .i_data_0 (o_alu_W),
    .i_data_1 (o_data_W),
    .wb_sel (wb_sel_W),
    .o_data (o_wb)
);

controller controller (
    .i_inst(o_inst_D),
    .o_opcode(opcode),
    .o_branch(br),
    .o_result_mux(wb_sel_D),
    .o_branch_op(branch_type),
    .o_mem_write(wr_en_D),
    .o_alu_src_a(sel_A_D),
    .o_alu_src_b(sel_B_D),
    .o_reg_write(reg_we_D),
    .o_alu_op(alu_op_D),
    .o_funct_3(funct_3_D),
    .o_rs1_addr(rs1_addr),
    .o_rs2_addr(rs2_addr)
    //.o_rd_addr(rd_addr_D)
);

controller_buffer_dec controller_buffer_DE (
    .clk(clk),
    .rst(rst),
    .i_branch(br),
    .i_result_mux(wb_sel_D),
    .i_branch_op(branch_type),
    .i_mem_write(wr_en_D),
    .i_alu_src_a(sel_A_D),
    .i_alu_src_b(sel_B_D),
    .i_reg_write(reg_we_D),
    .i_alu_op(alu_op_D),
    .i_funct_3(funct_3_D),
    //.i_rd_addr(rd_addr_D),
    .o_branch(branch_E),
    .o_result_mux(wb_sel_E),
    .o_branch_op(branch_type_E),
    .o_mem_write(wr_en_E),
    .o_alu_src_a(sel_A_E), 
    .o_alu_src_b(sel_B_E), 
    .o_reg_write(reg_we_E),    
    .o_alu_op(alu_op_E),
    .o_funct_3(funct_3_E)
    //.o_rd_addr(rd_addr_E)    
);

controller_buffer_ex controller_buffer_EM (
    .clk(clk),
    .rst(rst),
    .i_result_mux(wb_sel_E),
    .i_mem_write(wr_en_E),
    .i_reg_write(reg_we_E),    
    .i_funct_3(funct_3_E),
    //.i_rd_addr(rd_addr_E),
    .o_result_mux(wb_sel_M),
    .o_mem_write(wr_en_M),
    .o_reg_write(reg_we_M),    
    .o_funct_3(funct_3_M)
    //.o_rd_addr(rd_addr_M) 
);

controller_buffer_mem controller_buffer_MW (
    .clk(clk),
    .rst(rst),
    .i_result_mux(wb_sel_M),
    .i_reg_write(reg_we_M),    
    //.i_rd_addr(rd_addr_M),
    .o_result_mux(wb_sel_W),
    .o_reg_write(reg_we_W)    
    //.o_rd_addr(wb_rd_addr)    
);

endmodule
