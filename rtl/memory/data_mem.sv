import definitions::*;

module data_memory #(
    parameter MEM_SIZE = 4096 
) (
    input wire i_clk,
    input wire i_we,
    input wire [2:0] i_func3, 
    input wire [DATA_WIDTH-1:0] i_data,
    input wire [$clog2(MEM_SIZE)-1:0] i_addr,
    output logic [DATA_WIDTH-1:0] o_data 
);
    
    reg [7:0] memory [0:MEM_SIZE-1];
    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            memory[i] = 8'h00;
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_we) begin
            case (i_func3)
                SB: begin
                    memory[i_addr] <= i_data[7:0];
                end
                
                SH: begin
                    memory[i_addr]   <= i_data[7:0];
                    memory[i_addr+1] <= i_data[15:8];
                end
                
                SW: begin
                    memory[i_addr]   <= i_data[7:0];
                    memory[i_addr+1] <= i_data[15:8];
                    memory[i_addr+2] <= i_data[23:16];
                    memory[i_addr+3] <= i_data[31:24];
                end
            endcase
        end
    end

    always @(*) begin

        o_data = 32'b0;

        case (i_func3)
            LB: begin
                o_data = { {24{memory[i_addr][7]}}, memory[i_addr] }; 
            end
            
            LH: begin
                o_data = { {16{memory[i_addr+1][7]}}, memory[i_addr+1], memory[i_addr] };
            end
            
            LW: begin
                o_data = { memory[i_addr+3], memory[i_addr+2], memory[i_addr+1], memory[i_addr] }; 
            end
            
            LBU: begin
                o_data = { 24'b0, memory[i_addr] };
            end
            
            LHU: begin
                o_data = { 16'b0, memory[i_addr+1], memory[i_addr] };
            end
        endcase
    end
endmodule
