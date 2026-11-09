module top_module (
    input clock,
    input a,
    output reg p,
    output reg q );
    always@(*)begin
        if(clock==1)p=a; 
    end
    always@(negedge clock)begin
       q<=p; 
    end
        

endmodule
