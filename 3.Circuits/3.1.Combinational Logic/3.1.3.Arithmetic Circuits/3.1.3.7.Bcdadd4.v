module top_module ( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    wire out1,out2,out3;
    bcd_fadd(a[3:0],b[3:0],cin,out1,sum[3:0]);
    bcd_fadd(a[7:4],b[7:4],out1,out2,sum[7:4]);
    bcd_fadd(a[11:8],b[11:8],out2,out3,sum[11:8]);
    bcd_fadd(a[15:12],b[15:12],out3,cout,sum[15:12]);
endmodule
