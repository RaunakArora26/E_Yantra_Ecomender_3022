
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrcD,
    input         ALUSrcD, RegWriteD, MemWriteD,
    input [1:0]   ImmSrcD,
    input [3:0]   ALUControlD,
    input         BranchD, JumpD, JalrD,
    output [31:0] PCF,
    input  [31:0] InstrF,
    output [31:0] Mem_WrAddr, Mem_WrData,//change ALUResultE to ALUResultM & writedata to writedataM  Status = 'X'
    input  [31:0] ReadDataM,
    output [31:0] ResultW,
    output        MemWriteM,
    output [31:0] PCW, ALUResultW, WriteDataW,
    output [31:0] InstrD,
    output [2:0]  funct3M
);

wire [31:0] PCF_, PCJalr, PCPlus4F, PCTargetE, AuiPC, lAuiPC, PCD, PCPlus4D, lAuiPCM,lAuiPCW;
wire [31:0] ImmExtD, RD1D, RD2D, ALUResultE, RD1E, RD2E, PCE, ImmExtE, PCPlus4E, ALUResultM, SrcAE, WriteDataE, SrcBE, WriteDataM, PCM, PCPlus4M, ReadDataW, PCPlus4W;
wire ZeroE, TakeBranch, RegWriteW, RegWriteE, MemWriteE, JumpE, JalrE, BranchE, ALUSrcE, RegWriteM, auiInstrE5;
wire [4:0] RdW, RdE, RdM, Rs1E, Rs2E;
wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW;
wire [3:0] ALUControlE;
wire [2:0]  funct3E;
wire [19:0] auiInstrE;

// wire PCSrcE = JumpE || (BranchE && ZeroE) || Jalr;
wire PCSrcE = ((BranchE && TakeBranch) || JumpE || JalrE) ;//???? Status = 'X'

// next PCF logic
mux2 #(32)     pcmux(PCPlus4F, PCTargetE, PCSrcE, PCF_);
mux2 #(32)     jalrmux (PCF_, ALUResultE, JalrE, PCJalr);//what to do??? Status = 'X'

