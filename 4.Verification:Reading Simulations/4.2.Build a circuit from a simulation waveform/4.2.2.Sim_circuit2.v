module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//
    
    assign q=(a+b+c+d)!=1 & (a+b+c+d)!=3;
        

endmodule
