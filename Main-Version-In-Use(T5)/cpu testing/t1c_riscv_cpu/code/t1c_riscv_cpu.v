
// t1c_riscv_cpu.v - Top Module to test riscv_cpu

module t1c_riscv_cpu (
    input         clk_50M,
    input  [4:0]  SP,EP,
    input         write_point,//    input         write_points,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC, Result,
    output [31:0] yo,
    output lo,
    output [31:0] path0,path1,path2,path3,path4,path5,path6,path7,path8,
    output path_found,
    output temp,
    output reg temp4 = 0
//    output reg clk = 1,
);

wire [31:0] Instr;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire        MemWrite_rv32;
wire [2:0] funct3;// Store_rv32;
wire  resett;
// Declaring registers
// reg [10:0] s_clk_counter = 0;
wire         Ext_MemWrite;
wire  [31:0] Ext_WriteData, Ext_DataAdr;
reg clk = 1;//change to 1 for actual
reg write_points = 0;
reg [3:0] state = 0;
// reg temp4 = 0;
reg [3:0] counter = 0;


// Declaring registers
reg [2:0] s_clk_counter = 0;

// For ADC Module 12.5Mhz to 3.125Mhz
always @(posedge clk_50M) begin
    if (s_clk_counter == 7) begin //change after this
        clk <= ~clk;
        s_clk_counter <= 0;
    end else begin
        s_clk_counter <= s_clk_counter + 1'b1;
    end
end



always@(posedge clk)
begin
    case(state)
        0:begin
            write_points <= 1;
            temp4 <= 1;
				if(counter == 10)   state <= 1;
				counter <= counter + 1;
        end
        1:begin
            write_points <= 0;
        end
    endcase
end




// instantiate processor and memories
riscv_cpu rvcpu    (clk, resett, PC, Instr,
                    MemWrite_rv32, DataAdr_rv32,
                    WriteData_rv32, ReadData, Result);
instr_mem instrmem (PC, Instr);
data_mem  datamem  (clk, MemWrite, funct3, DataAdr, WriteData, ReadData);





ReadWrite_controller u_ReadWrite_controller(
    .clk           ( clk           ),
    .SP            ( SP            ),
    .EP            ( EP            ),
    .write_points  ( write_points  ),//    .write_points  ( write_points  ),
    .reset         ( resett        ),
    .Ext_MemWrite  ( Ext_MemWrite  ),
    .Ext_WriteData ( Ext_WriteData ),
    .Ext_DataAdr   ( Ext_DataAdr   ),
    .temp          ( temp          )
);



Read_controller u_Read_controller(
    .clk       ( clk       ),
    .MemWrite  ( MemWrite  ),
    .reset     ( resett     ),
    .WriteData ( WriteData ),
    .DataAdr   ( DataAdr   ),
    .path0     ( path0     ),
    .path1     ( path1     ),
    .path2     ( path2     ),
    .path3     ( path3     ),
    .path4     ( path4     ),
    .path5     ( path5     ),
    .path6     ( path6     ),
    .path7     ( path7     ),
    .path8     ( path8     ),
    .path_found  ( path_found  )
);




assign MemWrite  = (Ext_MemWrite && resett) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && resett) ? Ext_WriteData : WriteData_rv32;
assign funct3 = (Ext_MemWrite && resett) ? 3'b010: Instr[14:12];
assign DataAdr   = resett ? Ext_DataAdr : DataAdr_rv32;

assign yo = Ext_MemWrite;
assign lo = resett;
endmodule


// t1c_riscv_cpu.v - Top Module to test riscv_cpu

// module t1c_riscv_cpu (
//     input         clk,
//     input  [4:0]  SP,EP,
//     input         write_points,
//     output        MemWrite,
//     output [31:0] WriteData, DataAdr, ReadData,
//     output [31:0] PC, Result,
//     output [31:0] yo,
//     output lo,
//     output [31:0] path0,path1,path2,path3,path4,path5,path6,path7,path8,
//     output path_found
// );

// wire [31:0] Instr;
// wire [31:0] DataAdr_rv32, WriteData_rv32;
// wire        MemWrite_rv32;
// wire [2:0] funct3;// Store_rv32;
// wire  resett;
// // Declaring registers
// // reg [10:0] s_clk_counter = 0;
// wire         Ext_MemWrite;
// wire  [31:0] Ext_WriteData, Ext_DataAdr;
// // reg clk = 1;

// // Declaring registers
// // reg [2:0] s_clk_counter = 0;

// // // For ADC Module 50Mhz to 3.125Mhz
// // always @(negedge clk_50M) begin
// //     if (s_clk_counter == 7) clk <= ~clk;
// //     s_clk_counter <= s_clk_counter + 1'b1;
// // end






// // instantiate processor and memories
// riscv_cpu rvcpu    (clk, resett, PC, Instr,
//                     MemWrite_rv32, DataAdr_rv32,
//                     WriteData_rv32, ReadData, Result);
// instr_mem instrmem (PC, Instr);
// data_mem  datamem  (clk, MemWrite, funct3, DataAdr, WriteData, ReadData);





// ReadWrite_controller u_ReadWrite_controller(
//     .clk           ( clk           ),
//     .SP            ( SP            ),
//     .EP            ( EP            ),
//     .write_points  ( write_points  ),
//     .reset         ( resett        ),
//     .Ext_MemWrite  ( Ext_MemWrite  ),
//     .Ext_WriteData ( Ext_WriteData ),
//     .Ext_DataAdr   ( Ext_DataAdr   )
// );



// Read_controller u_Read_controller(
//     .clk       ( clk       ),
//     .MemWrite  ( MemWrite  ),
//     .reset     ( resett     ),
//     .WriteData ( WriteData ),
//     .DataAdr   ( DataAdr   ),
//     .path0     ( path0     ),
//     .path1     ( path1     ),
//     .path2     ( path2     ),
//     .path3     ( path3     ),
//     .path4     ( path4     ),
//     .path5     ( path5     ),
//     .path6     ( path6     ),
//     .path7     ( path7     ),
//     .path8     ( path8     ),
//     .path_found  ( path_found)
// );




// assign MemWrite  = (Ext_MemWrite && resett) ? 1 : MemWrite_rv32;
// assign WriteData = (Ext_MemWrite && resett) ? Ext_WriteData : WriteData_rv32;
// assign funct3 = (Ext_MemWrite && resett) ? 3'b010: Instr[14:12];
// assign DataAdr   = resett ? Ext_DataAdr : DataAdr_rv32;

// assign yo = Ext_MemWrite;
// assign lo = resett;
// endmodule

