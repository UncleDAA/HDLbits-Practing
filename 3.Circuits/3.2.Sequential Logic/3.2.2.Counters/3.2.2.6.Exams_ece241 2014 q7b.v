module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //
    reg [3:0] Q1,Q2,Q3;
    bcdcount counter0 (clk, reset, c_enable[0],Q1);
    bcdcount counter1 (clk, reset, c_enable[1],Q2);
    bcdcount counter2 (clk, reset, c_enable[2],Q3);
    assign c_enable[0] = 1;
    assign c_enable[1] = Q1==4'd9;
    assign c_enable[2] = c_enable[1] & Q2==4'd9;    
    assign OneHertz= c_enable[2] & Q3 == 4'd9;
endmodule
