module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    reg w1,w2,w3;
    always @(posedge clk) begin
        if(~resetn) begin
            w1 = 0;
            w2 = 0;
            w3 = 0;
            out = 0;

        end
        else begin
            w1<=in;
            w2<=w1;
            w3<=w2;
            out<=w3;
        end
    end
        
endmodule
//這個結構可以讓input在4個clock之後才輸出
// REF //
module top_module (
	input clk,
	input resetn,
	input in,
	output out
);

	reg [3:0] sr;
	
	// Create a shift register named sr. It shifts in "in".
	always @(posedge clk) begin
		if (~resetn)		// Synchronous active-low reset
			sr <= 0;
		else 
			sr <= {sr[2:0], in};
	end
	
	assign out = sr[3];		// Output the final bit (sr[3])

endmodule
