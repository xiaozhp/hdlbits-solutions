module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    parameter LEFT=0;
    parameter RIGHT=1;
    parameter DIG_LEFT=2;
    parameter DIG_RIGHT=3;
    parameter DROP_LEFT=4;
    parameter DROP_RIGHT=5;
    parameter DIE=6;
    integer height=0;
    reg [2:0]state,next_state;
    always@(*)begin
        case(state)
            LEFT:next_state=ground?(dig?DIG_LEFT:(bump_left?RIGHT:LEFT)):DROP_LEFT;
            RIGHT:next_state=ground?(dig?DIG_RIGHT:(bump_right?LEFT:RIGHT)):DROP_RIGHT;
            DIG_LEFT:next_state=ground?DIG_LEFT:DROP_LEFT;
            DIG_RIGHT:next_state=ground?DIG_RIGHT:DROP_RIGHT;
            DROP_LEFT:next_state=ground?(height>=20?DIE:LEFT):DROP_LEFT;
            DROP_RIGHT:next_state=ground?(height>=20?DIE:RIGHT):DROP_RIGHT;//when ground=1 anddig=1,don't turn into digging!!!
            DIE:next_state=DIE;
            default:next_state=LEFT;
        endcase
       
    end

    always@(posedge clk or posedge areset)begin
        if(areset)begin 
            state<=LEFT; 
            height<=0;
        end
        else 
            begin
            state<=next_state;
        if((state==DROP_RIGHT || state==DROP_LEFT) && height<20)height<=height+1;
        else if((state!=DROP_RIGHT && state!=DROP_LEFT)  && height<20)height<=0;
        else height<=20;
            end
    end
    
    always@(*)begin
        case(state)
           LEFT:begin
              walk_left=1;
               walk_right=0;
               aaah=0;
               digging=0;
           end
            RIGHT:begin
              walk_left=0;
               walk_right=1;
               aaah=0;
               digging=0;
           end
            DIG_RIGHT:begin
              walk_left=0;
               walk_right=0;
               aaah=0;
               digging=1;
           end
            DIG_LEFT:begin
              walk_left=0;
               walk_right=0;
               aaah=0;
               digging=1;
           end
            DROP_LEFT:begin
              walk_left=0;
               walk_right=0;
               aaah=1;
               digging=0;
           end
            DROP_RIGHT:begin
              walk_left=0;
               walk_right=0;
               aaah=1;
               digging=0;
           end
            DIE:begin
              walk_left=0;
               walk_right=0;
               aaah=0;
               digging=0;
           end
            default:begin
              walk_left=0;
               walk_right=0;
               aaah=0;
               digging=0;
           end
        endcase
    end
endmodule
