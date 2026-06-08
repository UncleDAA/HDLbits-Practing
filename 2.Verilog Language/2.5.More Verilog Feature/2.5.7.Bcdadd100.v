module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    wire [99:0] carry;
    bcd_fadd(a[3:0],b[3:0],cin,carry[3:0],sum[3:0]);
    genvar i;
    generate
        for(i=1;i<100;i++) begin:bcd_add
            bcd_fadd(
                .a(a[4*i+3:4*i]),
                .b(b[4*i+3:4*i]),
                .cin(carry[i-1]),
                .cout(carry[i]),
                .sum(sum[4*i+3:4*i]));
        end
    endgenerate
    assign cout=carry[99];
endmodule
