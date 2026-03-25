`default_nettype none
`timescale 1ns/1ns

// Définitions des fonctions
`define LB  3'b000 
`define LH  3'b001 
`define LW  3'b010 
`define LBU 3'b100 
`define LHU 3'b101 
`define SB  3'b000 
`define SH  3'b001 
`define SW  3'b010 

`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED at %0t: Expected %b, Got %b", $time, value, signal); \
        $finish; \
    end

module dat_memory_tb;

    localparam MEM_SIZE = 4096;
    localparam DATA_WIDTH = 32;

    reg clk;
    reg we;
    reg [2:0] func;
    reg [DATA_WIDTH-1:0] i_data;
    reg [11:0] addr; // 12 bits pour 4096 cases
    
    wire [DATA_WIDTH-1:0] o_data;

    data_memory #( .MEM_SIZE(MEM_SIZE) ) dut (
        .i_clk(clk), .i_we(we), .i_func(func), .i_addr(addr), .i_data(i_data), .o_data(o_data)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;
    
    initial begin
        // --- INITIALISATION ---
        we = 1'b0; func = `LW; addr = 12'b0; i_data = 32'b0;

        // --- ÉTAPE 1 : ÉCRITURE DU MOT COMPLET (SW) ---
        // 0x8A4B_C2F1
        #10;
        we = 1'b1;
        addr = 12'h004; 
        i_data = 32'b10001010_01001011_11000010_11110001; 
        func = `SW;
        
        #10;
        we = 1'b0;

        // --- ÉTAPE 2 : TESTS DE LECTURE OCTETS (LB / LBU) ---
        $display("Testing Byte Loads...");

        // LB (Sign-Extended) sur l'octet 0 (11110001 -> bit 7 est 1)
        addr = 12'h004; func = `LB; #1;
        `assert(o_data, 32'b11111111_11111111_11111111_11110001); 

        // LBU (Zero-Extended) sur l'octet 0
        func = `LBU; #1;
        `assert(o_data, 32'b00000000_00000000_00000000_11110001);

        // LB (Sign-Extended) sur l'octet 2 (01001011 -> bit 7 est 0)
        addr = 12'h006; func = `LB; #1;
        `assert(o_data, 32'b00000000_00000000_00000000_01001011);

        // --- ÉTAPE 3 : TESTS DE LECTURE DEMI-MOTS (LH / LHU) ---
        $display("Testing Half-word Loads...");

        // Test LH sur octets 1:0 (11000010_11110001 -> bit 15 est 1)
        addr = 12'h004; func = `LH; #1;
        `assert(o_data, 32'b11111111_11111111_11000010_11110001);

        // Test LHU sur octets 1:0
        func = `LHU; #1;
        `assert(o_data, 32'b00000000_00000000_11000010_11110001);

        // --- ÉTAPE 4 : TEST DE LECTURE MOT COMPLET (LW) ---
        $display("Testing Word Load...");
        addr = 12'h004; func = `LW; #1;
        `assert(o_data, 32'b10001010_01001011_11000010_11110001);

        // --- ÉTAPE 5 : TEST D'ÉCRITURE PARTIELLE (SB) ---
        // On cible l'octet 1 (adresse 0x005) qui vaut 11000010 (C2)
        // On veut le remplacer par 00000000 (00)
        $display("Testing Store Byte...");
        we = 1'b1;
        addr = 12'h005; 
        i_data = 32'b00000000_00000000_00000000_00000000; 
        func = `SB;
        #10;
        we = 1'b0;

        // On relit le mot complet à l'adresse 0x004 pour voir le changement
        func = `LW;
        addr = 12'h004;
        #1;
        // Le C2 doit être devenu 00. 
        // Attendu: 10001010_01001011_00000000_11110001 (8A4B00F1)
        `assert(o_data, 32'b10001010_01001011_00000000_11110001);

        $display("--- ALL TESTS PASSED SUCCESSFULLY ---");
        $finish;
    end

    always @(posedge clk) begin 
        $display("T=%2t | Addr=%h | Out=%b", $time, addr, o_data);
    end 
endmodule