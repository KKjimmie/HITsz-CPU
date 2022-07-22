// file: param.v
`ifndef CPU_PARAM
`define CPU_PARAM

    // syntax: `define <macro name> <parameter>
    // aluop
    `define ADD     'b000
    `define SUB     'b001
    `define AND     'b010
    `define OR      'b011
    `define XOR     'b100
    `define SLL     'b101
    `define SRL     'b110
    `define SRA     'b111
    
    // opcode
    `define R_op    'b0110011
    `define I_op    'b0010011
    `define lw_op   'b0000011
    `define jalr_op 'b1100111
    `define S_op    'b0100011
    `define B_op    'b1100011
    `define lui_op  'b0110111
    `define J_op    'b1101111

    // npc_op
    `define pc4     'b000
    `define pcImm   'b001
    `define Imm     'b010 
    `define Beq     'b011
    `define Bne     'b100
    `define Blt     'b101
    `define Bge     'b110

    // wb_sel
    `define wdPC4     'b00
    `define wdALUC    'b01
    `define wdDM      'b10
    `define wdImm     'b11

    // sext_op
    `define sext_R    'b000
    `define sext_I    'b001
    `define sext_IS   'b010
    `define sext_S    'b011
    `define sext_B    'b100
    `define sext_U    'b101
    `define sext_J    'b110
    
`endif

