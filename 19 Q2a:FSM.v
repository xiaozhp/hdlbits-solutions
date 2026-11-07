module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    localparam A=2'd0;
    localparam B=2'd1;
    localparam C=2'd2;
    localparam D=2'd3;
    reg [1:0]state,next;
    always@(*)begin
        case(state)
            A:begin
                if(r==0)next=A;
                else if(r[1]==1)next=B;
                else if(r[1]==0&&r[2]==1)next=C;
                else next=D;
            end
            B:next=r[1]?B:A;
            C:next=r[2]?C:A;
            D:next=r[3]?D:A;
            default:next=A;
        endcase
    end
    always@(posedge clk)
        if(!resetn)state<=A;
    else state<=next;
    assign g[1]=(state==B);
    assign g[2]=(state==C);
    assign g[3]=(state==D);

endmodule
