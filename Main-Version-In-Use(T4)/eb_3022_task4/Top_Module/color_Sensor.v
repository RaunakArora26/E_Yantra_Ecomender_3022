// EcoMender Bot : Task 1B : Color Detection using State Machines
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will detect colors red, green, and blue using state machine and frequency detection.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//Color Detection
//Inputs : clk_1MHz, cs_out
//Output : filter, color

// Module Declaration
module color_Sensor (
    input  clk_3125KHz, cs_out,
    output reg S_2,S_3,
	 output reg [1:0] color,
	 output S_0,S_1
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

assign S_0 = 1;
assign S_1 = 0;//20% frequency scaling

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3;
reg [8:0] counter_cs_out;//reg [5:0] counter_cs_out;
reg [8:0] green_reg = 0;//reg [5:0] save_reg2;//To store max value of frequncy counter 
reg [8:0] red_reg = 0;
reg [8:0] blue_reg = 0;
reg [12:0] counter = 0;
reg [1:0] state = 0;
reg reset = 1;

initial begin // editing this initial block is allowed
    {S_2,S_3} = 2'b00; color = 0;counter = -1;state = 0;counter_cs_out = 0;
end


always@(posedge clk_3125KHz)
begin
	case(state)
		S0:begin
				{S_2,S_3} <= 2'b00;//red filter
				counter <= counter + 1;
				reset <= 1;
				
				if(counter == 4999) begin
					counter <= 0;
					state <= state+1;
					red_reg <= counter_cs_out;
					reset <= 0;
				end
			end
		S1:begin
				{S_2,S_3} <= 2'b01;//blue filter
				counter <= counter + 1;
				reset <= 1;
				
				if(counter == 4999) begin
					counter <= 0;
					state <= state+1;
					blue_reg <= counter_cs_out;
					reset <= 0;
				end
			end
		S2:begin
				{S_2,S_3} <= 2'b11;//green filter
				counter <= counter + 1;
				reset <= 1;
				
				if(counter == 4999) begin
					counter <= 0;
					state <= state+1;
					green_reg <= counter_cs_out;
					reset <= 0;
				end
			end
		S3:begin
					if(red_reg >= 15 && red_reg <= 18 && blue_reg >= 6 && blue_reg <= 9 && green_reg >= 5 && green_reg <= 8)	color = 1;//red
					else if(red_reg >= 4 && red_reg <= 7 && blue_reg >= 8 && blue_reg <= 11 && green_reg >= 4 && green_reg <= 7)	color = 3;//blue
					else if(red_reg >= 10 && red_reg <= 13 && blue_reg >= 8 && blue_reg <= 11 && green_reg >= 11 && green_reg <= 14)	color = 2;//green
					else if(red_reg >= 19 && blue_reg >= 22 && green_reg >= 19)	 color = 0;//clear
					
					red_reg <= 0;
					blue_reg <= 0;
					green_reg <= 0;
					reset <= 1;
					state <= state+1;
			end	
	endcase

end

always @(posedge cs_out or negedge reset) begin
	if(!reset) counter_cs_out <= 0;

    else if (counter < 4999 && counter > 0)
        counter_cs_out <= counter_cs_out + 1;
end



//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
