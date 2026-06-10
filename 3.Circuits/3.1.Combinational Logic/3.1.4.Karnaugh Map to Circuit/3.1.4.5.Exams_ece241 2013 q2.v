module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    assign out_sop=(c&d)|(~a&~b&c);
    assign out_pos=c&(~b|~c|d)&(~a|~c|d);
endmodule

// POS 看1 : 組內用 & 串聯 不同組用 | 串聯
// SOP 看0 : 組內用 | 串聯 不同組用 & 串聯
