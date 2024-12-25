
// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWriteM,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,
    output [ 2:0] funct3M,
    output [31:0] PCW, ALUResultW, WriteDataW
);

wire        ALUSrc, RegWrite, Branch, Jump, Jalr, MemWrite;
wire [1:0]  ResultSrc, ImmSrc;
wire [3:0]  ALUControl;
wire [31:0] InstrD;

controller  c   (InstrD[6:0], InstrD[14:12], InstrD[30],
                ResultSrc, MemWrite, ALUSrc,
                RegWrite, Branch, Jump, Jalr, ImmSrc, ALUControl);

datapath    dp  (clk, reset, ResultSrc,
                ALUSrc, RegWrite, MemWrite, ImmSrc, ALUControl, Branch, Jump, Jalr,
                PC, Instr, Mem_WrAddr, Mem_WrData, ReadData, Result, MemWriteM, PCW, ALUResultW, WriteDataW, InstrD);

// Eventually will be removed while adding pipeline registers
// assign funct3 = Instr[14:12];//check for InstrD here i don't know why

endmodule
