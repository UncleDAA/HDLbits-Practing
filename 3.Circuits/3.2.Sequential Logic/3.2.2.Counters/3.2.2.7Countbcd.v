module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    assign ena[1]= q[3:0] == 4'd9;
    assign ena[2]= (q[7:4] == 4'd9) & ena[1];
    assign ena[3]= (q[11:8] == 4'd9) & ena[2];
    count10 counter0(clk,reset,1,q[3:0]);
    count10 counter1(clk,reset,ena[1],q[7:4]);
    count10 counter2(clk,reset,ena[2],q[11:8]);
    count10 counter3(clk,reset,ena[3],q[15:12]);
endmodule

module count10 (
    input clk,
    input reset,        // Synchronous active-high reset
    input ena,
    output [3:0] q);
    always @(posedge clk) begin
        if(ena) begin
        	if(q[3:0] == 4'd9)
    			q <= 4'b0;
        	else
            	q <= q+1;
        end
        if(reset)
            q <= 4'b0;        
    end
endmodule

// REF // 
module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //

    wire [3:0] q0, q1, q2;
	assign OneHertz = {q0 == 4'd9 && q1 == 4'd9 && q2 == 4'd9};
    assign c_enable = {q1 == 4'd9 && q0 == 4'd9, q0 == 4'd9, 1'b1};
    
    
    bcdcount counter0 (clk, reset, c_enable[0], q0);
    bcdcount counter1 (clk, reset, c_enable[1], q1);
    bcdcount counter2 (clk, reset, c_enable[2], q2);
    
endmodule

// 比較我的以及參考寫法(3.2.2.6/3.2.2.7):
// 進位發生在本位以及前一位同時需要進位時
// 我用ena判斷前一位 參考直接使用前一個digit
