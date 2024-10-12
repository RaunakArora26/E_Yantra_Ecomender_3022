
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,
    input         Jalr,
    output        Zero,
    output        ALU_31,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

wire [31:0] PCNext,PCNextJalrmux, PCPlus4, PCTarget;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult,addAuiPc,lAuiPcResult;

// next PC logic
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
mux2 #(32)     jalrmux(PCNext,ALUResult,Jalr,PCNextJalrmux);//jalr

reset_ff #(32) pcreg(clk, reset, PCNextJalrmux, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);

// register file logic
reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
imm_extend     ext (Instr[31:7], ImmSrc, ImmExt);


// ALU logic
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero , ALU_31);
//aui & luipc
adder   auipcadder({Instr[31:12],12'b0},PC,addAuiPc);
mux2 #(32)     lauipcMux(addAuiPc, {Instr[31:12],12'b0}, Instr[5], lAuiPcResult);


//Result source 
mux4 #(32)     resultmux(ALUResult, ReadData, PCPlus4, lAuiPcResult, ResultSrc, Result);

assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

endmodule

