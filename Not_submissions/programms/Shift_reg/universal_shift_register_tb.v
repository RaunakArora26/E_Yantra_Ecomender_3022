module universal_shift_register_tb;
reg [3:0]i;
reg [1:0]sel;
reg clk, rst, il, ir; //Define all input ports
wire [3:0] out_bit; //Define all output ports

//Map testbench ports with DUT ports
universal_shift_register uut(.i(i), .sel(sel), .clk(clk),
.rst(rst), .out_bit(out_bit), .il(il), .ir(ir));

initial begin
    rst = 1'b0; // Initialize values on all input pins
    clk = 0; ir = 0; il = 0; sel = 2'b00; i = 4'b0000;
end

always begin
    clk = ~clk; #5; //Define Clock operation
end

initial begin
    #50;
    rst = 1; #50 //Different Combinations of input
    ir = 1;
    sel = 2'b01;#10;
    ir = 0;#10;
    ir = 1;#10;
    ir = 0;#10;
    il = 1;
    sel = 2'b00;#50
    sel = 2'b10;
    il = 1;#10
    il = 0;#10
    il = 0;#10
    sel = 2'b11;#5
    i = 4'b1111;
    #100;
end

endmodule
