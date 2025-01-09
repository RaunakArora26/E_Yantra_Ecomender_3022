
module task_4(
	input clk_50M,
	input rx,
	input cs_out,
	input dout,
	output tx,
	output S_0,S_1,
	output S_2,S_3,
	output reg EI1_R = 0,EI1_G = 0,EI1_B = 0,
	output reg EI2_R = 0,EI2_G = 0,EI2_B = 0,
	output reg EI3_R = 0,EI3_G = 0,EI3_B = 0,
	output reg MI_R = 0,MI_G = 0,MI_B = 0,
	output IN1,IN2,IN3,IN4,
	output ENA,ENB,
	output adc_cs_n,din,
	output adc_sck

);

// Declaring registers
reg [2:0] s_clk_counter = 0;

// For ADC Module 50Mhz to 3.125Mhz
always @(negedge clk_50M) begin
    if (s_clk_counter == 7) clk_3125KHz = ~clk_3125KHz;
    s_clk_counter = s_clk_counter + 1'b1;
end


//Instatiation of modules
	uart_rx u_uart_rx(
    .clk_3125    (clk_3125KHz  ),//input
    .rx          ( rx          ),//input
    .rx_msg      ( rx_msg      )//output [0:7] 
);

UART_Tx_Wrapper u_UART_Tx_Wrapper(
    .clk_3125 ( clk_3125KHz ),//input
	 .start   ( start        ),//start wire
    .data0   ( data0        ),//wire input
    .data1   ( data1        ),//wire input
    .data2   ( data2        ),//wire input
    .data3   ( data3        ),//wire input
    .data4   ( data4        ),//wire input
    .data5   ( data5        ),//wire input
    .data6   ( data6        ),//wire input
    .data7   ( data7        ),//wire input
    .data8   ( data8        ),//wire input
    .data9   ( data9        ),//wire input
    .data10  ( data10       ),//wire input
    .data11  ( data11       ),//wire input
    .data12  ( data12       ),//wire input
    .data13  ( data13       ),//wire input
//	 .done    ( done         ),
    .tx      ( tx           ) //output
);

color_Sensor u_color_Sensor(
    .clk_3125KHz ( clk_3125KHz ),//input
    .cs_out      ( cs_out      ),//input value from color sensor
    .S_2         ( S_2         ),//filter value [0] output 
    .S_3         ( S_3         ),//filter value [1] output
    .color       ( color       ),//output 
    .S_0         ( S_0         ),//frequency scalling , output
    .S_1         ( S_1         ) //frequency scalling , 20% , output
);

ADC_Controller u_ADC_Controller(
    .dout         ( dout         ),//input 
    .adc_sck      ( clk_3125KHz  ),//input
    .adc_cs_n     ( adc_cs_n     ),//output
    .din          ( din          ),//output
    .left_value   ( left_value   ),//wire to black_Line
    .center_value ( center_value ),//wire to black_Line
    .right_value  ( right_value  ) //wire to black_Line
);
assign adc_sck = clk_3125KHz;

Black_Line u_Black_Line(
    .clk_3125KHz     ( clk_3125KHz     ),//input
    .l               ( left_value      ),//input from adc [11:0]
    .c               ( center_value    ),//input from adc [11:0] 
    .r               ( right_value     ),//input fron adc [11:0]
    .node_what_to_do ( node_what_to_do ),//wire to redrict at node detection [1:0]
	 .jaggad_line     ( jaggad_line     ),//wire for jaggad line always 0 by default
    .IN1             ( IN1             ),//output
    .IN2             ( IN2             ),//output
    .IN3             ( IN3             ),//output
    .IN4             ( IN4             ),//output
    .pulse_widht_r   ( pulse_widht_r   ),//wire to pwm right [3:0]
    .pulse_widht_l   ( pulse_widht_l   ),//wire to pwm left [3:0]
    .node_detected   ( node_detected   ) //node detected wire
);

pwm_generator left_pwm_generator(
    .clk_3125KHz ( clk_3125KHz  ), //input
    .pulse_width ( pulse_widht_l), //wire from black_Line
    .pwm_signal  ( ENB   ) //output
);
pwm_generator right_pwm_generator(
    .clk_3125KHz ( clk_3125KHz  ), //input
    .pulse_width ( pulse_widht_r), //wire from black_Line
    .pwm_signal  ( ENA   ) //output
);


