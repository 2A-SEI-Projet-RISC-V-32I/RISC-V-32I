package definitions;

// Width definitions
localparam int DATA_WIDTH = 32;   // Data width in bits
localparam int ADDR_WIDTH = 32;   // Address width in bits
localparam int INST_WIDTH = 32;
localparam int NUM_REGISTER = 32;
localparam int FUNCT_7 = 7;
localparam int OPCODE = 7;

    typedef enum logic [6:0] {
        OP_LUI    = 7'b0110111,
        OP_AUIPC  = 7'b0010111,
        OP_JAL    = 7'b1101111,
        OP_JALR   = 7'b1100111,
        OP_BRANCH = 7'b1100011,
        OP_LOAD   = 7'b0000011,
        OP_STORE  = 7'b0100011,
        OP_ALU    = 7'b0110011,
        OP_ALUI   = 7'b0010011,
        OP_FENCE  = 7'b0001111,
        OP_SYSTEM = 7'b1110011
    } opcode_t;


    typedef enum logic [2:0] {
        LB  = 3'b000,
        LH  = 3'b001,
        LW  = 3'b010,
        LBU = 3'b100,
        LHU = 3'b101
    } load_funct3_t;

    typedef enum logic [2:0] {
        SB = 3'b000,
        SH = 3'b001,
        SW = 3'b010
    } store_funct3_t;

    typedef enum logic [5:0] {
        OP_ALU_NOP    = 6'b000000,
        OP_ALU_ADD    = 6'b011001,
        OP_ALU_SUB    = 6'b011011,
        OP_ALU_AND    = 6'b011101,
        OP_ALU_OR     = 6'b011111,
        OP_ALU_XOR    = 6'b100001,
        OP_ALU_SLT    = 6'b100011,
        OP_ALU_SLTU   = 6'b100101,
        OP_ALU_SLL    = 6'b100111,
        OP_ALU_SRL    = 6'b101001,
        OP_ALU_SRA    = 6'b101011,
        OP_ALU_ECALL  = 6'b111000,
        OP_ALU_EBREAK = 6'b111001,
        OP_ALU_FENCE  = 6'b111010,
        OP_ALU_FENCEI = 6'b111011
    } alu_op_t;

    typedef enum logic [2:0] {
        BRANCH_BEQ  = 3'b000,
        BRANCH_BNE  = 3'b001,
        BRANCH_BLT  = 3'b100,
        BRANCH_BGE  = 3'b101,
        BRANCH_BLTU = 3'b110,
        BRANCH_BGEU = 3'b111,
        BRANCH_JAL_JALR = 3'b010
    } branch_t;

endpackage
