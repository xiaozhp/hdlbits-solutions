module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
	localparam A=1'b0;
    localparam B=1'b1;
    reg state,next;
    reg[2:0]data;
    reg [1:0]sum,i;
    always@(*)begin
        case(state)
            A:next=s?B:A;
            B:next=B;
            default:next=A;
        endcase
    end
    always@(posedge clk)begin
        if(reset)begin
           state<=A;
            data<=3'b0;
            sum<=0;
            i<=0;
        end
        else if(state==B) begin
           state<=next;
            if(i==2)begin
                sum<=data[0]+data[1]+w;
               i<=0;
                data<=0;
            end
            else begin
                data[i]<=w;
                i<=i+1;
                sum=0;
        end
            
            
        end
        else state<=next;
    end
    assign z=(state==B && sum==2);
endmodule
