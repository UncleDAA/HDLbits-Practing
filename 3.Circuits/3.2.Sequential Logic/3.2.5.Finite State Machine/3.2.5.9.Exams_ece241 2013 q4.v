module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    reg [3:0] now,next;
    parameter low=4'b1111,s1_up=4'b0111,s1_dn=4'b0110,s2_up=4'b0011,s2_dn=4'b0010,high=4'b0000;
    
    always @(*) begin
        case(s)
            3'b000: begin
                next<=low;
            end
            3'b001: begin
                if(now==low) next=s1_dn;
                else if(now==s2_dn | now==s2_up) next=s1_up;
                else next=s1_up;
            end
            3'b011: begin
                if(now==s1_dn | now==s1_up) next=s2_dn;
                else if(now==high) next=s2_up;
                else next=s2_dn;
            end
            3'b111: begin
                next<=high;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if(reset)
            now<=low;
        else
            now<=next;
    end
    
    assign dfr=now[0];
    assign fr1=now[1];
    assign fr2=now[2];
    assign fr3=now[3];
endmodule
