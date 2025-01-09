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
    input clk_1MHz,
//    input [3:0] pulse_width,
    output reg clk_500Hz, pwm_signal , IN1, IN2, led1, led2, led3
);

initial begin
    clk_500Hz = 1'b1; pwm_signal = 1'b0;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [14:0] pwm_counter = -1;
reg [3:0] pulse_width = 10;//50% duty cycle

//assign IN1 = 1;
//assign IN2 = 0;

always@(posedge clk_1MHz)
begin
	pwm_counter = pwm_counter + 1'b1;
	if(pwm_counter == 3125 || pwm_counter == 6250)	clk_500Hz = ~clk_500Hz;
	if(pwm_counter >= 6250)		pwm_counter = 0;
end
always@(*)
begin
	if(pwm_counter < (pulse_width * 312))
	begin
		pwm_signal = 1'b1;
	end
	else	pwm_signal = 1'b0;
end

//
localparam One = 0,Two = 1, Three = 2;//, Four = 2'b11;
reg [3:0] state = 0;
reg [35:0] counter = 0;

//state machine
always@(posedge clk_1MHz)
begin
	case(state)
		One:begin
			IN1 <= 0;
			IN2 <= 1;
			pulse_width <= 15;
			led1 <= 1;
			led2 <= 0;
			led3 <= 0;
			if(counter == 2_000_000) begin
				state <= 1;
				counter <= 0;
			end
			counter <= counter + 1;
		end
		Two:begin
			IN1 <= 1;
			IN2 <= 0;
			led1 <= 0;
			led2 <= 1;
			led3 <= 0;
			pulse_width <= 10;
			if(counter == 2_000_000) begin
				state <= 2;
				counter <= 0;
			end
			counter <= counter + 1;
		end
		Three:begin
			IN1 <= 0;
			IN2 <= 1;
			led1 <= 0;
			led2 <= 0;
			led3 <= 1;
			pulse_width <= 10;
			if(counter == 2_000_000) begin
				state <= 0;
				counter <= 0;
			end
			
			counter <= counter + 1;
		end

	
	endcase

end




//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////x`

endmodule
