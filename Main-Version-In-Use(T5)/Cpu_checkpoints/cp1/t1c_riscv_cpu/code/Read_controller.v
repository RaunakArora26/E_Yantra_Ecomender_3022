
module Read_controller(
    input clk,
    input MemWrite,
    input reset,
    input [31:0] WriteData,
    input [31:0] DataAdr,
    output reg [31:0] path0,path1,path2,path3,path4,path5,path6,path7,
    output reg  path_found = 0
);

initial begin

end

reg [3:0] state = 0;

always@(negedge clk)
begin
    if(MemWrite && !reset) begin    
        if (DataAdr === 32'h02000008) begin//monitering node point addresss
    case(state)
        0:begin
            path0 <= WriteData;
            state <= state + 1;
        end
        1:begin
            path1 <= WriteData;
            state <= state + 1;
        end
        2:begin
            path2 <= WriteData;
            state <= state + 1;
        end
        3:begin
            path3 <= WriteData;
            state <= state + 1;
        end
        4:begin
            path4 <= WriteData;
            state <= state + 1;
        end
        5:begin
            path5 <= WriteData;
            state <= state + 1;
        end
        6:begin
            path6 <= WriteData;
            state <= state + 1;
        end
        7:begin
            path7 <= WriteData;
            state <= 0;
        end
        // 8:begin
        //     path8 <= WriteData;
        //     state <= 0;// if(path_found)    state <= 0;
        // end
    endcase

    end
    end

    if (DataAdr === 32'h0200000c & WriteData === 32'h1) begin//monitering cpu done addresss
        path_found <= 1;
    end
    else path_found <= 0;
end




endmodule