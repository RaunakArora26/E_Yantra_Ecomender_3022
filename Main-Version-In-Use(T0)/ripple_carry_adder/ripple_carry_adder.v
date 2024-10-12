module ripple_carry_adder (
    input [1:0] a, b,
    input cin, // Define all input ports
    output [1:0] sum,
    output c_out // Define all output ports
);

wire w1;

full_adder f1(a[0],b[0],cin,sum[0],w1);
full_adder f2(a[1],b[1],w1,sum[1],c_out);

endmodule
