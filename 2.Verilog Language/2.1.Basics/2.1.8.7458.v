module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );
    // p1y
    wire or_one_abc;
    wire or_one_def;
    assign or_one_abc=p1a & p1b & p1c;
    assign or_one_def=p1d & p1e & p1f;
    assign p1y= or_one_abc || or_one_def;
    // p2y
	wire or_two_ab;
    wire or_two_cd;
    assign or_two_ab= p2a & p2b;
    assign or_two_cd= p2c & p2d;
    assign p2y= or_two_ab || or_two_cd;
endmodule