reg [1:0] node_what_to_do = 2'b11;
wire [1:0] color;
wire [7:0] rx_msg;
wire node_detected;
wire [3:0] pulse_widht_r, pulse_widht_l;
wire [11:0] left_value,right_value,center_value;
reg [0:7] data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13;
reg start = 0;
reg [30:0] counter = 0;
reg repeat_counter = 0;
reg [30:0] green_light_counter = 0;
reg clk_3125KHz = 0;
reg jaggad_line = 0;

localparam Recieve_S = 0, Start = 1, wait1 = 2, Expected_node1 = 3, wait2 = 4, Expected_color_patch1G = 5,Expected_node2 = 6, wait3 = 7;
localparam Expected_node3 = 8, Expected_color_patch1R = 9, Expected_node4 = 10, Expected_color_patch1B = 11, done = 12;
localparam Expected_node7 = 13, wait6 = 14, wait5 = 15, Expected_node6 = 16, wait4 = 17, Expected_node5 = 18, x = 19;
localparam wait9 = 20, x2 = 21, wait8 = 22, Expected_node12 = 23, Expected_color_patch2B = 24, Expected_node11 = 25;
localparam Expected_color_patch2R = 26, Expected_node10 = 27, wait7 = 28, Expected_node9 = 29, Expected_color_patch2G = 30,x4 = 31;
localparam Expected_node8 = 31;
reg [7:0] state = Recieve_S;
reg [30:0] counter_extra = 0;

always@(posedge clk_3125KHz)
begin
	case(state)
		Recieve_S:begin
				if(rx_msg == "S") begin
					state <= Start;
					
				end
				start <= 0;
				jaggad_line <= 0;
		end
		Start:begin
				start <= 0;
				jaggad_line <= 0;
				//start the line folowwer
				if(node_detected) begin
					node_what_to_do <= 2'b00;
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Start        ";
					data13 <= 8'h0A; // \n
					start <= 1;
					state <= wait1;
				end
		end
		wait1:begin
				start <= 0;
				jaggad_line <= 0;
				if(counter == 3125000) begin //1 sec wait to move forward
					state <= Expected_node1;
					counter <= 0;
				end
				counter <= counter + 1;
				node_what_to_do <= 2'b00;//forward
		end
		Expected_node1:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b00;
					state <= Expected_color_patch1G;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 1       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
		end
