module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    assign Y1=(w==1 && y[0]==1);
    assign Y3=w?0:(y[1]==1 || y[2]==1 || y[4]==1 || y[5]==1);

endmodule
