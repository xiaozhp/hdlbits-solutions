module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    localparam IDLE0=2'b0;
    localparam IDLE1=2'b1;
    localparam COM0=3'd2;
    localparam COM1=3'd3;
    reg [1:0]state,next;
    always@(*)begin
        case(state)
            IDLE0:next=x?IDLE1:IDLE0;
            IDLE1:next=x?COM1:COM0;
            COM1:next=x?COM1:COM0;
            COM0:next=x?COM1:COM0;
            default:next=IDLE0;
        endcase
    end
    always@(posedge clk or posedge areset)begin
        if(areset)begin
            state<=IDLE0;
        end
        else begin
            state<=next;
        end
    end
    assign z=(state==COM1||state==IDLE0)?0:1;

endmodule 
