module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //
    wire [7:0]mux_ab, mux_cd;
    mux2 mux0 ( sel[0],    a,    b, mux_ab );
    mux2 mux1 ( sel[0],    c,    d, mux_cd );
    mux2 mux2 ( sel[1], mux_ab, mux_cd,  out );

endmodule