//		wait2:begin
//				start <= 0;
//				if(counter == 3125000) begin //1 sec wait to move forward
//					state <= Expected_color_patch1G;
//					counter <= 0;
//			end
//			counter <= counter + 1;
//			node_what_to_do <= 2'b00;//forward
//		end
		Expected_color_patch1G:begin
				start <= 0;
				jaggad_line <= 0;
				if(color==2'b10) begin  //Green
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "SLM-FSU1-AS-#";
					data13 <= 8'h0A; // \n
					start <= 1;
					state <= Expected_node2;
				
					{EI1_R,EI1_G,EI1_B} <= 3'b010;
					{EI2_R,EI2_G,EI2_B} <= 3'b010;
					{EI3_R,EI3_G,EI3_B} <= 3'b010;
					{MI_R ,MI_G ,MI_B } <= 3'b010;
				end
		end
		Expected_node2:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b10;
					state <= wait3;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 2       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end				
		end
		wait3:begin
				start <= 0;
				jaggad_line <= 0;
				if(counter == 6250000) begin //2 sec wait to move right
					state <= Expected_node3;
					counter <= 0;
			end
			counter <= counter + 1;
			node_what_to_do <= 2'b01;//right
		end
		Expected_node3:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b00;//forward
					state <= Expected_color_patch1R;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 3       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
		end
		Expected_color_patch1R:begin
				start <= 0;
				jaggad_line <= 0;
				if(color==2'b01) begin  //red
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "SLM-FSU2-IM-#";
					data13 <= 8'h0A; // \n
					start <= 1;
					state <= Expected_node4;
				
					{EI1_R,EI1_G,EI1_B} <= 3'b100;
					{EI2_R,EI2_G,EI2_B} <= 3'b100;
					{EI3_R,EI3_G,EI3_B} <= 3'b100;
					{MI_R ,MI_G ,MI_B } <= 3'b100;
				end
		end
		Expected_node4:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b10;//right
					state <= Expected_color_patch1B;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 4       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
		end
		Expected_color_patch1B:begin
				start <= 0;
				jaggad_line <= 0;
				if(color==2'b11) begin  //blue
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "SLM-FSU3-IS-#";
					data13 <= 8'h0A; // \n
					start <= 1;
					state <= Expected_node5;
				
					{EI1_R,EI1_G,EI1_B} <= 3'b001;
					{EI2_R,EI2_G,EI2_B} <= 3'b001;
					{EI3_R,EI3_G,EI3_B} <= 3'b001;
					{MI_R ,MI_G ,MI_B } <= 3'b001;
				end
		end
		Expected_node5:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b00;
					state <= wait4;
					counter <= 0;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 5       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end				
		end
		wait4:begin
				start <= 0;
				jaggad_line <= 0;
				if(counter == 3125000) begin //1 sec wait to move forward
					state <= x;
					counter <= 0;
				end
				counter <= counter + 1;
				node_what_to_do <= 2'b00;//forward
				counter_extra<=0;
		end
		x:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					if(counter_extra == 10000) 	begin
							node_what_to_do <= 2'b00;//forward
						counter_extra <= 0;
					end
					else 	node_what_to_do <= 2'b10;//right
					counter_extra <= counter_extra + 1;
					state <= wait5;
					jaggad_line <= 1;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 6       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
		end
//		Expected_node6:begin
//				start <= 0;
//				jaggad_line <= 0;
//				if(node_detected) begin
//					node_what_to_do <= 2'b10;//right
//					state <= wait5;
//					jaggad_line <= 1;
//					
//					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 6       ";
//					data13 <= 8'h0A; // \n
//					start <= 1;
//				end
//		end
		wait5:begin
				start <= 0;
				jaggad_line <= 1;
				if(counter == 6250000) begin //2 sec wait to move forward
					state <= Expected_node7;
					counter <= 0;
			end
			counter <= counter + 1;
			node_what_to_do <= 2'b10;//more right
		end
		Expected_node7:begin
				start <= 0;
				jaggad_line <= 1;
				if(node_detected) begin
					node_what_to_do <= 2'b10;
					state <= wait6;
					jaggad_line <= 0;
					counter <= 0;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 7       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end				
		end
		wait6:begin
				start <= 0;
				jaggad_line <= 0;
				if(counter == 625000 	) begin //1 sec wait to move forward
					state <= x4;
					counter <= 0;
				end
				counter <= counter + 1;
				node_what_to_do <= 2'b10;
				counter_extra<=0;
		end
		x4:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b00;
					state <= Expected_color_patch2G;
					jaggad_line <= 1;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 8       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
//				node_what_to_do <= 2'b11;
		end
//
//		Expected_node7:begin
//				start <= 0;
//				jaggad_line <= 1;
//				if(node_detected) begin
//					node_what_to_do <= 2'b10;//more right
//						state <= wait6;
//						jaggad_line <= 0;
//					
//					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 7       ";
//					data13 <= 8'h0A; // \n
//					start <= 1;
//				end			
//		
//		end
//		wait6:begin
//				start <= 0;
//				jaggad_line <= 0;
//				if(counter == 1) begin //1 sec wait to move forward
//					state <= x4;
//					counter <= 0;
//				end
//				counter <= counter + 1;
//				node_what_to_do <= 2'b10;//forward
//		end
//	   x4:begin
//			node_what_to_do <= 2'b00;
//		end
//		Expected_node8:begin
//				start <= 0;
//				node_what_to_do <= 2'b00;
//				jaggad_line <= 0;
//				if(node_detected) begin
//					node_what_to_do <= 2'b00;
//					counter_extra <= counter_extra + 1;
//					state <= Expected_color_patch2G;
//					jaggad_line <= 1;
//					
//					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 8       ";
//					data13 <= 8'h0A; // \n
//					start <= 1;
//				end
//		end
		Expected_color_patch2G:begin
				start <= 0;
				jaggad_line <= 0;
				if(color==2'b10) begin  //Green
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "SLM-FSU1-AS-#";
					data13 <= 8'h0A; // \n
					start <= 1;
					state <= Expected_node9;
					{EI1_R,EI1_G,EI1_B} <= 3'b010;
					{EI2_R,EI2_G,EI2_B} <= 3'b010;
					{EI3_R,EI3_G,EI3_B} <= 3'b010;
					{MI_R ,MI_G ,MI_B } <= 3'b010;
				end
		end
		Expected_node9:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b10;
					state <= wait7;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 9       ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end				
		end
		wait7:begin
				start <= 0;
				jaggad_line <= 0;
				if(counter == 6250000) begin //2 sec wait to move right
					state <= Expected_node10;
					counter <= 0;
			end
			counter <= counter + 1;
			node_what_to_do <= 2'b01;//right
		end
		Expected_node10:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b00;//forward
					state <= Expected_color_patch2R;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 10      ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
		end
		Expected_color_patch2R:begin
				start <= 0;
				jaggad_line <= 0;
				if(color==2'b01) begin  //red
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "SLM-FSU2-IM-#";
					data13 <= 8'h0A; // \n
					start <= 1;
					state <= Expected_node11;
				
					{EI1_R,EI1_G,EI1_B} <= 3'b100;
					{EI2_R,EI2_G,EI2_B} <= 3'b100;
					{EI3_R,EI3_G,EI3_B} <= 3'b100;
					{MI_R ,MI_G ,MI_B } <= 3'b100;
				end
		end
		Expected_node11:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b10;//right
					state <= Expected_color_patch2B;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 11      ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
		end
		Expected_color_patch2B:begin
				start <= 0;
				jaggad_line <= 0;
				if(color==2'b11) begin  //blue
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "SLM-FSU3-IS-#";
					data13 <= 8'h0A; // \n
					start <= 1;
					state <= Expected_node12;
				
					{EI1_R,EI1_G,EI1_B} <= 3'b001;
					{EI2_R,EI2_G,EI2_B} <= 3'b001;
					{EI3_R,EI3_G,EI3_B} <= 3'b001;
					{MI_R ,MI_G ,MI_B } <= 3'b001;
				end
		end
		Expected_node12:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
					node_what_to_do <= 2'b00;
					state <= wait8;
					counter <= 0;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 12      ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end				
		end
		wait8:begin
				start <= 0;
				jaggad_line <= 0;
				if(counter == 3125000) begin //1 sec wait to move forward
					state <= x2;
					counter <= 0;
				end
				counter <= counter + 1;
				node_what_to_do <= 2'b00;//forward
		end
		x2:begin
				start <= 0;
				jaggad_line <= 0;
				if(node_detected) begin
						if(counter_extra == 10000) 	begin
						node_what_to_do <= 2'b00;//forward
						counter_extra <= 0;
					end
					else 	node_what_to_do <= 2'b10;//right
					counter_extra <= counter_extra + 1;
//					node_what_to_do <= 2'b10;//right
					state <= wait9;
					jaggad_line <= 1;
					
					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 13      ";
					data13 <= 8'h0A; // \n
					start <= 1;
				end
		end
		wait9:begin
				start <= 0;
				jaggad_line <= 1;
				if(counter == 6250000) begin //2 sec wait to move forward
					state <= done;
					counter <= 0;
			end
			counter <= counter + 1;
			node_what_to_do <= 2'b10;//more right
		end
//		Expected_node7:begin
//				start <= 0;
//				if(node_detected) begin
//					node_what_to_do <= 2'b10;//more right
//						state <= wait6;
//						jaggad_line <= 0;
//					
//					{data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12} <= "Node 7       ";
//					data13 <= 8'h0A; // \n
//					start <= 1;
//				end			
//		
//		end


		done:begin
			jaggad_line <= 1;
			node_what_to_do <= 2'b11;//stop
			if (green_light_counter > 0 && green_light_counter < 3125000) begin
            {EI1_R, EI1_G, EI1_B} <= 3'b010;  // Green light on
            {EI2_R, EI2_G, EI2_B} <= 3'b010;
            {EI3_R, EI3_G, EI3_B} <= 3'b010;
            {MI_R, MI_G, MI_B} <= 3'b010;
        end else begin
            {EI1_R, EI1_G, EI1_B} <= 3'b000;  // Green light off
            {EI2_R, EI2_G, EI2_B} <= 3'b000;
            {EI3_R, EI3_G, EI3_B} <= 3'b000;
            {MI_R, MI_G, MI_B} <= 3'b000;
			end
			if (green_light_counter == 6250000) begin
            green_light_counter <= 0;  // Reset the counter
			end else begin
            green_light_counter <= green_light_counter + 1;  // Increment the counter
        end
		
		end
	endcase
	
////	
//	if(state == x4) begin
//									{EI1_R,EI1_G,EI1_B} <= 3'b010;
//				{EI2_R,EI2_G,EI2_B} <= 3'b010;
//				{EI3_R,EI3_G,EI3_B} <= 3'b010;
////				{MI_R ,MI_G ,MI_B } <= 3'b010;
//	
//	end
//	else begin
//									{EI1_R,EI1_G,EI1_B} <= 3'b000;
//				{EI2_R,EI2_G,EI2_B} <= 3'b000;
//				{EI3_R,EI3_G,EI3_B} <= 3'b000;
////				{MI_R ,MI_G ,MI_B } <= 3'b000;
//	end
//	if(state == wait6) begin
//									
//				{MI_R ,MI_G ,MI_B } <= 3'b001;
//	
//	end
//	else begin
//									
//				{MI_R ,MI_G ,MI_B } <= 3'b000;
//	end
end





endmodule