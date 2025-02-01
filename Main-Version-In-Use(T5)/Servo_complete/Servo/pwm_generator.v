// EcoMender Bot : Task 1A : PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 100KHz Clock Frequency to 500Hz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : clk_1MHz, pulse_width
//Output : clk_50Hz, pwm_signal


module Servo_Controller(
    input clk_50MHz,
	 input ir,
    output reg pwm_signal,
	 output  reg led = 0
);

initial begin
   pwm_signal = 1'b0;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [16:0] pwm_counter = -1;
reg clk_1MHz = 0;

reg [4:0] counter = 4'b0;


wire [16:0] value; 
assign value = ir ? 17'd1700 : 17'd600; 



always@(posedge clk_50MHz)
begin
	led <= ir;
	
	if (!counter) clk_1MHz = ~clk_1MHz; // toggles clock signal
    counter = counter + 1'b1;
    if(counter == 5'd24)    counter = 4'b0;
end


always@(posedge clk_1MHz)
begin
	pwm_counter <= pwm_counter + 1;
	//if(pwm_counter == 1000 || pwm_counter == 2000)	clk_500Hz = ~clk_500Hz;
	if(pwm_counter >= 20000)		pwm_counter <= 0;
end
always@(*)
begin
	if(pwm_counter < (2400))//T_on - 400 to 2400 (-90 to 90 degree)//pulse_width * 1000
	begin
		pwm_signal <= 1'b1;
	end
	else	pwm_signal <= 1'b0;//T_off
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////x`

endmodule
