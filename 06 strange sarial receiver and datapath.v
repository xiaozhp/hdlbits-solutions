module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done,
    output [7:0] out_byte
); 
    localparam [2:0] IDLE 	 = 3'b000,
					 START 	 = 3'b001,
					 RECEIVE = 3'b010,
					 WAIT	 = 3'b011,
					 STOP    = 3'b100;

	reg [2:0] state, next;
	reg [3:0] i;
    always@(*)begin
        case(state)
            IDLE:	next=in?IDLE:START;
            START: 	next=RECEIVE;
            RECEIVE:begin
                if(i==4'd7)next=in?STOP:WAIT;
                else next=RECEIVE;
            end
            WAIT:next=in?IDLE:WAIT;
            STOP:next=in?IDLE:START;
            default:next=IDLE;
        endcase
    end
    always@(posedge clk)begin
        if(reset)begin
            state<=IDLE;
           i<=0; 
           out_byte<=0;

        end
        else begin 
            if(state==RECEIVE)begin state<=next;
           i<=i+1; 
                out_byte[i+1]<=in;
         
            end
            else begin state<=next;
           i<=0; 
           out_byte<=in;
            end
        end
    end
    always@(*)begin
        if(reset)begin 
            done<=0;
        end
        else begin
            
	 if(state==STOP)begin
               done<=1;
            end
            else begin
               done<=0;
            end
        end
    end

endmodule//so strange?it can success??!
