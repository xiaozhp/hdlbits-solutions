module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    localparam IDLE=3'd0;
    localparam S1=4'd1;
    localparam S2=4'd2;
    localparam S3=4'd3;
    localparam S4=4'd4;
    localparam DISC=4'd5;
    localparam FLAG=4'd6;
    localparam ERR=4'd7;
    localparam S5=4'd8;
    localparam S6=4'd9;
    reg [3:0]state,next;
    always@(*)begin
        case(state)
            IDLE:next=in?S1:IDLE;
            S1:next=in?S2:IDLE;
            S2:next=in?S3:IDLE;
            S3:next=in?S4:IDLE;
            S4:next=in?S5:IDLE;
            S5:next=in?S6:DISC;
            S6:next=in?ERR:FLAG;
            DISC:next=in?S1:IDLE;
            FLAG:next=in?S1:IDLE;
            ERR:next=in?ERR:IDLE;
            default:next=IDLE;
        endcase
    end
    always@(posedge clk)begin
        if(reset)state<=IDLE;
        else state<=next;
    end
    assign disc=(state==DISC)?1:0;
    assign flag=(state==FLAG)?1:0;
    assign err=(state==ERR)?1:0;

endmodule
