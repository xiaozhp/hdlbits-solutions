module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4);
    assign Y2=(w==0 && y[1]==1);
    assign Y4=w?(y[2]==1 || y[3]==1 || y[5]==1 || y[6]==1):0;

endmodule
