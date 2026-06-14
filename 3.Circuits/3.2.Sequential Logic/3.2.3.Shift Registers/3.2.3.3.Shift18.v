module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 
    always @(posedge clk) begin
        if(load) begin
            q <= data;
        end
        else if(ena) begin
            case(amount[1:0])
                2'b00:q<={q[62:0],1'b0};
                2'b01:q<={q[55:0],8'b0};
                2'b10:q<={q[63],q[63:1]};
                2'b11:q<={q[63],q[63],q[63],q[63],q[63],q[63],q[63],q[63],q[63:8]};
            endcase
        end
    end
endmodule
// 可以注意arithmetic right shift的行為不是單純補0 而是重複sign bits()


// REF //
2'b11:q<={8{q[63]},q[63:8]}; 這樣寫比較俐落
