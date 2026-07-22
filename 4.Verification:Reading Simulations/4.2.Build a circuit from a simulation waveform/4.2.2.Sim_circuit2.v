module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//
    
    assign q=(a+b+c+d)!=1 & (a+b+c+d)!=3;
        

endmodule

// REF //
  cd 00 01 11 10
ab    

00    1  0  1  0

01    0  1  0  1

11    0  1  0  1

10    1  0  1  0

