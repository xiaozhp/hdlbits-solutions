odule top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
	localparam IDLE=3'd0,
    			D1=3'd1,
    			D2=3'd2,
    			D3=3'd3,
    			D4=3'd4;
    reg [2:0]state,next;
    always@(*)
        case(state)
            IDLE:next=data?D1:IDLE;
            D1:next=data?D2:IDLE;
            D2:next=data?D2:D3;
            D3:next=data?D4:IDLE;
            D4:next=D4;
            default:next=IDLE;
        endcase
    always@(posedge clk)
        if(reset)state<=IDLE;
    else state<=next;
    assign start_shifting=(state==D4);
endmodule
