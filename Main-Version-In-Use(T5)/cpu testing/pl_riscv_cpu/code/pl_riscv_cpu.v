
// pl_riscv_cpu.v - Top Module to test riscv_cpu

module pl_riscv_cpu (
    input         clk,
    input  [4:0]  SP,EP,
    input         write_points,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PCW, Result, ALUResultW, WriteDataW,
    output [31:0] path0,path1,path2,path3,path4,path5,path6,path7,path8,
    output path_found
);

wire [31:0] Instr, PC;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire [ 2:0] Store, funct3;
wire        MemWrite_rv32;
wire         Ext_MemWrite;
wire  [31:0] Ext_WriteData, Ext_DataAdr;
wire reset;

// instantiate processor and memories
riscv_cpu rvcpu    (clk, reset, PC, Instr,
                    MemWrite_rv32, DataAdr_rv32,
                    WriteData_rv32, ReadData, Result,
                    funct3, PCW, ALUResultW, WriteDataW);
instr_mem instrmem (PC, Instr);
data_mem  datamem  (clk, MemWrite, Store, DataAdr, WriteData, ReadData);

ReadWrite_controller u_ReadWrite_controller(
    .clk           ( clk           ),
    .SP            ( SP            ),
    .EP            ( EP            ),
    .write_points  ( write_points  ),
    .reset         ( reset         ),
    .Ext_MemWrite  ( Ext_MemWrite  ),
    .Ext_WriteData ( Ext_WriteData ),
    .Ext_DataAdr   ( Ext_DataAdr   )
);

Read_controller u_Read_controller(
    .clk       ( clk       ),
    .MemWrite  ( MemWrite  ),
    .reset     ( reset     ),
    .WriteData ( WriteDataW),
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
    .path_found( path_found)
);



assign Store = (Ext_MemWrite && reset) ? 3'b010 : funct3;
assign MemWrite  = (Ext_MemWrite && reset) ? 1'b1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule
