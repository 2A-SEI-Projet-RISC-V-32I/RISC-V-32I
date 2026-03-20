module load_data_align (
    input wire [31:0] i_mem_data,  
    input wire [3:0]  i_be,         
    input wire        i_unsigned,   
    output reg [31:0] o_aligned_data 
);

    always_comb begin
        case (i_be)
            // OCTET (LB / LBU)

            4'b0001: o_aligned_data = i_unsigned ? {24'b0, i_mem_data[7:0]}   : {{24{i_mem_data[7]}},  i_mem_data[7:0]};
            4'b0010: o_aligned_data = i_unsigned ? {24'b0, i_mem_data[15:8]}  : {{24{i_mem_data[15]}}, i_mem_data[15:8]};
            4'b0100: o_aligned_data = i_unsigned ? {24'b0, i_mem_data[23:16]} : {{24{i_mem_data[23]}}, i_mem_data[23:16]};
            4'b1000: o_aligned_data = i_unsigned ? {24'b0, i_mem_data[31:24]} : {{24{i_mem_data[31]}}, i_mem_data[31:24]};

            // 2 OCTETS - Half Word (LH / LHU)

            4'b0011: o_aligned_data = i_unsigned ? {16'b0, i_mem_data[15:0]}  : {{16{i_mem_data[15]}}, i_mem_data[15:0]};
            4'b1100: o_aligned_data = i_unsigned ? {16'b0, i_mem_data[31:16]} : {{16{i_mem_data[31]}}, i_mem_data[31:16]};

            // 4 OCTETS - Word (LW)

            4'b1111: o_aligned_data = i_mem_data;

            default: o_aligned_data = 32'b0; 
        endcase
    end
endmodule