`include "definitions.vh"

module controller (
  	input i_clk,
  	input i_rst,
    input wire [`INST_WIDTH-1:0] i_inst,    
    output reg o_branch,
    output reg [1:0] o_result_mux,
    output reg [2:0] o_branch_op,
    output reg o_mem_write,
    output reg o_alu_src_a, // 1'b0 = REG_A, 1'b1 = PC
    output reg o_alu_src_b, // 1'b0 = REG_B, 1'b1 = IMME
    output reg o_reg_write,
  	output reg o_stall,
    output reg [5:0] o_alu_op  
);

    wire [`OPCODE-1:0] opcode = i_inst[`OPCODE-1:0];
    wire [`FUNCT_7-1:0] funct_7 = i_inst[`INST_WIDTH-1:`INST_WIDTH-`FUNCT_7];
    wire [2:0] funct_3 = i_inst[14:12];
  
      always @* begin
        o_branch = 0;
        o_result_mux = 2'b00;
        o_alu_op = `OP_ALU_ADD;
        o_branch_op = `BRANCH_BEQ;        
        o_alu_src_a = 0;
        o_alu_src_b = 0;
        
     
        case (opcode)
            `OP_LUI: begin  // LUI
                o_alu_src_b = 1; 
                o_reg_write = 1;
              	o_alu_op = `OP_LUI;
            end
            `OP_AUIPC: begin  // AUIPC
                o_alu_src_a = 1; 
                o_alu_src_b = 1;                 
            end
            `OP_JAL: begin  // JAL                
                o_branch = 1;
                o_result_mux = 2'b01;
                o_alu_src_a = 1; 
                o_alu_src_b = 1; 
                o_branch_op = `BRANCH_JAL_JALR;
            end
            `OP_JALR : begin  // JALR                
                o_branch = 1;
                o_result_mux = 2'b01;
                o_alu_src_b = 1; 
                o_branch_op = `BRANCH_JAL_JALR;
            end
            `OP_BRANCH: begin  // Branch Instructions
                o_branch = 1;
                o_alu_src_a = 1; 
                o_alu_src_b = 1; 
                case (funct_3)
                    `BRANCH_BEQ:    o_branch_op = `BRANCH_BEQ;
                    `BRANCH_BNE:    o_branch_op = `BRANCH_BNE;
                    `BRANCH_BLT:    o_branch_op = `BRANCH_BLT;
                    `BRANCH_BGE:    o_branch_op = `BRANCH_BGE;
                    `BRANCH_BLTU:   o_branch_op = `BRANCH_BLTU;
                    `BRANCH_BGEU:   o_branch_op = `BRANCH_BGEU;
                    default:        o_branch_op = `BRANCH_BEQ;
                endcase
            end
            `OP_LOAD: begin  // Load Instructions                
                o_result_mux = 2'b10;
                o_alu_src_b = 1; 
            end
            `OP_STORE: begin  // Store Instructions                
                o_alu_src_b = 1; 
            end
            `OP_ALU: begin  // ALU Instructions
                // Implement ADD, SUB, AND, OR, XOR, etc.                
                case (funct_3)
                    3'b000: begin
                        if (i_inst[30]) 
                            o_alu_op = `OP_ALU_SUB;
                        else 
                            o_alu_op = `OP_ALU_ADD;
                    end
                    3'b111:    o_alu_op = `OP_ALU_AND;
                    3'b110:     o_alu_op = `OP_ALU_OR;                    
                    3'b100:    o_alu_op = `OP_ALU_XOR;
                    3'b010:    o_alu_op = `OP_ALU_SLT;
                    3'b011:   o_alu_op = `OP_ALU_SLTU;
                    3'b001:    o_alu_op = `OP_ALU_SLL;                    
                    3'b101:  begin 
                        if(i_inst[30])
                            o_alu_op = `OP_ALU_SRA;
                        else
                            o_alu_op = `OP_ALU_SRL;
                    end
                    default:        o_alu_op = `OP_ALU_NOP;                    
                endcase
            end
            `OP_ALUI: begin // Implement ADDI, ANDI, ORI, XORI, etc.                
                //Take IMME. as a source
                o_alu_src_b = 1;                
                case (funct_3)
                    3'b000: o_alu_op = `OP_ALU_ADD;     // ADDI operation
                    3'b110: o_alu_op = `OP_ALU_OR;      // ORI operation
                    3'b111: o_alu_op = `OP_ALU_AND;     // ANDI operation
                    3'b100: o_alu_op = `OP_ALU_XOR;     // XORI operation
                    3'b001: o_alu_op = `OP_ALU_SLL;    	// SLLI operation
                    3'b010: o_alu_op = `OP_ALU_SLT;    	// SLTI operation
                    3'b011: o_alu_op = `OP_ALU_SLTU;	// SLTIU operation
                    3'b101: begin
                        if (i_inst[30])
                            o_alu_op = `OP_ALU_SRA;  	// SRAI
                        else
                            o_alu_op = `OP_ALU_SRL;  	// SRLI
                    end
                    default: o_alu_op = `OP_ALU_NOP;
                endcase
            end
            `OP_FENCE: begin
                if (funct_3 == 3'b001) 
                    o_alu_op = `OP_ALU_FENCEI;
                else 
                    o_alu_op = `OP_ALU_FENCEI; 
            end
            `OP_SYSTEM: begin 
                o_reg_write = 1'b0;
                o_mem_write = 1'b0;
                if (i_inst[20]) 
                    o_alu_op = `OP_ALU_EBREAK;
                else 
                    o_alu_op = `OP_ALU_ECALL;
            end
            default: begin
                // Unrecognized opcode
            end
        endcase
    end
    
    // State Machine
 	
  	localparam RESET= 3'b111;
    localparam IF	= 3'b000;
	localparam ID	= 3'b001;  
    localparam EX	= 3'b010;  
    localparam MEM	= 3'b011;   
    localparam WB 	= 3'b100; 
    
  	reg [2:0] current_state, next_state;
  
	always @(posedge i_clk or posedge i_rst) begin
    	if (i_rst)
            current_state <= RESET;
        else
            current_state <= next_state;
    end
    /*
        Opcode   | # of Cycles
        -----------------------
        LOAD     | 5
        STORE    | 4
        BRANCH   | 3
        ALU      | 3
        ALUI     | 3
        JAL      | 3
        JALR     | 3
        AUIPC    | 3
        LUI      | 3
    */
    always @(*) begin	      	
      	// Default Stall = 1
      	o_stall = 1'b1;      
      	o_mem_write = 1'b0;
      	o_reg_write = 1'b0;
      
      	case(current_state)          
          RESET: begin            
			next_state = IF;
          end
          IF: begin            
			next_state = ID;
          end
          ID: begin
            next_state = EX;
          end
          EX: begin // The Rest
            if (opcode == LOAD or opcode == STORE)
                next_state = MEM;
            else
                o_reg_write = 1;
                next_state = IF;
          end
          MEM: begin // STORE
            if (opcode == STORE)
                o_mem_write = 1;
                next_state = IF;
            else
                next_state = WB;
          end
          WB: begin // LOAD
            o_reg_write = 1;
            next_state = IF;
          end
			default: begin
				next_state = current_state;
			end
        endcase
    end
      
endmodule