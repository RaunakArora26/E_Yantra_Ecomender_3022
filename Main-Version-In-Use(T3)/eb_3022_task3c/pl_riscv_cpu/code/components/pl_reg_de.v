// pipeline registers -> decode | execute stage

module pl_reg_de (
    input             clk, clr,
    input             RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, JalrD,
    input      [1:0]  ResultSrcD,
    input      [3:0]  ALUControlD,
    input      [31:0] RD1D, RD2D, PCD,
    input      [2:0]  funct3D,
    input      [4:0]  Rs1D, Rs2D, RdD,
    input      [31:0] ImmExtD, PCPlus4D,
    input      [19:0] auiInstrD,
    input             auiInstrD5,
    output reg        RegWriteE , MemWriteE, JumpE, BranchE, ALUSrcE, JalrE,
    output reg [1:0]  ResultSrcE,
    output reg [3:0]  ALUControlE,
    output reg [31:0] RD1E, RD2E, PCE, 
    output reg [2:0]  funct3E,
    output reg [4:0]  Rs1E, Rs2E, RdE,
    output reg [31:0] ImmExtE, PCPlus4E,
    output reg [19:0] auiInstrE,
    output reg        auiInstrE5
);

initial begin
    RegWriteE = 0; MemWriteE = 0; JumpE = 0; BranchE = 0; ALUSrcE = 0; JalrE = 0; auiInstrE = 0; auiInstrE5 = 0;
    ResultSrcE = 0;
    ALUControlE = 0;
    RD1E= 0; RD2E= 0; PCE = 0; funct3E = 0; Rs1E = 0; Rs2E = 0; RdE = 0;
    ImmExtE = 0; PCPlus4E = 0;
end

always @(posedge clk) begin
    if (clr) begin
        RegWriteE <= 0; MemWriteE <= 0; JumpE <= 0; BranchE <= 0; ALUSrcE <= 0; JalrE <= 0; auiInstrE <= 0; auiInstrE5 <= 0;
        ResultSrcE <= 0; Rs1E <= 0; Rs2E <= 0; RdE <= 0;
        ALUControlE <= 0;
        RD1E<= 0; RD2E<= 0; PCE <= 0; funct3E <= 0; 
        ImmExtE <= 0; PCPlus4E <= 0;
    end else begin
        RegWriteE <= RegWriteD; MemWriteE <= MemWriteD; JumpE <= JumpD; BranchE <= BranchD; ALUSrcE <= ALUSrcD; funct3E <= funct3D; JalrE <= JalrD;
        ResultSrcE <= ResultSrcD; auiInstrE <= auiInstrD; auiInstrE5 <= auiInstrD5;
        ALUControlE <= ALUControlD; Rs1E <= Rs1D; Rs2E <= Rs2D; RdE <= RdD;
        RD1E<= RD1D; RD2E<= RD2D; PCE <= PCD; 
        ImmExtE <= ImmExtD; PCPlus4E <= PCPlus4D;
    end
end

endmodule
