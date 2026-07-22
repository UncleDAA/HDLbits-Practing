module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = (a|b)&(c|d); // Fix me

endmodule

// REF //
  cd 00 01 11 10
ab    

00    0  0  0  0

01    0  1  1  1

11    0  1  1  1

10    0  1  1  1
