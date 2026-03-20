`include "definitions.vh"

module decoder (    
    // INPUT
    input wire [`INST_WIDTH-1:0] i_inst,
    // OUTPUT
    output wire [`OPCODE-1:0] o_opcode,
    output reg o_branch,
    output reg [1:0] o_result_mux,  // ALU = 2'b00, PC+4 = 2'b01, DATA_MEM = 2'b10
    output reg [2:0] o_branch_op,
    output reg o_mem_write,
    output reg o_alu_src_a,         // 1'b0 = REG_A, 1'b1 = PC
    output reg o_alu_src_b,         // 1'b0 = REG_B, 1'b1 = IMME
    output reg o_reg_write,    
    output reg [5:0] o_alu_op,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rs1_addr,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rs2_addr,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rd_addr    
);

wire [`OPCODE-1:0] opcode = i_inst[`OPCODE-1:0];
wire [`FUNCT_7-1:0] funct_7 = i_inst[`INST_WIDTH-1:`INST_WIDTH-`FUNCT_7];
wire [2:0] funct_3 = i_inst[14:12];

assign o_opcode = opcode;
assign o_rd_addr = i_inst[11:7];
    //LUI is (rd <= imm20 << 12), which is the same as (rd <= x0 + imm20 << 12)
assign o_rs1_addr = `OP_LUI == opcode ? 5'b00000 : i_inst[19:15];
assign o_rs2_addr = i_inst[24:20];

always @* begin
    o_branch = 0;
    o_result_mux = 2'b00;
    o_alu_op = `OP_ALU_ADD;
    o_branch_op = `BRANCH_BEQ;
    o_mem_write = 0;
    o_alu_src_a = 0;
    o_alu_src_b = 0;
    o_reg_write = 0;
        
    case (opcode)
        `OP_LUI: begin // LUI
            o_alu_src_b = 1; 
            o_reg_write = 1;
        end
        `OP_AUIPC: begin // AUIPC
            o_alu_src_a = 1; 
            o_alu_src_b = 1; 
            o_reg_write = 1;
        end
        `OP_JAL: begin      // JAL
            o_reg_write = 1;
            o_branch = 1;
            o_result_mux = 2'b01;
            o_alu_src_a = 1; 
            o_alu_src_b = 1; 
            o_branch_op = `BRANCH_JAL_JALR;
        end
        `OP_JALR : begin // JALR
            o_reg_write = 1;
            o_branch = 1;
            o_result_mux = 2'b01;
            o_alu_src_b = 1; 
            o_branch_op = `BRANCH_JAL_JALR;
        end
        `OP_BRANCH: begin // Branch Instructions
            o_branch = 1;
            o_reg_write = 0;
            o_alu_src_a = 0;
            o_alu_src_b = 0;
            case (funct_3)
                3'b000 : o_branch_op = `BRANCH_BEQ;
                3'b001 : o_branch_op = `BRANCH_BNE;
                3'b100 : o_branch_op = `BRANCH_BLT;
                3'b101 : o_branch_op = `BRANCH_BGE;
                3'b110 : o_branch_op = `BRANCH_BLTU;
                3'b111 : o_branch_op = `BRANCH_BGEU;
            endcase
        end
        `OP_LOAD: begin // Load Instructions
            o_reg_write = 1;
            o_alu_src_b = 1;
            o_result_mux = 2'b10;
            case (funct_3)
                3'b000: o_alu_op = `OP_ALU_LB;  // Load Byte
                3'b001: o_alu_op = `OP_ALU_LH;  // Load Half
                3'b010: o_alu_op = `OP_ALU_LW;  // Load Word
                3'b100: o_alu_op = `OP_ALU_LBU; // Load Byte Unsigned
                3'b101: o_alu_op = `OP_ALU_LHU; // Load Half Unsigned
                default: o_alu_op = `OP_ALU_LW;
            endcase
        end
        `OP_STORE: begin // Store Instructions
            o_reg_write = 0;
            o_mem_write = 1;
            o_alu_src_b = 1;
            case (funct_3)
                3'b000: o_alu_op = `OP_ALU_SB; // Store Byte
                3'b001: o_alu_op = `OP_ALU_SH; // Store Half
                3'b010: o_alu_op = `OP_ALU_SW; // Store Word
                default: o_alu_op = `OP_ALU_SW;
            endcase
        end
        `OP_ALU: begin // ALU Instructions
            o_reg_write = 1;
            case (funct_3)
                3'b000: begin
                    if (i_inst[30]) 
                        o_alu_op = `OP_ALU_SUB;
                    else 
                        o_alu_op = `OP_ALU_ADD;
                end
                3'b111: o_alu_op = `OP_ALU_AND;
                3'b110: o_alu_op = `OP_ALU_OR;                    
                3'b100: o_alu_op = `OP_ALU_XOR;
                3'b010: o_alu_op = `OP_ALU_SLT;
                3'b011: o_alu_op = `OP_ALU_SLTU;
                3'b001: o_alu_op = `OP_ALU_SLL;                    
                3'b101: begin 
                        if(i_inst[30])
                            o_alu_op = `OP_ALU_SRA;
                        else
                            o_alu_op = `OP_ALU_SRL;
                end
                default: o_alu_op = `OP_ALU_NOP;
            endcase
        end
        `OP_ALUI: begin	// Implement ADDI, ANDI, ORI, XORI, etc.
            o_reg_write = 1;
            o_alu_src_b = 1; // Utilise l'immédiat
            case (funct_3)
                3'b000: o_alu_op = `OP_ALU_ADD;
                3'b111: o_alu_op = `OP_ALU_AND;
                3'b110: o_alu_op = `OP_ALU_OR;
                3'b100: o_alu_op = `OP_ALU_XOR;
                3'b010: o_alu_op = `OP_ALU_SLT; 
                3'b011: o_alu_op = `OP_ALU_SLTU;
                3'b001: o_alu_op = `OP_ALU_SLL; 
                3'b101: begin 
                        if(i_inst[30])
                            o_alu_op = `OP_ALU_SRA;
                        else
                            o_alu_op = `OP_ALU_SRL;
                end
                default: o_alu_op = `OP_ALU_NOP;
            endcase
        end
        default: begin
                // Unrecognized opcode; no action taken
        end
    endcase
end

endmodule