module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //
    // FSM from fsm_ps2  
    reg [1:0] state, next;
    reg [23:0] out_buffer;
    parameter bit1=2'b00,bit2=2'b01,bit3=2'b10,out=2'b11;
    always @(*) begin
        case(state)
            bit1: begin
                if(in[3]) next=bit2;
                else next=bit1;
            end
            bit2: begin
                next=bit3;
            end
            bit3: begin
                next=out;
            end
            out: begin
                if(in[3]) next=bit2;
                else next=bit1;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=bit1;
        end
        else begin
            state<=next;
            case(state)
                bit1:out_buffer[23:16]<=in;
                bit2:out_buffer[15:8]<=in;
                bit3:out_buffer[7:0]<=in;
                out: begin
                    if(in[3]) out_buffer[23:16]<=in;
                end
            endcase
        end
    end
    
    assign done=(state==out);
    // New: Datapath to store incoming bytes.
    assign out_bytes=(state==out?out_buffer:24'b0);

endmodule
// REF //
//以下思路雖然同樣使用4個state描述 但是上面長時間在bit1狀態會不斷進行byte1寫入的動作
//                                   下面只在in[3]時執行byte1寫入 硬體設計更具優勢
//module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done
); 
    
    reg [1:0] state, next;
    reg [23:0] out_buffer;
    
    parameter empty=2'b00, bit1=2'b01, bit2=2'b10, bit3=2'b11;
    
    // 1. State transition logic (Combinational)
    always @(*) begin
        case(state)
            empty: begin
                if(in[3]) next = bit1;
                else      next = empty;
            end
            bit1: next = bit2;
            bit2: next = bit3;
            bit3: begin
                // 在輸出狀態同時判斷是否有連續封包 (Overlap)
                if(in[3]) next = bit1;
                else      next = empty;
            end
            default: next = empty; // 補上 default 避免 Latch
        endcase
    end
                    
    // 2. State flip-flops & Datapath (Sequential)
    always @(posedge clk) begin
        if(reset) begin
            state <= empty;
        end
        else begin
            state <= next;
            
            // 根據「當下」的狀態，決定如何截取輸入的 Byte
            case(state)
                empty: begin
                    if(in[3]) out_buffer[23:16] <= in; // 捕捉 Byte 1
                end
                bit1: begin
                    out_buffer[15:8] <= in;            // 捕捉 Byte 2
                end
                bit2: begin
                    out_buffer[7:0] <= in;             // 捕捉 Byte 3
                end
                bit3: begin
                    // 若有連續封包，在此處捕捉下一個封包的 Byte 1
                    if(in[3]) out_buffer[23:16] <= in; 
                end
            endcase
        end
    end
            
    // 3. Output logic
    assign done = (state == bit3);
    
    // 根據 HDLBits 習慣，未完成時輸出補 0 (若硬體無嚴格要求，可省略 ? 判斷)
    assign out_bytes = (state == bit3) ? out_buffer : 24'b0;

endmodule
