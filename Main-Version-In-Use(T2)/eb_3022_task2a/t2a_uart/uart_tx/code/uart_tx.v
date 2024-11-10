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
module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

localparam clk_per_bits = 14;
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam SENT_BIT = 3'b010;
localparam PARTIY_BIT = 3'b011;
localparam STOP = 3'b100;

reg [2:0] state;      
reg [3:0] counter;      
reg [2:0] data_bit_sent;

initial begin
    tx = 1;
    tx_done = 0;
    state = IDLE;
    counter = 1;
    data_bit_sent = 3'b111;//ititally 7 as start with MSB
end


always@(posedge clk_3125)
begin
    case(state)
        IDLE:begin
                tx_done <= 0;//every time IDLE state tx_done needs to be resetted
                if(tx_start == 1)   begin
                    state <= START;
                    tx <= 0;
                end
        end
        START:begin
                //tx <= 0;
                if(counter == 14)   begin
                    state <= SENT_BIT;
                    counter <= 1;
                    tx <= data[7];
                end
                else counter <= counter + 1;
        end
        SENT_BIT:begin
                if(counter == 14)   begin
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
                if(counter == 14)   begin
                    state <= STOP;
                    tx = 1;  
                    counter <= 1;
                end
                else counter <= counter + 1;
        end
        STOP:begin       
                if(counter == 14)   begin
                    state <= IDLE;
                    counter <= 1;
                    tx_done = 1;
                    //tx_done <= 1; // set tx_done at the end of the transmission
                end
                else counter <= counter + 1;
        end
    endcase

end


// always@(*)
// begin

//     case(state)
//         IDLE:begin
//                 // tx_done is handled in the sequential block, no need to reset here
//                 tx_done = 0;//every time IDLE state tx_done needs to be resetted
//         end
//         START:begin
//                 tx = 0;
//         end
//         SENT_BIT:begin
//                     tx = data[data_bit_sent];
//         end
//         PARTIY_BIT:begin
//                     if(parity_type)     begin   //odd parity
//                         tx = ~^data;//XNOR all for odd parity
//                     end
//                     else       begin        //even parity
//                         tx = ^data;//XOR all for even parity
//                     end
//         end
//         STOP:begin
//                 tx = 1;
//                 if(counter == 14)     begin
//                     tx_done = 1;
//                 end
//         end

//     endcase


// end





//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule

