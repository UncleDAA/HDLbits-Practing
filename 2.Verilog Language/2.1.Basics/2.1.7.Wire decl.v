`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
	wire out_ab;
    wire out_cd;
    assign out_ab= a&b;
    assign out_cd= c&d;
    assign out= out_ab || out_cd;
    assign out_n = !out;
endmodule
