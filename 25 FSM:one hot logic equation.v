module top_module(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,    // 10-bit one-hot current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
); //

    // You may use these parameters to access state bits using e.g., state[B2] instead of state[6].
    
        
    assign shift_ena=(state[4]||state[5]||state[6]||state[7]);
    assign counting=(state[8]);
    assign done=(state[9]);
    
        
    assign B3_next =(state[6]);
    assign S_next =(state[0]&&d==0)||(state[1]&&d==0)||(state[3]&&d==0)||(state[9]&&ack==1);
    assign Count_next=(state[7])||(state[8]&&done_counting==0);
    assign S1_next=(state[0]&&d==1);
    assign Wait_next=(state[9]&&ack==0)||(state[8]&&done_counting==1);
    // etc.

endmodule
