module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    always @(*) begin
        if(a==0 & b==1 & c==0 & d==0)
            out=d;
        else
            out=(a&~c&~d)|c&(~b|a);
    end
            
endmodule
