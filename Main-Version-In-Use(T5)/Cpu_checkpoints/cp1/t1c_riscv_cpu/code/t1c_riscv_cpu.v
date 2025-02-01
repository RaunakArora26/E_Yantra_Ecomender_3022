
// t1c_riscv_cpu.v - Top Module to test riscv_cpu

module t1c_riscv_cpu (
    input         clk,
    input  [4:0]  SP,EP,
    input         write_points,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC, Result,
    output [31:0] yo,
    output lo,
    output [31:0] path0,path1,path2,path3,path4,path5,path6,path7,
    output path_found
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
    .write_points  ( write_points  ),
    .reset         ( resett        ),
    .Ext_MemWrite  ( Ext_MemWrite  ),
    .Ext_WriteData ( Ext_WriteData ),
    .Ext_DataAdr   ( Ext_DataAdr   )
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
    .path_found  ( path_found  )
);




assign MemWrite  = (Ext_MemWrite && resett) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && resett) ? Ext_WriteData : WriteData_rv32;
assign funct3 = (Ext_MemWrite && resett) ? 3'b010: Instr[14:12];
assign DataAdr   = resett ? Ext_DataAdr : DataAdr_rv32;

assign yo = Ext_MemWrite;
assign lo = resett;
endmodule

