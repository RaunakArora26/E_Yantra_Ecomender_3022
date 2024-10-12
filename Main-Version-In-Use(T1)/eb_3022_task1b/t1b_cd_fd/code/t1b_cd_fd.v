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
module t1b_cd_fd (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3;//S0 = green , S1 = red , S2 = blue , S3 = clear
reg [14:0] counter_cs_out;//reg [5:0] counter_cs_out;
reg [14:0] save_reg2;//reg [5:0] save_reg2;//To store max value of frequncy counter 
reg [8:0] counter;
reg [1:0] state;
reg [1:0] max_color;

initial begin // editing this initial block is allowed
    filter = 3; color = 0;counter = 511;state = S3;counter_cs_out = 0;save_reg2 = 0;max_color = 0;
end


always @(posedge clk_1MHz) begin
	if(state == S3)	state <= state + 1;
	else	begin
		if (counter == 499) begin
			counter <= 0;
        	state <= state + 1; // Move to the next state
    	end
		else 	counter <= counter + 1;
	end 
	
end
//State table
always@(*)
begin
	case(state)
		S0:begin
			if(counter == 499)	begin
				filter = 0;
				save_reg2 = counter_cs_out;//green
				max_color = 2;//green
				end
			end
		S1:begin
			if(counter == 499)	begin
				filter = 1;
				if(counter_cs_out > save_reg2)		begin
					save_reg2 = counter_cs_out;//red
					max_color = 1;//red
					end
				else if(counter_cs_out == save_reg2) max_color = 0;//clear
			end
			end
		S2:begin
			if(counter == 499)	begin
				filter = 2;
				
				if(counter_cs_out > save_reg2)		begin
					color = 3;//blue
				end
				else if(counter_cs_out == save_reg2) color = 0;//clear
				else color = max_color;				
			end
			end
		S3:begin
					filter = 3; 	
			end	
	endcase

end

always@(posedge cs_out)
begin
    if(counter < 499 && counter > 0)//if(counter == 350)
    begin
        counter_cs_out <= counter_cs_out + 1;
    end
    
    if(counter == 0)  counter_cs_out <= 0;
end


//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
