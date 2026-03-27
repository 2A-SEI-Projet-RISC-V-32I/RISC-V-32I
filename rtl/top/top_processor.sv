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
logic reg_we_W, wr_en_M, sel_B_E, sel_A_E;
logic [31:0] rs1, rs2, rs1_D, rs2_D;
logic [4:0] rs1_addr, rs2_addr, rd_addr;
logic [31:0] o_sign_ext, o_sign_ext_D;
logic [5:0] alu_op_E;
logic [31:0] o_alu, o_alu_E;
logic [31:0] o_data;
logic [1:0] wb_sel_W;
logic [31:0] o_wb;

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

pc_mux pc_mux(
    .i_alu_out (o_alu_E),
    .i_pc_out (o_pc),
    .br_true (o_branch),
    .o_data (next_pc)
);

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
    .o_immediate_extended (o_sign_ext)
);

sign_ext_buffer sign_ext_buffer(
    .clk (clk),
    .rst (rst),
    .i_immediate (o_sign_ext),
    .o_immediate (o_sign_ext_D)
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

branch branch(
    .i_branch (), // A compléter
    .i_branch_op (),
    .i_a (rs1_D),
    .i_b (rs2_D),
    .o_take (o_branch)
);

alu_mux alu_mux_A_pc(
    .i_data_1 (o_pc_D),
    .i_data_2 (rs1_D),
    .i_sel (sel_A_E),
    .o_data (o_mux_alu_A)
);

alu_mux alu_mux_B_imm(
    .i_data_2 (rs2_D),
    .i_data_1 (o_sign_ext_D),
    .i_sel (sel_B_E),
    .o_data (o_mux_alu_B)
);

alu alu(
    .i_alu_op (alu_opE),
    .i_a (o_mux_alu_A),
    .i_b (o_mux_alu_B),
    .o_c (o_alu)
);

alu_buffer alu_buffer_execute(
    .clk (clk),
    .rst (rst),
    .i_addr (o_alu),
    .o_addr (o_alu_E)
);

alu_buffer alu_buffer_memory(
    .clk (clk),
    .rst (rst),
    .i_addr (o_alu_E),
    .o_addr (o_alu_M)
);

wd_buffer wd_buffer_execute(
    .clk (clk),
    .rst (rst),
    .i_data (rs2_D),
    .o_data (rs2_E)
);

data_mem data_mem(
    .i_clk (clk),
    .i_we (wr_en_M),
    .i_func3 (), // A COMPLETER
    .i_data (rs2_E),
    .i_addr (o_alu_E[11:0]),
    .o_data (o_data) 
);

rd_buffer rd_buffer_memory(
    .clk (clk),
    .rst (rst),
    .i_data (o_data),   
    .o_data (o_data_M)
)

wb_mux wb_mux(
    .pc (o_pc_M),
    .i_data_0 (o_alu_M),
    .i_data_1 (o_data_M),
    .wb_sel (wb_sel_W),
    .o_data (o_wb)
)

// ETAGE DECODE (ID)

    wire [6:0]  id_opcode;
    wire        id_branch;
    wire [1:0]  id_result_mux;
    wire [2:0]  id_branch_op;
    wire        id_mem_write;
    wire        id_alu_src_a;
    wire        id_alu_src_b;
    wire        id_reg_write;
    wire [5:0]  id_alu_op;
    wire [2:0]  id_funct_3;
    wire [4:0]  id_rs1_addr;
    wire [4:0]  id_rs2_addr;
    wire [4:0]  id_rd_addr;

    controller controller (
        .i_inst(id_inst),
        .o_opcode(id_opcode),
        .o_branch(id_branch),
        .o_result_mux(id_result_mux),
        .o_branch_op(id_branch_op),
        .o_mem_write(id_mem_write),
        .o_alu_src_a(id_alu_src_a),
        .o_alu_src_b(id_alu_src_b),
        .o_reg_write(id_reg_write),
        .o_alu_op(id_alu_op),
        .o_funct_3(id_funct_3),
        .o_rs1_addr(id_rs1_addr),
        .o_rs2_addr(id_rs2_addr),
        .o_rd_addr(id_rd_addr)
    );

  
    // Buffer de decode vers execute (D/E)


    // Déclaration des signaux qui sortent dans l'étage execute
    wire        ex_branch;
    wire [1:0]  ex_result_mux;
    wire [2:0]  ex_branch_op;
    wire        ex_mem_write;
    wire        ex_alu_src_a;
    wire        ex_alu_src_b;
    wire        ex_reg_write;
    wire [5:0]  ex_alu_op;
    wire [2:0]  ex_funct_3;
    wire [4:0]  ex_rd_addr;

    controller_buffer_dec controller_buffer_dec (
        .clk(clk),
        .rst(rst),
        
        // Entrées (venant de ID)
        .i_branch(id_branch),
        .i_result_mux(id_result_mux),
        .i_branch_op(id_branch_op),
        .i_mem_write(id_mem_write),
        .i_alu_src_a(id_alu_src_a),
        .i_alu_src_b(id_alu_src_b),
        .i_reg_write(id_reg_write),
        .i_alu_op(id_alu_op),
        .i_funct_3(id_funct_3),
        .i_rd_addr(id_rd_addr),

        // Sorties (allant vers EX)
        .o_branch(ex_branch),
        .o_result_mux(ex_result_mux),
        .o_branch_op(ex_branch_op),
        .o_mem_write(ex_mem_write),
        .o_alu_src_a(ex_alu_src_a), 
        .o_alu_src_b(ex_alu_src_b), 
        .o_reg_write(ex_reg_write),    
        .o_alu_op(ex_alu_op),
        .o_funct_3(ex_funct_3),
        .o_rd_addr(ex_rd_addr)    
    );

    // Buffer de execute vers memory (E/M)

    // Déclaration des signaux qui sortent dans l'étage mem
    wire [1:0]  mem_result_mux;
    wire        mem_mem_write;
    wire        mem_reg_write;
    wire [2:0]  mem_funct_3;
    wire [4:0]  mem_rd_addr;

    controller_buffer_ex controller_buffer_ex (
        .clk(clk),
        .rst(rst),

        // Entrées (venant de EX)
        .i_result_mux(ex_result_mux),
        .i_mem_write(ex_mem_write),
        .i_reg_write(ex_reg_write),    
        .i_funct_3(ex_funct_3),
        .i_rd_addr(ex_rd_addr),
        
        // Sorties (allant vers MEM)
        .o_result_mux(mem_result_mux),
        .o_mem_write(mem_mem_write),
        .o_reg_write(mem_reg_write),    
        .o_funct_3(mem_funct_3),
        .o_rd_addr(mem_rd_addr) 
    );

    // Buffer de memory vers write-back (M/W)

    // Déclaration des signaux qui sortent dans l'étage WRITE-BACK
    wire [1:0]  wb_result_mux;
    wire        wb_reg_write;
    wire [4:0]  wb_rd_addr;

    controller_buffer_mem controller_buffer_mem (
        .clk(clk),
        .rst(rst),

        // Entrées (venant de MEM)
        .i_result_mux(mem_result_mux),
        .i_reg_write(mem_reg_write),    
        .i_rd_addr(mem_rd_addr),
        
        // Sorties (allant vers WB)
        .o_result_mux(wb_result_mux),
        .o_reg_write(wb_reg_write),    
        .o_rd_addr(wb_rd_addr)    
    );



endmodule