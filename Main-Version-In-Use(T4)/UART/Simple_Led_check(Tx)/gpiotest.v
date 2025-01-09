// EcoMender Bot : Task 2A - UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_3125 - 3125 KHz clock
        parity_type - even(0)/odd(1) parity type
        tx_start - signal to start the communication.
        data    - 8-bit data line to transmit

Output: tx      - UART Transmission Line
        tx_done - message transmitted flag
*/

// module declaration
module gpiotest(
    input clk_3125,
    //input tx_start,
    output reg tx,tx_done_led = 1
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

localparam clk_per_bits = 28;//baudRate = 115200
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam SENT_BIT = 3'b010;
localparam PARTIY_BIT = 3'b011;
localparam STOP = 3'b100;
localparam Wait = 3'b111;


reg [2:0] state;      
reg [24:0] counter;      
reg [2:0] data_bit_sent;
wire parity_type = 0;
wire [0:7] data = "?";//will send r instead of N so just always use [0:7] for using Character to ascii

reg tx_done = 0;

initial begin
    tx = 1;
    tx_done = 0;
    state = IDLE;
    counter = 1;
    data_bit_sent = 3'b111;//ititally 7 as start with MSB
end


always@(posedge clk_3125)
begin
	//if(!tx_start)  begin
    case(state)
        IDLE:begin
//                tx_done <= 0;//every time IDLE state tx_done needs to be resetted
                //if(tx_start == 1)   begin
                    state <= START;
                    tx <= 0;
						  tx_done_led <= 1;
                //end
        end
        START:begin
                //tx <= 0;
                if(counter == clk_per_bits-1)   begin
                    state <= SENT_BIT;
                    counter <= 1;
                    tx <= data[7];
                end
                else counter <= counter + 1;
        end
        SENT_BIT:begin
                if(counter == clk_per_bits-1)   begin
                    counter <= 1;
                    if(data_bit_sent == 0)      begin
                        state <= PARTIY_BIT;
                        data_bit_sent <= 3'b111;

                        if(parity_type)     begin   //odd parity
                            tx <= ~^data;//XNOR all for odd parity
                        end
                        else       begin        //even parity
                            tx <= ^data;//XOR all for even parity
                        end          
                    end 
                    else    begin
                        data_bit_sent <= data_bit_sent - 1;
                        tx <= data[data_bit_sent - 1];
                    end
                end
                else begin
                    counter <= counter + 1;
                    // tx <= data[data_bit_sent];
                end
        end
        PARTIY_BIT:begin
                if(counter == clk_per_bits-1)   begin
                    state <= STOP;
                    tx = 1; 
                    counter <= 1;
                end
                else counter <= counter + 1;
        end
        STOP:begin  
					 if(counter == clk_per_bits-2)   begin
                    tx_done <= 1; // set tx_done at the end of the transmission
                end
                if(counter == clk_per_bits-1)   begin
                    state <= Wait;
                    counter <= 1;
                    tx_done <= 0; // set tx_done at the end of the transmission
						  tx_done_led <= 0;
                end
                else counter <= counter + 1;
        end
		  Wait:begin
					if(counter == 6250000) begin
						state <= IDLE;
						counter <= 1;
						
					end
					else counter <= counter + 1;
		  
		  end
    endcase

	
end
//end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule

