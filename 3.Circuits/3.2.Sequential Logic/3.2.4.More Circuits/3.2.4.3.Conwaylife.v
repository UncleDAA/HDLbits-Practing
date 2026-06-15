module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
    logic [15:0][15:0] q_buffer,q_output;
    logic [16:-1][16:-1] q_expand;
    assign q_buffer=q;
    always @(*) begin
        // 內部
        for(int i=0;i<16;i++) begin
            for(int j=0;j<16;j++) begin
                q_expand[i][j]=q_buffer[i][j];
            end
        end
        // 上下界 & 左右邊
        for(int i=0;i<16;i++) begin
            q_expand[-1][i]=q_buffer[15][i];
            q_expand[16][i]=q_buffer[0][i];
            q_expand[i][-1]=q_buffer[i][15];
            q_expand[i][16]=q_buffer[i][0];
        end
        // 角落
        q_expand[-1][-1]=q_buffer[15][15];
        q_expand[-1][16]=q_buffer[15][0];
        q_expand[16][-1]=q_buffer[0][15];
        q_expand[16][16]=q_buffer[0][0];
        // 計算q_output
        for(int i=0;i<16;i++) begin
            for(int j=0;j<16;j++) begin
                int sum;
                sum=q_expand[i-1][j-1]+q_expand[i-1][j]+q_expand[i-1][j+1]
                +q_expand[i][j-1]                   +q_expand[i][j+1]
                +q_expand[i+1][j-1]+q_expand[i+1][j]+q_expand[i+1][j+1];
                case(sum)
                    0:q_output[i][j]=0;
                    1:q_output[i][j]=0;
                    2:q_output[i][j]=q_buffer[i][j];
                    3:q_output[i][j]=1;
                    default:q_output[i][j]=0;
                endcase
            end
        end                
    end
    always @(posedge clk) begin
        if(load) begin
            q<=data;
        end
        else begin
            q<=q_output;
        end
    end
        
endmodule

// REF //
// logic是systemverilog提供的功能可以同時充當wire以及reg的腳色
// always_comb/always_ff對應回來跟always @(*) / always @(posedge )是一樣的
// 讓不同的通能在不同的組合邏輯中進行是管線化的設計思維 可以學習方便專案管理
module top_module(
    input clk,
    input load,
    input [255:0] data,
    output logic [255:0] q
);

    // 1. 宣告 2D 陣列 (16x16 核心 與 18x18 擴充邊界)
    logic [15:0][15:0] q_2d, next_q_2d;
    logic [17:0][17:0] pad_q;

    // 將一維 256-bit 輸出入直接映射為 16x16 的二維視角
    assign q_2d = q;

    // 2. 組合邏輯：建立帶有「環形邊界」的 18x18 矩陣
    always_comb begin
        // 處理中間 16 列的左右邊界拼接
        for (int i = 0; i < 16; i++) begin
            // {左邊界(接最右bit0), 中間16bits, 右邊界(接最左bit15)}
            pad_q[i+1] = {q_2d[i][0], q_2d[i][15:0], q_2d[i][15]};
        end
        // 處理上下邊界 (把做好的第1列與第16列直接複製，四個角落會自動對齊！)
        pad_q[0]  = pad_q[16]; 
        pad_q[17] = pad_q[1];  
    end

    // 3. 組合邏輯：計算每個細胞周圍的鄰居數量與下一代狀態
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                // 使用整數(int)來計算鄰居數量，避免 1-bit 加法發生溢位(Overflow)
                // 注意：q_2d[i][j] 在擴充矩陣中對應的位置是 pad_q[i+1][j+1]
                int neighbors;
                neighbors = pad_q[i][j]   + pad_q[i][j+1]   + pad_q[i][j+2] +
                            pad_q[i+1][j]                   + pad_q[i+1][j+2] +
                            pad_q[i+2][j] + pad_q[i+2][j+1] + pad_q[i+2][j+2];
                
                // 套用 Game of Life 規則
                if (neighbors == 2)
                    next_q_2d[i][j] = q_2d[i][j]; // 2個鄰居：保持現狀
                else if (neighbors == 3)
                    next_q_2d[i][j] = 1'b1;       // 3個鄰居：誕生(活著)
                else
                    next_q_2d[i][j] = 1'b0;       // 其他：死亡(孤單或擁擠)
            end
        end
    end

    // 4. 循序邏輯：時脈更新
    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_2d; // 直接把算好的 16x16 二維陣列塞回一維的 q
    end

endmodule
