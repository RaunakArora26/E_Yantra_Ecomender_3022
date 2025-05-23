
// main_decoder.v - logic for main decoder

module main_decoder (
    input  [6:0] op,
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump, Jalr,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);



always @(*) begin
    casez (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_Jalr
        7'b0000011: controls = 12'b1_00_1_0_01_0_00_0_0; // lw
        7'b0100011: controls = 12'b0_01_1_1_00_0_00_0_0; // sw
        7'b0110011: controls = 12'b1_xx_0_0_00_0_10_0_0; // R–type
        7'b1100011: controls = 12'b0_10_0_0_00_1_01_0_0; // beq //blt //bnq //bge
        7'b0010011: controls = 12'b1_00_1_0_00_0_10_0_0; // I–type ALU
        7'b1101111: controls = 12'b1_11_0_0_10_0_00_1_0; // jal
        7'b1100111: controls = 12'b1_00_1_0_10_0_00_0_1; // Jalr //so ImmSrc=00 (I type),resultSrc=1(rd=PC+4),ALUOP=00(Add)
        7'b0?10111: controls = 12'b1_xx_x_0_11_0_xx_0_0; // lui or auipc
        default:    controls = 12'bx_xx_x_x_xx_x_xx_x_x; // ???
    endcase
end

assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = controls;

endmodule

