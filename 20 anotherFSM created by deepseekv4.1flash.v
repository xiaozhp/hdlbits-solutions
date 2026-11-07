module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
);
    localparam A    = 4'd0;  // 复位/起始
    localparam B    = 4'd1;  // f = 1，只保持一拍
    localparam C    = 4'd2;  // f 结束后才开始监视 x，等第一个 1
    localparam S1   = 4'd3;  // 已收到 1
    localparam S10  = 4'd4;  // 已收到 10
    localparam S101 = 4'd5;  // 已收到 101 -> g = 1，监视 y 第 1 拍
    localparam Y0   = 4'd6;  // y 第 1 拍为 0，g 仍为 1（第 2 拍）
    localparam GY   = 4'd7;  // y 出现过 1 -> g 永久为 1
    localparam GN   = 4'd8;  // 两拍都没有 y=1 -> g 永久为 0

    reg [3:0] state, next;

    always @(*) begin
        case (state)
            A   : next = B;               // 无条件下跳，不看 x
            B   : next = C;               // f 只保持一拍，无条件
            C   : next = x ? S1  : C;     // 从这一拍才开始采 x
            S1  : next = x ? S1  : S10;   // 连续 1 仍算作序列首位
            S10 : next = x ? S101 : C;    // 命中 101；收到 0 则重来
            S101: next = y ? GY  : Y0;    // y 监视第 1 拍
            Y0  : next = y ? GY  : GN;    // y 监视第 2 拍
            GY  : next = GY;              // g 永久 1（直到复位）
            GN  : next = GN;              // g 永久 0（直到复位）
            default: next = A;
        endcase
    end

    always @(posedge clk) begin
        if (!resetn) state <= A;          // 同步、低有效复位
        else         state <= next;
    end

    assign f = (state == B);
    assign g = (state == S101) || (state == Y0) || (state == GY);
endmodule
