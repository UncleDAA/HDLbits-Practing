// 解讀 //
// 在狀態B時input=1則維持狀態/input=0則轉換至狀態A 狀態B下輸出為1
// 在狀態A時input=1則維持狀態/input=0則轉換至狀態B 狀態A下輸出為1
module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        case(state)
            A: begin
                if(in) next_state<=A;
                else next_state<=B;
            end
            B: begin
                if(in) next_state<=B;
                else next_state<=A;
            end
        endcase
    end

    always @(posedge clk,posedge areset) begin    // This is a sequential always block
       if(areset) begin
            state<=B;
        end
        else begin
            state<=next_state;
        end
    end

    // Output logic
    // assign out = (state == ...);
	assign out= state ? 1:0;
endmodule

// REF //
module top_module (
	input clk,
	input in,
	input areset,
	output out
);

	// Give state names and assignments. I'm lazy, so I like to use decimal numbers.
	// It doesn't really matter what assignment is used, as long as they're unique.
	parameter A=0, B=1;
	reg state;		// Ensure state and next are big enough to hold the state encoding.
	reg next;
    
    
    // A finite state machine is usually coded in three parts:
    //   State transition logic
    //   State flip-flops
    //   Output logic
    // It is sometimes possible to combine one or more of these blobs of code
    // together, but be careful: Some blobs are combinational circuits, while some
    // are clocked (DFFs).
    
    
    // Combinational always block for state transition logic. Given the current state and inputs,
    // what should be next state be?
    // Combinational always block: Use blocking assignments.
    always@(*) begin
		case (state)
			A: next = in ? A : B;
			B: next = in ? B : A;
		endcase
    end
    
    
    
    // Edge-triggered always block (DFFs) for state flip-flops. Asynchronous reset.
    always @(posedge clk, posedge areset) begin
		if (areset) state <= B;		// Reset to state B
        else state <= next;			// Otherwise, cause the state to transition
	end
		
		
		
	// Combinational output logic. In this problem, an assign statement is the simplest.
	// In more complex circuits, a combinational always block may be more suitable.
	assign out = (state==B);

	
endmodule
