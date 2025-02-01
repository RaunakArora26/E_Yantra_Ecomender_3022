module hazardUnit (
    input             PCSrcE, RegWriteM, RegWriteW,
    input      [4:0]  Rs1D, Rs2D, RdE, Rs1E, Rs2E, RdM, RdW,
    input      [1:0]  ResultSrcE,
    output reg        StallF, StallD, FlushD, FlushE,
    output reg [1:0]  ForwardAE, ForwardBE
);

initial begin
    StallF = 0; StallD = 0; FlushD = 0; FlushE = 0;
    ForwardAE = 0; ForwardBE = 0;
end

wire lwStall = ResultSrcE[0] && ((Rs1D == RdE) | (Rs2D == RdE));

always @(*) begin
    
    //Data Hazard Logic or we say forward logic

    //Forward A
    if(((Rs1E == RdM) && RegWriteM) && (Rs1E != 0)) begin
        ForwardAE = 2'b10;
    end
    else if(((Rs1E == RdW) & RegWriteW) && (Rs1E != 0)) begin
        ForwardAE = 2'b01;
    end
    else    ForwardAE = 2'b00;

    //ForwardB
    if(((Rs2E == RdM) && RegWriteM) && (Rs2E != 0)) begin
        ForwardBE = 2'b10;
    end
    else if(((Rs2E == RdW) & RegWriteW) && (Rs2E != 0)) begin
        ForwardBE = 2'b01;
    end
    else    ForwardBE = 2'b00;

    StallF = lwStall;
    StallD = lwStall;

    FlushD = PCSrcE;
    FlushE = lwStall | PCSrcE;
end

endmodule
