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
//Output : clk_500Hz, pwm_signal


module pwm_generator(
    input clk_3125KHz,
    input [3:0] pulse_width,
    output reg clk_195KHz, pwm_signal
);

initial begin
    clk_195KHz = 1'b1; pwm_signal = 1'b0;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [12:0] pwm_counter = -1;

always@(posedge clk_3125KHz)
begin
	pwm_counter = pwm_counter + 1'b1;
	if(pwm_counter == 8 || pwm_counter == 16)	clk_195KHz = ~clk_195KHz;//195KHz
	if(pwm_counter >= 16)		pwm_counter = 0;
end
always@(*)
begin
	if(pwm_counter < (pulse_width * 8 / 10))
	begin
		pwm_signal = 1'b1;
	end
	else	pwm_signal = 1'b0;
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////x`

endmodule
