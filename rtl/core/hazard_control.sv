module hazard_control (
    input logic [4:0] i_rs1_D, i_rs2_D, i_rd_E, i_rs1_E, i_rs2_E, i_rd_M, i_rd_W,
    input logic i_reg_we_M, i_reg_we_W, i_branch,
    input logic [1:0] i_result_mux_E,
    output logic o_stall_F, o_stall_D, // geler l'instruction
    output logic o_flush_D, o_flush_E, // eliminer l'instruction (avec NOP = une bulle)
    output logic [1:0] o_forward_1, o_forward_2
);

logic stall;

always_comb begin
    // Data hazards
    if (i_reg_we_M && (i_rs1_E != 0) && (i_rd_M == i_rs1_E)) begin
        o_forward_1 = 2'b10;
    end else if (i_reg_we_W && (i_rs1_E != 0) && (i_rd_W == i_rs1_E)) begin
            o_forward_1 = 2'b01;
        end else begin 
                o_forward_1 = 2'b00;
            end

    if (i_reg_we_M && (i_rs2_E != 0) && (i_rd_M == i_rs2_E)) begin
        o_forward_2 = 2'b10;
    end else if (i_reg_we_W && (i_rs2_E != 0) && (i_rd_W == i_rs2_E)) begin
            o_forward_2 = 2'b01;
        end else begin
                o_forward_2 = 2'b00;
            end

    // Control hazards
    if ((i_result_mux_E == 2'b10) && ((i_rs1_D == i_rd_E) || (i_rs2_D == i_rd_E))) begin
        stall = 1;
    end else begin
            stall = 0;
        end
    o_stall_F = stall;
    o_stall_D = stall;
    o_flush_D = i_branch;
    o_flush_E = stall | i_branch;
end

endmodule
