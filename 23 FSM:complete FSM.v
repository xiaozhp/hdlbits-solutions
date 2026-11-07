module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    parameter   IDLE=2'd0,
    			COUNT=2'd1,
    			DONE=2'd2,
    			SHIFT1=3'd4,
    			SHIFT2=3'd5,
    			SHIFT3=3'd6;
    reg [2:0]state,next;
    reg i;
    
    shift_register A(
        .clk(clk),
        .reset(reset||(ack&&state==DONE)),
        .data(data),
        .start_shift(i));
    always@(*)
        case(state)
            IDLE:next=i?SHIFT1:IDLE;
            SHIFT1:next=SHIFT2;
            SHIFT2:next=SHIFT3;
            SHIFT3:next=COUNT;
            COUNT:next=done_counting?DONE:COUNT;
            DONE:next=ack?IDLE:DONE;
            default:next=IDLE;
        endcase
    always@(posedge clk)begin
        
        if(reset)begin
            state<=IDLE;
            
        end
    else begin
        state<=next;
        
    end
    end
    assign shift_ena=(state==SHIFT1||state==SHIFT2||state==SHIFT3||(state==IDLE&&i));
    assign counting=(state==COUNT);
    assign done=(state==DONE);
	
endmodule
module shift_register(
	input clk,
    input reset,
    input data,
    output start_shift
);
    localparam IDLE=3'd0,
    			S1=3'd1,
    			S2=3'd2,
    			S3=3'd3,
    			S4=3'd4;
    reg [2:0]state,next;
    always@(*)
        case(state)
            IDLE:next=data?S1:IDLE;
            S1:next=data?S2:IDLE;
            S2:next=data?S2:S3;
            S3:next=data?S4:IDLE;
            S4:next=S4;
            default:next=IDLE;
                endcase
    always@(posedge clk)
        if(reset)state<=IDLE;
    	else state<=next;
    assign start_shift=(state==S4);
    
endmodule
