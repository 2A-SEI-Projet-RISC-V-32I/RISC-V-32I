import definitions::*;

module controller_buffer_ex (
    input wire clk,
    input wire rst,

    input wire [1:0] i_result_mux,
    input wire i_mem_write,
    input wire i_reg_write,    
    input wire [2:0] i_funct_3,
    input wire [$clog2(NUM_REGISTER) - 1: 0] i_rd_addr,
    
    output logic [1:0] o_result_mux,
    output logic o_mem_write,
    output logic o_reg_write,    
    output logic [2:0] o_funct_3,
    output logic [$clog2(NUM_REGISTER) - 1: 0] o_rd_addr    
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        o_result_mux <= '0;
        o_mem_write  <= 1'b0; 
        o_reg_write  <= 1'b0;
        o_funct_3    <= '0;
        o_rd_addr    <= '0;
    end 
    else begin
        o_result_mux <= i_result_mux;
        o_mem_write  <= i_mem_write;
        o_reg_write  <= i_reg_write;
        o_funct_3    <= i_funct_3;
        o_rd_addr    <= i_rd_addr;
    end
end

endmodule
