


module UART_Tx_Wrapper(
    input clk_3125,
	 input start,
	 input [0:7] data0,
	 input [0:7] data1,
	 input [0:7] data2,
	 input [0:7] data3,
	 input [0:7] data4,
	 input [0:7] data5,
	 input [0:7] data6,
	 input [0:7] data7,
	 input [0:7] data8,
	 input [0:7] data9,
	 input [0:7] data10,
	 input [0:7] data11,
	 input [0:7] data12,
	 input [0:7] data13,
	 output done,
    output tx
);

localparam DATA = 2'b00;
localparam IDLE = 2'b01;
localparam Wait = 2'b10;
localparam START = 2'b11;

reg [0:7] data [0:13];
reg [1:0] state = 3;//3 <- DATA
reg [3:0] index = 0;
reg parity_type = 0;
reg tx_start = 0;
reg [0:7] data_send;
wire tx_done;
reg [24:0] counter = 0;

always @(*) begin
    data[0] = data0;
    data[1] = data1;
    data[2] = data2;
    data[3] = data3;
    data[4] = data4;
    data[5] = data5;
    data[6] = data6;
    data[7] = data7;
    data[8] = data8;
    data[9] = data9;
    data[10] = data10;
    data[11] = data11;
    data[12] = data12;
    data[13] = data13;
end


// Instantiate the UART transmitter module
uart_tx u_uart_tx(
    .clk_3125    ( clk_3125    ),
    .parity_type ( parity_type ),
    .tx_start    ( tx_start    ),
    .data        ( data_send   ),
    .tx          ( tx          ),
    .tx_done     ( tx_done     )
);

always @(posedge clk_3125) begin
//    case(state)
//		  START: begin
//			  if(start) begin
//			    state <= DATA;
//			  end
//		  
//		  end
//	 
//        DATA: begin
//				
//            data_send <= data[index];
//            tx_start <= 1;    
//            state <= IDLE;
//				
//        end
//        IDLE: begin
//            tx_start <= 0;
//            if (tx_done) begin
//                state <= Wait;
//                if (index == 13) begin
//                    index <= 0;
////						  done <= 1;
//                end else begin
//                    index <= index + 1;
//                end
//            end
//        end
//		   Wait:begin
//				tx_start <= 0;
//					if(counter == 40000) begin
//						if(index == 0) 	state <= START;
//						else state <= DATA;
//						counter <= 1;
//						
//					end
//					else counter <= counter + 1;
//		  
//		  end
//    endcase
//	 


//Imporved code
		case(state)
			3:begin
				if(start)	state <= 0;
			end
			0:begin
				if(index < 14) begin
					tx_start <= 1;
					data_send <= data[index];
					state <= 1;
				end
				else begin
					tx_start <= 0;
					index <= 0;//reset to 0
					state <= 3;
				end
			end
			1:begin
				tx_start <= 0;
				state <= 2;			
			end
			2:begin
				if(tx_done) begin
					state <= 0;
					index <= index + 1;
				end
			end
			default: state <= 0;
		endcase
		end

endmodule
