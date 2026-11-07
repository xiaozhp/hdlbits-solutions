module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
  //this is a wrong answer,it is recorded toshow my thinking.
    localparam A=3'd0;
    localparam x1=3'd1;
    localparam x10=3'd2;
    localparam y_j=3'd3;
    localparam y1=3'd4;
    localparam y0=3'd6;
    localparam y00=3'd7;
    localparam B1=4'd8;
    localparam C=4'd9;
    localparam B0=4'd10;
    reg [3:0]state,next;
    always@(*)
        case(state)
       		A:next=x?B1:B0;
            B1:next=x?x1:C;
            B0:next=x?x1:C;
            C:next=x?x1:C;
            x1:next=x?x1:x10;
            x10:next=x?y_j:C;
            y_j:next=y?y1:y0;
            y1:next=y1;
            
            y0:next=y?y1:y00;
            
            y00:next=y00;
            default:next=A;
        endcase
    always@(posedge clk)begin
        if(!resetn)state<=A;
    else state<=next;
        
    end
    assign f=(state==B0 || state==B1);
    assign g=(state==y_j || state==y1  ||(state==y0));
endmodule
