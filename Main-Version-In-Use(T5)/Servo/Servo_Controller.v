

module Servo_Controller(
    input clk_50MHz,
	 input ir,
    output  pwm_signal1,
	 output  pwm_signal2,
	 output reg led = 0
);

reg [20:0] value1 = 1000;
reg [20:0] value2 = 600;

reg [27:0] counter = 0;
reg [3:0] state = 0;

Base_Controller u1_Base_Controller(//base servo
    .clk_50MHz  ( clk_50MHz  ),
	 .value      ( value1     ),
    .pwm_signal ( pwm_signal1)
);

Base_Controller u2_Base_Controller(//grip servo
    .clk_50MHz  ( clk_50MHz  ),
	 .value      ( value2     ),
    .pwm_signal ( pwm_signal2 )
);


always@(posedge clk_50MHz)
begin
	led <= ~ir;
end

always@(posedge clk_50MHz)
begin
	
	case(state)
		0:begin
			if(~ir) state <= state + 1;		
		end
		1:begin
				value1 <= 1600;
				state <= state + 1;
		end
		2:begin
			value2 <= 600;
			if(counter == 50_000_000) begin//1 sec 
				value2 <= 1050;
				state <= state + 1;
				counter <= 0;
			end
			counter <= counter + 1;		
		end
		3:begin
			if(counter == 1_000_000) begin //_ sec
				value1 <= 1000;
				value2 <= 600;
				state <= 0;
				counter <= 0;			
			end
			counter <= counter + 1;
		end

		
	endcase


end



endmodule
