module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 
    parameter start=3'd0;
    parameter stop=3'd1;
    parameter stream=3'd2;
    parameter error=3'd4;
    reg [3:0]i;
    reg [2:0]state,next_state;
    always@(*)begin
        case(state)
            start:next_state=in?start:stream;
            stream:next_state=(i==4'd7)?(in?stop:error):stream;
            error:next_state=in?stop:error;
            stop:next_state=start;
            default:next_state=start;
        endcase
    end
    always@(posedge clk)begin
        if(reset)begin
           state<=start;
            i<=0;
        end
        else if(state==stream)begin
           i<=i+1;
            state<=next_state; 
        end
        else begin
           state<=next_state; 
            i<=4'd0;
        end
    end
    always@(*)begin
        if(state==stop)done=1'b1;
        else done=1'b0;
    end

endmodule
