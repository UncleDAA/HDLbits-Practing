module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss);
    reg [2:0] plus_time; //進位子
    // assign plus_time[1] = ss == 8'd59;
    // 8'd59 vs. 8'h59 :
    // 8'd59是十進位的59
    // 8'h59是十六進位的59 視作用4bits紀錄5 跟用4bits紀錄9 表達回十進位並非10
    assign plus_time[0] = ss == 8'h59 & ena;
    assign plus_time[1] = mm == 8'h59 & plus_time[0] & ena;
    assign plus_time[2] = hh == 8'h11 & plus_time[1] & ena;
    count60 count_ss(clk,reset,ena,ss); //計秒
    count60 count_mm(clk,reset,plus_time[0],mm); //計分
    count12 count_hh(clk,reset,plus_time[1],hh); //計時
    always @(posedge clk) begin
        if(plus_time[2])
            pm<=~pm;
    end
            
endmodule

module count60 (
    input clk,
    input reset,        // Synchronous active-high reset
    input ena,
    output [7:0] q);
    always @(posedge clk) begin
        if(ena) begin
            if(q[7:0] == 8'h59)
                q[7:0] <= 8'h0;
            else begin
                if(q[3:0] == 4'h9) begin
                    q[7:4] <= q[7:4] + 4'd1;
                    q[3:0] <= 8'h0;
                end
                else
                    q[3:0] <= q[3:0] + 4'd1;
            end 
        end
        if(reset)
            q <= 8'd0;        
    end
endmodule
        
module count12 (
    input clk,
    input reset,        // Synchronous active-high reset
    input ena,
    output [7:0] q);
    always @(posedge clk) begin
        if(ena) begin
            if(q[7:0]==8'h12) begin
                q[7:0]=8'h1;
            end
            else begin
                if(q[3:0]==4'd9) begin
                    q[7:4] <= 4'd1;
                    q[3:0] <= 4'd0;
                end
                else
                    q[3:0] <= q[3:0] + 4'd1;
            end
        end
        if(reset)
            q <= 8'h12;        
    end
endmodule        
