module top_module (
    input [3:0] x,
    input [3:0] y, 
    output [4:0] sum);
    wire [3:0] carry;
    genvar i;
    generate
        fadd(x[0],y[0],0,carry[0],sum[0]);
        for(i=1;i<4;i++) begin:fadd
            fadd(
                .a(x[i]),
                .b(y[i]),
                .cin(carry[i-1]),
                .cout(carry[i]),
                .sum(sum[i]));
        end
        assign sum[4]=carry[3];
    endgenerate
endmodule
module fadd( 
    input a, b, cin,
    output cout, sum );
    assign sum=a+b+cin;
    assign cout=((a|b)&cin)|a&b;

endmodule

// REf //
module top_module (
	input [3:0] x,
	input [3:0] y,
	output [4:0] sum
);

	// This circuit is a 4-bit ripple-carry adder with carry-out.
	assign sum = x+y;	// Verilog addition automatically produces the carry-out bit.

	// Verilog quirk: Even though the value of (x+y) includes the carry-out, (x+y) is still considered to be a 4-bit number (The max width of the two operands).
	// This is correct:
	// assign sum = (x+y);
	// But this is incorrect:
	// assign sum = {x+y};	// Concatenation operator: This discards the carry-out
endmodule
