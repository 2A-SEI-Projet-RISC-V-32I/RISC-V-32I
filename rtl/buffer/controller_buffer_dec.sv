import definitions::*;

module controller_buffer_dec (
    input wire clk,
    input wire rst,
    input wire i_clr,

    input wire i_branch,
    input wire [1:0] i_result_mux,
    input wire [2:0] i_branch_op,
    input wire i_mem_write,
    input wire i_alu_src_a, 
    input wire i_alu_src_b, 
    input wire i_reg_write,    
    input wire [5:0] i_alu_op,
    input wire [2:0] i_funct_3,
    //input wire [$clog2(NUM_REGISTER) - 1: 0] i_rd_addr,
    
    output logic o_branch,
    output logic [1:0] o_result_mux,
    output logic [2:0] o_branch_op,
    output logic o_mem_write,
    output logic o_alu_src_a, 
    output logic o_alu_src_b, 
    output logic o_reg_write,    
    output logic [5:0] o_alu_op,
    output logic [2:0] o_funct_3
    //output logic [$clog2(NUM_REGISTER) - 1: 0] o_rd_addr    
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        o_branch <= 1'b0;
        o_result_mux <= '0;
        o_branch_op <= '0;
        o_mem_write <= 1'b0; 
        o_alu_src_a <= 1'b0;
        o_alu_src_b <= 1'b0;
        o_reg_write <= 1'b0;
        o_alu_op <= '0;
        o_funct_3 <= '0;
        //o_rd_addr <= '0;
    end else begin
        if (i_clr) begin
            o_branch <= 1'b0;
            o_reg_write <= 1'b0; // Empêche d'écrire dans le banc de registres
            o_mem_write <= 1'b0; // Empêche d'écrire dans la RAM
            o_result_mux <= '0;
            o_branch_op <= '0;
            o_alu_src_a <= 1'b0;
            o_alu_src_b <= 1'b0;
            o_alu_op <= '0;
            o_funct_3 <= '0;
        end else begin
            o_branch <= i_branch;
            o_result_mux <= i_result_mux;
            o_branch_op <= i_branch_op;
            o_mem_write <= i_mem_write;
            o_alu_src_a <= i_alu_src_a;
            o_alu_src_b <= i_alu_src_b;
            o_reg_write <= i_reg_write;
            o_alu_op <= i_alu_op;
            o_funct_3 <= i_funct_3;
            //o_rd_addr <= i_rd_addr;
        end
    end
end

endmodule
