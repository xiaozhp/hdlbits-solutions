module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    localparam ORIGIN=3'd0;
    localparam S1=3'd1;
    localparam S2=3'd2;
    localparam S3=3'd3;
    localparam STOP=3'd5;
    reg [2:0]state,next;
    always@(*)
        case(state)
       		ORIGIN:next=S1;
        	S1:next=	S2;
            S2:next=	S3;
            S3:next=  STOP;
            STOP:next=STOP;
        default:next=ORIGIN;
        endcase
    always@(posedge clk)begin
        if(reset)state<=ORIGIN;
        else state<=next;
    end
    assign shift_ena=(state!=STOP);

endmodule
