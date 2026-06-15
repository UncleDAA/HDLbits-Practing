module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 
    always @(posedge clk) begin
        if(load) begin
            q<=data;
        end
        else begin
            q[0]<=0^q[1];
            q[511]<=0^q[510];
            for(int i=1;i<511;i++)
                q[i]<=q[i+1]^q[i-1];
          // 把「整個 q 往右移並補 0」與「整個 q 往左移並補 0」進行 XOR
          //  q <= {1'b0, q[511:1]} ^ {q[510:0], 1'b0};
        end
    end     
endmodule

// REF //
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 
    reg[512:-1] buffer;
    always @(posedge clk) begin
        buffer <= {1'b0,q,1'b0};
        if(load) begin
            q<=data;
        end
        else begin
            for(int i=0;i<512;i++)
              q[i]<=buffer[i+1]^buffer[i-1];
        end
      // 這個寫法有問題 可以理解為
      // always @(posedge clk) 發生時 會計算<= 右邊所有計算 再更新到<=左邊
      // 因此會讓q並不是用更新後的buffer去計算 依然使用舊的buffer從而慢一個clk
    end     
endmodule
