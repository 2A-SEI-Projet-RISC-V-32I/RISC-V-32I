import definitions::*;

module inst_mem #(
    parameter MEM_SIZE = 1024 
) (
    
    input wire clk,
    // L'adresse arrive sur 10 bits (log2(1024)) mais ca veut dire que les 32 bits du pc 
    //doivent etre transformé en 10 avant le bloc d'instruction memoire
    input wire [$clog2(MEM_SIZE)-1:0] addr, 
    // OUTPUT
    output reg [INST_WIDTH-1:0] inst
);

    reg [INST_WIDTH-1:0] mem [0:MEM_SIZE-1];

    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            mem[i] = 32'h00000000;
        end

    // Pour le top_tb (à commenter ou non en fonction)

        //$readmemh("programs/bin/simple.hex", mem);

    // Pour le inst_mem_tb (à commenter ou non en fonction)

    mem[0] = 32'h00a00293;
    mem[1] = 32'h01400313;
    mem[2] = 32'h00400493;
    mem[3] = 32'h00000013;
    mem[4] = 32'h00000013;
    mem[5] = 32'h00000013;
    mem[6] = 32'h00000013;
    mem[7] = 32'h006283b3;
    mem[8] = 32'h00000013;
    mem[9] = 32'h00000013;
    mem[10] = 32'h00000013;
    mem[11] = 32'h40530433;
    mem[12] = 32'h00000013;
    mem[13] = 32'h00000013;
    mem[14] = 32'h0074a023;
    mem[15] = 32'h00000013;
    mem[16] = 32'h00000013;
    mem[17] = 32'h0004a503;


    end

    always_comb begin
        inst = mem[addr];
    end

endmodule
