module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    localparam IDLE=1'b0;
    localparam COM=1'b1;
    reg state,next;
    always@(*)begin
        case(state)
            IDLE:next=x?COM:IDLE;
            COM:next=COM;
            default:next=IDLE;
        endcase
    end
    always@(posedge clk or posedge areset)begin
        if(areset)begin
            state<=IDLE;
            
        end
        else begin
            state<=next;
            
        end
    end
    assign z=(state==COM)?~x:x;

endmodule
