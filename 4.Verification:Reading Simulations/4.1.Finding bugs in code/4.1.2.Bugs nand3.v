module top_module (input a, input b, input c, output out);//

    reg OUT;
    andgate inst1 (OUT,a, b, c,1,1);
    assign out=!OUT;

endmodule
