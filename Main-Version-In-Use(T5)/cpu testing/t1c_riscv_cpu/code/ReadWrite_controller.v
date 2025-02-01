
module ReadWrite_controller(
    input clk,
    input [4:0] SP,
    input [4:0] EP,
    input write_points,
    output reg reset,
    output reg Ext_MemWrite,
    output reg [31:0] Ext_WriteData,
    output reg [31:0] Ext_DataAdr,
    output reg temp,temp2,temp3,
    output reg [3:0] state = 0
);

initial begin
    reset = 1;
    Ext_MemWrite = 0;
    Ext_WriteData = 0;
    Ext_DataAdr = 0;
    temp = 0;
    temp2 = 0;
    temp3 = 0;
end

localparam Prepare = 0, Write_SP = 1,waitSP_EP = 2, Write_EP = 3, waitEP_NP_1 = 4,Write_NP_1 = 5,waitNP_2 = 6,Write_NP_2 = 7,waitNP_3 = 8;
// reg [3:0] state = Prepare;

always@(posedge clk)
begin
    case(state)
        Prepare:begin
            reset <= 0;
            Ext_MemWrite <= 0;
            Ext_WriteData <= 0;
            Ext_DataAdr <= 0;
            temp2 <= 1;

            if(write_points)  begin
                state <= Write_SP;
                reset <= 1;
                temp3 <= 1;
            end
        end

        Write_SP:begin //write start point , 1 clk cycle is 320ns so its enough
            Ext_MemWrite <= 1;
            Ext_WriteData <= SP;
            Ext_DataAdr <= 32'h02000000; 
            state <= waitSP_EP;
        end

        waitSP_EP:begin
            Ext_MemWrite <= 0;
            Ext_WriteData <= 00;
            Ext_DataAdr <= 32'h0; 
            state <= Write_EP;
        end

        Write_EP:begin
            Ext_MemWrite <= 1;
            Ext_WriteData <= EP;
            Ext_DataAdr <= 32'h02000004;
            state <= waitEP_NP_1;
        end

        waitEP_NP_1:begin
            Ext_MemWrite <= 0;
            Ext_WriteData <= 00;
            Ext_DataAdr <= 32'h0; 
            state <= Write_NP_1;
        end

        Write_NP_1:begin
            Ext_MemWrite <= 1; 
            Ext_WriteData <= 00; 
            Ext_DataAdr <= 32'h02000008;
            state <= waitNP_2;
        end

        waitNP_2:begin
            Ext_MemWrite <= 0; 
            Ext_WriteData <= 00; 
            Ext_DataAdr <= 32'h0; 
            state <= Write_NP_2;
        end

        Write_NP_2:begin
            Ext_MemWrite <= 1; 
            Ext_WriteData <= 00; 
            Ext_DataAdr <= 32'h0200000c;
            state <= waitNP_3;
        end

        waitNP_3:begin
            Ext_MemWrite <= 0; 
            Ext_WriteData <= 00; 
            Ext_DataAdr <= 32'h0;
            state <= Prepare;
            temp <= 1;
        end
    endcase
end




endmodule