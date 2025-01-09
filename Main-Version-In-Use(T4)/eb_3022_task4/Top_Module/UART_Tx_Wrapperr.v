
module UART_Tx_Wrapperr(
	input clk_50M,
	output tx
);

wire [0:7] data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13;
reg start = 0;
reg [35:0] counter = 0;

assign {data0,data1,data2,data3,data4,data5,data7,data8,data9,data10,data11,data12,data13} = "RaunakArora  ";
assign data6 =  8'h0A;  // LF for Enter("\n"; for this increse counter value)



UART_Tx_Wrapper u_UART_Tx_Wrapper(
    .clk_50M ( clk_50M ),
	 .start   ( start   ),
    .data0   ( data0   ),
    .data1   ( data1   ),
    .data2   ( data2   ),
    .data3   ( data3   ),
    .data4   ( data4   ),
    .data5   ( data5   ),
    .data6   ( data6   ),
    .data7   ( data7   ),
    .data8   ( data8   ),
    .data9   ( data9   ),
    .data10  ( data10  ),
    .data11  ( data11  ),
    .data12  ( data12  ),
    .data13  ( data13  ),
//	 .done    ( done    ),
    .tx      ( tx      )
);

always @(negedge clk_50M) begin
    if (counter == 750000000) begin
			start <= 1;
	 end
	 if(counter == 750000012) begin
   	counter <= 0;
		start <=0;
	 end
	 counter <= counter + 1'b1;
end


endmodule