
module top_module(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    localparam IDLE    = 4'd0,
               START   = 4'd1,
               RECEIVE = 4'd2,
               JUDGE   = 4'd3,
               STOP    = 4'd4,
               WAIT    = 4'd5;

    reg [3:0] state, next;
    reg [3:0] i;
    reg [7:0] data;
    wire j;

    // State transition logic
    always @(*) begin
        case(state)
            IDLE:    next = in ? IDLE : START;
            START:   next = RECEIVE;

            RECEIVE: next = (i == 4'd8) ? JUDGE : RECEIVE;

            JUDGE: begin
                if(!in)
                    next = WAIT;
                else
                    next = j ? STOP : IDLE;
            end

            STOP:    next = in ? IDLE : START;
            WAIT:    next = in ? IDLE : WAIT;

            default: next = IDLE;
        endcase
    end

    // State and data registers
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            i <= 0;
            data <= 0;
        end
        else begin
            state <= next;

            case(state)
                START: begin
                    data[0] <= in;
                    i <= 1;
                end

                RECEIVE: begin
                    if(i < 8)
                        data[i] <= in;

                    i <= i + 1'b1;
                end

                default: begin
                    i <= 0;
                end
            endcase
        end
    end

    // Output
    assign done = (state == STOP);
    assign out_byte = data;

    // Parity checker
    parity a(
        .clk(clk),
        .reset(reset || state == IDLE ||
                      state == STOP || state == WAIT),
        .in(in),
        .odd(j)
    );

endmodule
