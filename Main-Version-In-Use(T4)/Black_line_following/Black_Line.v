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


module Black_Line(
    input clk_3125KHz,
    input [11:0] l,c,r,
    output reg IN1,IN2,IN3,IN4,
	 output reg [3:0] pulse_widht_r, pulse_widht_l,
	 output reg node_detected
);

initial begin
    IN1 = 0; IN2 = 1; IN3 = 0; IN4 = 1;
	 pulse_widht_l = 10; pulse_widht_r = 10;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
reg left = 1,right = 1,centre = 1;//high on Black_Line detected
reg ext_left = 1, ext_right = 1, ext_centre = 1;
reg [1:0] node_what_to_do = 2'b10;
always@(posedge clk_3125KHz)
begin
	if(l > 1500)   left <= 1;
	else left <= 0;
	
	if(r > 1500)   right <= 1;
	else right <= 0;
	
	if(c > 1500)   centre <= 1;
	else centre <= 0;
	
	if(l == 2047)   ext_left <= 1;
	else ext_left <= 0;
	
	if(r == 2047)   ext_right <= 1;
	else ext_right <= 0;
	
	if(c == 2047)   ext_centre <= 1;
	else ext_centre <= 0;
end

always@(posedge clk_3125KHz)
begin
	case({ext_left,ext_centre,ext_right})
//			3'b000:begin//search
//					IN1 <= 0;
//					IN2 <= 1;
//					IN3 <= 1;
//					IN4 <= 0;
//					
//					pulse_widht_l <= 9;
//					pulse_widht_r <= 9;
//			
//			end
			3'b010:begin//move forward normally
					IN1 <= 0;
					IN2 <= 1;
					IN3 <= 0;
					IN4 <= 1;
					
					pulse_widht_l <= 13;
					pulse_widht_r <= 13;
					node_detected <= 0;
			end
			3'b001:begin//move right
					IN1 <= 0;
					IN2 <= 1;
					IN3 <= 0;
					IN4 <= 1;
				
					pulse_widht_l <= 14;
					pulse_widht_r <= 8;
					node_detected <= 0;
			end
			3'b100:begin//move left
					IN1 <= 0;
					IN2 <= 1;
					IN3 <= 0;
					IN4 <= 1;
					
					pulse_widht_l <= 8;
					pulse_widht_r <= 14;
					;
					node_detected <= 0;
			end
			3'b111:begin//stop
						node_detected <= 1;
						
						case(node_what_to_do)
							
							2'b00:begin  //move straight
								IN1 <= 0;
								IN2 <= 1;
								IN3 <= 0;
								IN4 <= 1;
					
								pulse_widht_l <= 9;
								pulse_widht_r <= 9;
								
							end
					
							2'b01:begin  //move right
								IN1 <= 1;
								IN2 <= 0;
								IN3 <= 0;
								IN4 <= 1;
							
								pulse_widht_l <= 13;
								pulse_widht_r <= 12;
								
							end
					
							2'b10:begin  //move right some diffrent angle
								IN1 <= 1;
								IN2 <= 0;
								IN3 <= 0;
								IN4 <= 1;
							
								pulse_widht_l <= 15;
								pulse_widht_r <= 14;
								
							end
							
							2'b11:begin  //stop
								IN1 <= 0;
								IN2 <= 0;
								IN3 <= 0;
								IN4 <= 0;
								
								pulse_widht_l <= 10;
								pulse_widht_r <= 10;
								
							end
						endcase
			end
	
	
	endcase

	
//	if({ext_left,ext_centre,ext_right} == 3'b111 || {ext_left,ext_centre,ext_right} == 3'b011 || {ext_left,ext_centre,ext_right} == 3'b110 )
//		begin
//			IN1 <= 0;
//			IN2 <= 0;
//			IN3 <= 0;
//			IN4 <= 0;
//			
//			pulse_widht_l <= 10;
//			pulse_widht_r <= 10;
//		end
end


//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////x`

endmodule
