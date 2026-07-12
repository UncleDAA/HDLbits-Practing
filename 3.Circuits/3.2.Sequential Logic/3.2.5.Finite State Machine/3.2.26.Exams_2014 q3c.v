module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);
    parameter OOO=0,OOI=1,OIO=2,OII=3,IOO=4;
    reg OUT;
    always @(*) begin
        case(y)
            OOO: OUT=x?1:0;
            OOI: OUT=x?0:1;
            OIO: OUT=x?1:0;
            OII: OUT=x?0:1;
            IOO: OUT=x?0:1;
        endcase
    end
    assign Y0=OUT;
    assign z=(y==OII | y==IOO);
	
endmodule