// stallF - should be wired from hazard unit
wire StallF;// remove it after adding hazard unit.
reset_ff #(32) pcreg(clk, reset, StallF, PCJalr, PCF);
adder          pcadd4(PCF, 32'd4, PCPlus4F);

// Pipeline Register 1 -> Fetch | Decode

wire StallD;
wire FlushD;// remove it after adding hazard unit
// FlushD - should be wired from hazard unit
pl_reg_fd plfd (clk, StallD, FlushD, InstrF, PCF, PCPlus4F,
              InstrD, PCD, PCPlus4D);
// wire [31:0] InstrD;// PCD, PCPlus4D;
// adder          pcaddbranch(PCF, ImmExtD, PCTarget);

// register file logic
reg_file       rf (clk, RegWriteW, InstrD[19:15], InstrD[24:20], RdW, ResultW, RD1D, RD2D);//InstrF[11:7] = RdW, 
imm_extend     ext (InstrD[31:7], ImmSrcD, ImmExtD);

// Pipeline Register 2 -> Decode | Execute
wire FlushE;
pl_reg_de plde(
    .clk         ( clk         ),
    .clr         ( FlushE      ),
    .RegWriteD   ( RegWriteD   ),
    .MemWriteD   ( MemWriteD   ),
    .JumpD       ( JumpD       ),
    .BranchD     ( BranchD     ),
    .ALUSrcD     ( ALUSrcD     ),
    .ResultSrcD  ( ResultSrcD  ),
    .ALUControlD ( ALUControlD ),
    .RD1D        ( RD1D        ),
    .RD2D        ( RD2D        ),
    .PCD         ( PCD         ),
    .Rs1D        ( InstrD[19:15]),
    .Rs2D        ( InstrD[24:20]),
    .RdD         ( InstrD[11:7]),
    .ImmExtD     ( ImmExtD     ),
    .PCPlus4D    ( PCPlus4D    ),
    .RegWriteE   ( RegWriteE   ),
    .MemWriteE   ( MemWriteE   ),
    .JumpE       ( JumpE       ),
    .BranchE     ( BranchE     ),
    .ALUSrcE     ( ALUSrcE     ),
    .ResultSrcE  ( ResultSrcE  ),
    .ALUControlE ( ALUControlE ),
    .RD1E        ( RD1E        ),
    .RD2E        ( RD2E        ),
    .PCE         ( PCE         ),
    .Rs1E        ( Rs1E        ), 
    .Rs2E        ( Rs2E        ),
    .RdE         ( RdE         ),
    .ImmExtE     ( ImmExtE     ),
    .PCPlus4E    ( PCPlus4E    ),
    .funct3D     ( InstrD[14:12]),
    .funct3E     ( funct3E     ),
    .JalrE       ( JalrE       ),
    .JalrD       ( JalrD       ),
    .auiInstrD   ( InstrD[31:12]),
    .auiInstrE   ( auiInstrE   ),
    .auiInstrD5  ( InstrD[5]   ),
    .auiInstrE5  ( auiInstrE5  )
);


// ALU logic
wire [1:0] ForwardAE;// hazard unit then remove
wire [1:0] ForwardBE;// hazard unit then remove
mux4 #(32)    forwardAmux(RD1E, ResultW, ALUResultM, 0, ForwardAE, SrcAE);
mux4 #(32)    forwardBmux(RD2E, ResultW, ALUResultM, 0, ForwardBE, WriteDataE);

mux2 #(32)     srcbmux(WriteDataE, ImmExtE, ALUSrcE, SrcBE);
alu            alu (SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE);
adder #(32)    pcaddbranch (PCE, ImmExtE, PCTargetE);

adder #(32)    auipcadder ({auiInstrE, 12'b0}, PCE, AuiPC);
mux2 #(32)     lauipcmux (AuiPC, {auiInstrE, 12'b0}, auiInstrE5, lAuiPC);

branching_unit bu (funct3E, ZeroE, ALUResultE[31], TakeBranch);//check Status = 'X'//very  much an issue right now 

// Pipeline Register 3 -> Execute | Memory
pl_reg_em plem(
    .clk        ( clk        ),
    .RegWriteE  ( RegWriteE  ),
    .MemWriteE  ( MemWriteE  ),
    .ResultSrcE ( ResultSrcE ),
    .ALUResultE ( ALUResultE ),
    .WriteDataE ( WriteDataE ),
    .PCE        ( PCE        ),
    .RdE        ( RdE        ),
    .PCPlus4E   ( PCPlus4E   ),
    .RegWriteM  ( RegWriteM  ),
    .MemWriteM  ( MemWriteM  ),//output
    .ResultSrcM ( ResultSrcM ),
    .ALUResultM ( ALUResultM ),
    .WriteDataM ( WriteDataM ),
    .PCM        ( PCM        ),
    .RdM        ( RdM        ),
    .PCPlus4M   ( PCPlus4M   ),
    .lAuiPCE    ( lAuiPC     ),
    .lAuiPCM    ( lAuiPCM    ),
    .funct3E    ( funct3E    ),
    .funct3M    ( funct3M    )
);

assign Mem_WrData = WriteDataM;
assign Mem_WrAddr = ALUResultM;

// Pipeline Register 4 -> Memory | Writeback
pl_reg_mw plmw(
    .clk        ( clk        ),
    .RegWriteM  ( RegWriteM  ),
    .ResultSrcM ( ResultSrcM ),
    .ALUResultM ( ALUResultM ),
    .WriteDataM ( WriteDataM ),
    .ReadDataM  ( ReadDataM  ),
    .PCM        ( PCM        ),
    .RdM        ( RdM        ),
    .PCPlus4M   ( PCPlus4M   ),
    .RegWriteW  ( RegWriteW  ),
    .ResultSrcW ( ResultSrcW ),
    .ALUResultW ( ALUResultW ),
    .WriteDataW ( WriteDataW ),
    .ReadDataW  ( ReadDataW  ),
    .PCW        ( PCW        ),
    .RdW        ( RdW        ),
    .PCPlus4W   ( PCPlus4W   ),
    .lAuiPCM    ( lAuiPCM    ),
    .lAuiPCW    ( lAuiPCW    )
);


// ResultW Source
mux4 #(32)     resultmux(ALUResultW, ReadDataW, PCPlus4W, lAuiPCW, ResultSrcW, ResultW);

// hazard unit
hazardUnit u_hazardUnit(
    .PCSrcE     ( PCSrcE     ),
    .RegWriteM  ( RegWriteM  ),
    .RegWriteW  ( RegWriteW  ),
    .Rs1D        ( InstrD[19:15]),
    .Rs2D        ( InstrD[24:20]),
    .RdE        ( RdE        ),
    .Rs1E       ( Rs1E       ),
    .Rs2E       ( Rs2E       ),
    .RdM        ( RdM        ),
    .RdW        ( RdW        ),
    .ResultSrcE ( ResultSrcE ),
    .StallF     ( StallF     ),
    .StallD     ( StallD     ),
    .FlushD     ( FlushD     ),
    .FlushE     ( FlushE     ),
    .ForwardAE  ( ForwardAE  ),
    .ForwardBE  ( ForwardBE  )
);

endmodule
