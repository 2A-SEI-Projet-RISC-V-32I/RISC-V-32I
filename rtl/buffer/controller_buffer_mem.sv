`include "../core/definitions.vh"

module controller_buffer_mem (
    input wire clk,
    input wire rst,

    input wire [`OPCODE-1:0] i_opcode,
    input wire [1:0] i_result_mux,
    input wire i_reg_write,    
    input wire [$clog2(`NUM_REGISTER) - 1: 0] i_rd_addr,
    
    output logic [`OPCODE-1:0] o_opcode,
    output logic [1:0] o_result_mux,
    output logic o_reg_write,    
    output logic [$clog2(`NUM_REGISTER) - 1: 0] o_rd_addr    
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        o_opcode     <= '0;
        o_result_mux <= '0;
        o_reg_write  <= 1'b0;
        o_rd_addr    <= '0;
    end 
    else begin
        o_opcode     <= i_opcode;
        o_result_mux <= i_result_mux;
        o_reg_write  <= i_reg_write;
        o_rd_addr    <= i_rd_addr;
    end
end

endmodule