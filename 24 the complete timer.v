module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    
    reg [4:0]record;
    reg [9:0]i;
    wire shift_end,shift_ena,done_counting;
    complete_FSM B(
        .clk(clk),
        .reset(reset),
        .data(data),
        .shift_ena(shift_ena),
        .counting(counting),
        .done_counting(done_counting),
        .done(done),
        .shift_end(shift_end),
        .ack(ack));
    always@(posedge clk)begin
        if(reset||(ack&&done))begin
            i<=0;
            record<=1;
            
            
        end
        else if(shift_ena)begin
            i<=0; //应该左移还是右移？
            if(shift_end)record<={record[2:0],data}+1;
            else record<={record[2:0],data};//这里是不是不可以包含最后一次移位的count，毕竟是非阻塞赋值
        end
        else if(counting)begin
            if(record==0)begin
                record<=0;
            end
            else begin
                if(i==999)begin
                record<=record-1;
                i<=0;
            end
            else i<=i+1;
            end
        end
        
            
    end
    assign done_counting = (counting && (record == 1) && (i == 999));
    assign count = (record == 0) ? 4'b0 : (record[3:0] - 1);

endmodule
module complete_FSM (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output shift_end,
    output counting,
    input done_counting,
    output done,
    input ack );
    parameter   IDLE=2'd0,
    			COUNT=2'd1,
    			DONE=2'd2,
    			SHIFT1=3'd4,
    			SHIFT2=3'd5,
    			SHIFT3=3'd6;
    reg [2:0]state,next;
    wire i;
    
    shift_register A(
        .clk(clk),
        .reset(reset||(ack&&state==DONE)),
        .data(data),
        .start_shift(i));
    always@(*)
        case(state)
            IDLE:next=i?SHIFT1:IDLE;
            SHIFT1:next=SHIFT2;
            SHIFT2:next=SHIFT3;
            SHIFT3:next=COUNT;
            COUNT:next=done_counting?DONE:COUNT;
            DONE:next=ack?IDLE:DONE;
            default:next=IDLE;
        endcase
    always@(posedge clk)begin
        
        if(reset)begin
            state<=IDLE;
            
        end
    else begin
        state<=next;
        
    end
    end
    assign shift_ena=(state==SHIFT1||state==SHIFT2||state==SHIFT3||(state==IDLE&&i));
    assign counting=(state==COUNT);
    assign done=(state==DONE);
    assign shift_end=(state==SHIFT3);
	
endmodule
module shift_register(
	input clk,
    input reset,
    input data,
    output start_shift
);
    localparam IDLE=3'd0,
    			S1=3'd1,
    			S2=3'd2,
    			S3=3'd3,
    			S4=3'd4;
    reg [2:0]state,next;
    always@(*)
        case(state)
            IDLE:next=data?S1:IDLE;
            S1:next=data?S2:IDLE;
            S2:next=data?S2:S3;
            S3:next=data?S4:IDLE;
            S4:next=IDLE;
            default:next=IDLE;
                endcase
    always@(posedge clk)
        if(reset)state<=IDLE;
    	else state<=next;
    assign start_shift=(state==S4);
    
endmodule
