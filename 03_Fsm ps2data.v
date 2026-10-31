module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //
	parameter first=0;
    parameter second=1;
    parameter third=2;
    parameter waiting=3;
    reg [1:0]state,next_state;
    // State transition logic (combinational)
    always@(*)begin
        case(state)
            first:next_state=second;
            second:next_state=third;
            third:next_state=in[3]?first:waiting;
            waiting:next_state=in[3]?first:waiting;
            default:next_state=waiting;
        endcase
    end
    // State flip-flops (sequential)
    always@(posedge clk)begin
        if(reset)state<=waiting;
        else state<=next_state;
    end
    // Output logic
        always@(*)begin
            if(state==third)done=1;
            else begin 
                done=0;
            end
        end
    always@(posedge clk)begin
            case(state)
                waiting:out_bytes[23:16]<=in[3]?in[7:0]:out_bytes[23:16];
                first:out_bytes[15:8]<=in[7:0];
                second:out_bytes[7:0]<=in[7:0];
                third:out_bytes[23:16]<=in[3]?in[7:0]:out_bytes[23:16];
                default:out_bytes<=out_bytes;
                endcase
        end
endmodule
