
// pipeline registers -> Memory | WriteBack stage

module pl_reg_mw (
    input             clk,
    input             RegWriteM,
    input      [1:0]  ResultSrcM,
    input      [31:0] ALUResultM, WriteDataM, ReadDataM, PCM, lAuiPCM,
    input      [4:0]  RdM,
    input      [31:0] PCPlus4M,
    output reg        RegWriteW,
    output reg [1:0]  ResultSrcW,
    output reg [31:0] ALUResultW, WriteDataW, ReadDataW, PCW, lAuiPCW,
    output reg [4:0]  RdW,
    output reg [31:0] PCPlus4W
);

initial begin
    RegWriteW = 0;
    ResultSrcW = 0;
    ALUResultW = 0; WriteDataW = 0; ReadDataW = 0; PCW = 0; lAuiPCW = 0;
    RdW = 0;
    PCPlus4W = 0;
end

always @(posedge clk) begin
    RegWriteW <= RegWriteM;
    ResultSrcW <= ResultSrcM;
    ALUResultW <= ALUResultM; WriteDataW <= WriteDataM; ReadDataW <= ReadDataM; PCW <= PCM; lAuiPCW <= lAuiPCM;
    RdW <= RdM;
    PCPlus4W <= PCPlus4M;
end

endmodule
