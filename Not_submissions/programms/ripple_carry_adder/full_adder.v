// Verilog code for Full Adder
// Define Full Adder module
module full_adder (
    input a, b, c_in, // Define input ports a, b and c_in
    output reg sum , c_out // Define output ports sum and c_out
);

always@(*)
begin
	case({a,b,c_in}) //by truth table of  full adder
		3'b000:{sum,c_out} = 2'b00;
		3'b001:{sum,c_out} = 2'b10;
		3'b010:{sum,c_out} = 2'b10;
		3'b011:{sum,c_out} = 2'b01;
		3'b100:{sum,c_out} = 2'b10;
		3'b101:{sum,c_out} = 2'b01;
		3'b110:{sum,c_out} = 2'b01;
		3'b111:{sum,c_out} = 2'b11;
		default:{sum,c_out} = 2'b00;	
	endcase

end


endmodule
