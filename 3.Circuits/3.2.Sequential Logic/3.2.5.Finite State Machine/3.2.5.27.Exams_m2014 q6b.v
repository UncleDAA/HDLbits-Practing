module top_module (
    input [3:1] y,
    input w,
    output Y2);
	parameter A=3'b000,B=3'b001,C=3'b010,D=3'b011,E=3'b100,F=3'b101;
    reg [3:1] next;
    always @(*) begin
        case(y)
            A:next=w?A:B;
            B:next=w?D:C;
            C:next=w?D:E;
            D:next=w?A:F;
            E:next=w?D:E;
            F:next=w?D:C;
        endcase
    end
    assign Y2=next[2];
endmodule
