
// pipeline registers -> execute | Memory stage

module pl_reg_em (
    input             clk,
    input             RegWriteE, MemWriteE,
    input      [1:0]  ResultSrcE,
    input      [31:0] ALUResultE, WriteDataE, PCE, lAuiPCE,
    input      [4:0]  RdE,
    input      [31:0] PCPlus4E,
    input      [2:0]  funct3E,
    output reg        RegWriteM, MemWriteM,
    output reg [1:0]  ResultSrcM,
    output reg [31:0] ALUResultM, WriteDataM, PCM, lAuiPCM,
    output reg [4:0]  RdM,
    output reg [2:0]  funct3M,
    output reg [31:0] PCPlus4M
);

initial begin
    RegWriteM = 0; MemWriteM = 0;
    ResultSrcM = 0;
    ALUResultM = 0; WriteDataM = 0; PCM = 0; lAuiPCM = 0;
    RdM = 0;
    PCPlus4M = 0;
    funct3M = 0;
end

always @(posedge clk) begin
    RegWriteM <= RegWriteE; MemWriteM <= MemWriteE; funct3M <= funct3E;
    ResultSrcM <= ResultSrcE;
    ALUResultM <= ALUResultE; WriteDataM <= WriteDataE; PCM <= PCE; lAuiPCM <= lAuiPCE;
    RdM <= RdE;
    PCPlus4M <= PCPlus4E;
end

endmodule
