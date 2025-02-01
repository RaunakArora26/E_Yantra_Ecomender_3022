
module Top_check_fpga(
    input clk,
    output path_found,
    output [31:0] path0
);

reg [4:0] SP = 8,EP = 17;
// reg write_points = 0;
//wire path_found;

wire [31:0] path1,path2,path3,path4,path5,path6,path7,path8;

t1c_riscv_cpu u_t1c_riscv_cpu(
    .clk_50M      ( clk          ),
    .SP           ( SP           ),
    .EP           ( EP           ),
    .path0        ( path0        ),
    .path1        ( path1        ),
    .path2        ( path2        ),
    .path3        ( path3        ),
    .path4        ( path4        ),
    .path5        ( path5        ),
    .path6        ( path6        ),
    .path7        ( path7        ),
    .path8        ( path8        ),
    .path_found   ( path_found   )
);



endmodule


