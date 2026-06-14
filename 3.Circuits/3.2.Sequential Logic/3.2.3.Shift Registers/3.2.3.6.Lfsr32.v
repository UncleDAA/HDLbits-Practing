module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 
    always @(posedge clk) begin
        if(reset) begin
            q<=32'h1;
        end
        else begin
            q[31]<=q[0]^0;
            for(int i=0;i<31;i++) begin
                if(i==0 | i==1 | i==21) begin
                    q[i]<=q[i+1]^q[0];
                end
            	else begin
                    q[i]<=q[i+1];
                end
            end
        end                   
    end        
endmodule

// REF //
module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 
    reg [31:0] q_next;

	always @(*) begin
        q_next = q[31:1];	// Shift all the bits. This is incorrect for q_next[4] and q_next[2]
        q_next[31] = q[0];	// Give q_next[4] and q_next[2] their correct assignments
        q_next[21] = q[22] ^ q[0];
        q_next[1] = q[2] ^ q[0];
        q_next[0] = q[1] ^ q[0];
	end
    
    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= q_next;
    end
    

endmodule
