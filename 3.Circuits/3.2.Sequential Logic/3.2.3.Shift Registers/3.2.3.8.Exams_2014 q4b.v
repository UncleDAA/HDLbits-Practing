module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    MUXDFF DFF3(KEY[0], KEY[3],SW[3],KEY[1],KEY[2],LEDR[3]);
    MUXDFF DFF2(KEY[0],LEDR[3],SW[2],KEY[1],KEY[2],LEDR[2]);
    MUXDFF DFF1(KEY[0],LEDR[2],SW[1],KEY[1],KEY[2],LEDR[1]);
    MUXDFF DFF0(KEY[0],LEDR[1],SW[0],KEY[1],KEY[2],LEDR[0]);
endmodule
// 參考3.2.1.12 Exams_2014 q4a
module MUXDFF (
    input clk,
    input w, R, E, L,
    output Q
);
    wire multi1,multi2;
    assign multi1=E?w:Q;
    assign multi2=L?R:multi1;
    always @(posedge clk) begin
        Q=multi2;
    end
endmodule

// REF //
module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    wire [3:0] w_list;
    assign w_list={KEY[3],LEDR[3],LEDR[2],LEDR[1]};
    genvar i;
    generate
        for(i=0;i<4;i++) begin:DFF
            MUXDFF(.clk(KEY[0]),
                   .w(w_list[i]),
                   .R(SW[i]),
                   .E(KEY[1]),
                   .L(KEY[2]),
                   .Q(LEDR[i])
                  );
        end
    endgenerate
    /*   對照generate內容用     
    MUXDFF DFF3(KEY[0], KEY[3],SW[3],KEY[1],KEY[2],LEDR[3]);
    MUXDFF DFF2(KEY[0],LEDR[3],SW[2],KEY[1],KEY[2],LEDR[2]);
    MUXDFF DFF1(KEY[0],LEDR[2],SW[1],KEY[1],KEY[2],LEDR[1]);
    MUXDFF DFF0(KEY[0],LEDR[1],SW[0],KEY[1],KEY[2],LEDR[0]);
    */
endmodule
// 這是一個有趣的技巧 直接多接一條wire先把要用到input塞進去這樣 generate就變得簡便了~
