module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );
    always@(*) begin
        if(state==0) q = a^b;
    else q = ~(a^b);
end
    always@(posedge clk)begin
        state<=state?(a|b):(a&b); 
    end

endmodule
