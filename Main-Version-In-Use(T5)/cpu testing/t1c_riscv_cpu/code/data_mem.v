
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input       [2:0] funct3,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data, 
    output      reg [DATA_WIDTH-1:0] rd_data_mem
);     

// array of 64 32-bit words or data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
wire [DATA_WIDTH-1:0] word_addr = wr_addr[DATA_WIDTH-1:2] % 64; 






















//synchronous write logic
always @(posedge clk) begin
    if (wr_en) begin
        case (funct3)
            3'b000: begin  // sb (store byte)
                data_ram[word_addr] <= (data_ram[word_addr] & ~(32'hFF << (wr_addr[1:0] * 8))) |
                                      (wr_data[7:0] << (wr_addr[1:0] * 8));
            end

            3'b001: begin  // sh (store half-word)
                data_ram[word_addr] <= (data_ram[word_addr] & ~(32'hFFFF << (wr_addr[1] * 16))) |
                                      (wr_data[15:0] << (wr_addr[1] * 16));
            end

            3'b010: begin  // sw (store word)
                data_ram[word_addr] <= wr_data;
            end
        endcase
    end
end

// combinational read logic
// word-aligned memory access
always @(*) begin  //read asyncronasly
        case(funct3)
            3'b000:begin  //lb i.e store byte 8 bits... and signed soooo
                case(wr_addr[1:0])       //byte addressible memory i.e access each byte with last 2 bits
                    2'b00:  rd_data_mem = {{24{data_ram[word_addr][7]}},data_ram[word_addr][7:0]};
                    2'b01:  rd_data_mem = {{24{data_ram[word_addr][15]}},data_ram[word_addr][15:8]};
                    2'b10:  rd_data_mem = {{24{data_ram[word_addr][23]}},data_ram[word_addr][23:16]}; 
                    2'b11:  rd_data_mem = {{24{data_ram[word_addr][31]}},data_ram[word_addr][31:24]}; 
                endcase
            end
            3'b100:begin  //lbu i.e load byte 8 bits... and unsigned soooo
                //byte addressible memory i.e access each byte with last 2 bits
                rd_data_mem = data_ram[word_addr] >> (wr_addr[1:0] * 8);
                rd_data_mem = {24'b0, rd_data_mem[7:0]};
            end
            3'b101:begin  //lhu i.e load byte 16 bits...
                case(wr_addr[1])       //only last 1 bit req
                    1'b0:  rd_data_mem = {16'b0,data_ram[word_addr][15:0]};
                    1'b1:  rd_data_mem = {16'b0,data_ram[word_addr][31:16]};
                endcase
            end
            3'b001:begin  //lh i.e load byte 16 bits...
                case(wr_addr[1])       //only last 1 bit req
                    1'b0:  rd_data_mem = {{16{data_ram[word_addr][15]}},data_ram[word_addr][15:0]};
                    1'b1:  rd_data_mem = {{16{data_ram[word_addr][31]}},data_ram[word_addr][31:16]};
                endcase
            end             
            3'b010:begin  //lw i.e load byte 32 bits...
                rd_data_mem = data_ram[word_addr]; //since wr_add is also just read address in this case
            end
            default: rd_data_mem = 32'b0;
        endcase

    
end
endmodule


