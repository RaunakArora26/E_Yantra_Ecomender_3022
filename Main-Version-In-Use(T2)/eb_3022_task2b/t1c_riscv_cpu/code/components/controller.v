
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero,
    input        ALU_31,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump, Jalr,
    output [1:0] ImmSrc,
    output [3:0] ALUControl
);

wire [1:0] ALUOp;
wire       Branch;

main_decoder    md (op, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, Jalr, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

// for jump and branch
assign PCSrc = Jump | (Branch & (
                   (funct3 == 3'b000 &&  Zero)  |             //beq
                   (funct3 == 3'b001 && ~Zero)  |             //bnq
                   (funct3 == 3'b100 && (ALU_31 && ~Zero)) |  //blt
                   (funct3 == 3'b101 && ~ALU_31  | Zero) |    //bge
                   (funct3 == 3'b110 && ALU_31)  |            //bltu  
                   (funct3 == 3'b111 && (~ALU_31 | Zero))     //bgeu
                 ));

endmodule

