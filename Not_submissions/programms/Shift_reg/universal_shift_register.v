module universal_shift_register(
    input [3:0] i, // Define pins for parallel input
    input [1:0] sel, // Define select line pins to choose the operation
    input clk, rst, il, ir, // Define clock,reset, serial input for
    // shift left and serial input for shift right
    output reg [3:0] out_bit // Define output pins
);

always@(posedge clk or negedge rst)
begin
	if(rst==0)	out_bit <= 4'b0000;
	else begin
		case(sel)
			2'b00: out_bit <= out_bit;
			2'b01: out_bit <= {ir,out_bit[3:1]};
			2'b10: out_bit <= {out_bit[2:0],il};
			2'b11: out_bit <= i;
			default : begin  end
		
		endcase
	
	
	end

end



endmodule