module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
    wire [99:0] carry;
    genvar i;
    generate
        fadd(a[0],b[0],cin,carry[0],sum[0]);
        for(i=1;i<100;i++) begin:fadd
            fadd(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .cout(carry[i]),
                .sum(sum[i]));
        end
        assign cout=carry[99];
    endgenerate
endmodule
module fadd( 
    input a, b, cin,
    output cout, sum );
    assign sum=a+b+cin;
    assign cout=((a|b)&cin)|a&b;

endmodule

// REF //
module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
    
    assign {cout,sum} = a+b+cin;

endmodule
