module RX_Complete(
	input clk_50M,
	input rx,
	output reg led = 1,
	output tx
);

uart_rx u_uart_rx(
    .clk_3125    ( clk_3125    ),
    .rx          ( rx          ),
    .rx_msg      ( rx_msg      ),
    .rx_complete ( rx_complete ),
    .tx          ( tx          )
);

//UART_Tx_Wrapper u_UART_Tx_Wrapper(
//    .clk_3125 ( clk_3125 ),
//    .start    ( done     ),
//    .data0    ( data0    ),
//    .data1    ( data1    ),
//    .data2    ( data2    ),
//    .data3    ( data3    ),
//    .data4    ( data4    ),
//    .data5    ( data5    ),
//    .data6    ( data6    ),
//    .data7    ( data7    ),
//    .tx       ( tx       )
//);



Frequency_Scaling u_Frequency_Scaling(
    .clk_50M ( clk_50M ),
    .adc_clk_out  ( clk_3125  )
);


wire [0:7] rx_msg;
wire rx_complete;
wire clk_3125;
reg [0:7] data0;
reg [0:7] data1;
reg [0:7] data2;
reg [0:7] data3;
reg [0:7] data4;
reg [0:7] data5;
reg [0:7] data6;
reg [0:7] data7;
reg [0:7] data [7:0];
reg [2:0] state = 0;
reg done = 0;

always@(posedge clk_3125)
begin
	case(state)
		0:begin
			done <= 0;
			if(rx_complete) begin
				data0 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 1;
			end
		end
		1:begin
			if(rx_complete) begin
				data1 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 2;
			end
		end
		2:begin
			if(rx_complete) begin
				data2 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 3;
			end
		end
		3:begin
			if(rx_complete) begin
				data3 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 4;
			end
		end
		4:begin
			if(rx_complete) begin
				data4 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 5;
			end
		end
		5:begin
			if(rx_complete) begin
				data5 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 6;
			end
		end
		6:begin
			if(rx_complete) begin
				data6 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 7;
			end
		end
		7:begin
			if(rx_complete) begin
				data7 <= {rx_msg[7],rx_msg[6],rx_msg[5],rx_msg[4],rx_msg[3],rx_msg[2],rx_msg[1],rx_msg[0]};
				state <= 0;
				done <= 1;
			end
		end
	endcase
	
	if({data0,data1,data2,data3,data4,data5,data6,data7} == "Start   ")  led <= ~led;
	
end

	
endmodule