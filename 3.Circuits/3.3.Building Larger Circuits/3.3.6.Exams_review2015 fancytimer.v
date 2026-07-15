module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    parameter SEARCH=0,SHIFT=1,COUNTING=2,DONE=3;
    reg [3:0]state,next;
    reg [3:0]search_buffer;
    reg [1:0]counter;
    reg [9:0]thousand_counter;
    // 這一段主要牽涉到counter的設計邏輯如下
	//  combinational circuit中看到的是變化前的counter 計算完成後處理sequential中+1的動作
	//  1.以counter為例:
    //	clock 1:counter=0 所以next=shift 將data加入count 結束後counter=1
	//	clock 2:counter=1 所以next=shift 將data加入count 結束後counter=2
	//	clock 3:counter=2 所以next=shift 將data加入count 結束後counter=3
	//	clock 4:counter=3 注意!!!!next=counting 將data加入count 結束後counter=4
	//  因為clock 4之後要進入COUTING state所以應以counter=3做判斷
	//  2.以thousand_counter為例:
	//  clock 1:counter=1000 執行目標動作 結束後counter=999
	//  clock 2:counter= 999 執行目標動作 結束後counter=998
	//  clock 3:counter= 998 執行目標動作 結束後counter=997
	      :
	//  clock 999:counter= 2 執行目標動作 結束後counter=1
	//  clock 1000:counter=1 執行目標動作 結束後counter=0
	//  在clock1000數到1000 要執行特殊動作 所以sequential中使用thousand_counter=1為條件
    always @(*) begin
        case(state)
            SEARCH: begin
                if({search_buffer[2:0],data}==4'b1101) next=SHIFT;
                else next=SEARCH;
            end
   			SHIFT: begin
                if(counter==2'b11) next=COUNTING;
                else next=SHIFT;
            end
            COUNTING: begin
                if(thousand_counter==1 & count==0) next=DONE;
                else next=COUNTING;
            end
            DONE: begin
                if(ack) next=SEARCH;
                else next=DONE;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=SEARCH;
            count<=0;
            search_buffer<=0;
            counter<=0;
            thousand_counter<=10'd1000;
        end
        else begin
            state<=next;
            case(state)
                SEARCH: search_buffer<={search_buffer[2:0],data};
                SHIFT: begin
                    count<={count[2:0],data};
                    counter<=counter+1;
                end
                COUNTING: begin
                    if(thousand_counter==1) begin
                        count<=count-1;
                        thousand_counter<=10'd1000;
                    end
                    else thousand_counter<=thousand_counter-1;
                end
                DONE: begin
                    count<=0;
                    search_buffer<=0;
                    counter<=0;
                    thousand_counter<=10'd1000;
                end
            endcase
        end
    end
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
	
endmodule

// REF //
// 此寫法最省硬體資源： 
// 雖然看起來狀態很多 但使用 One-Hot Encoding 合成
// FPGA 只需要 10 個正反器。
// 相比之下 Code 1 則需要 4 個狀態正反器 + 4 個移位正反器 + 2 個計數正反器 = 10 個正反器，加上還需要一堆額外的比較邏輯（加法器、數值比較器）
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    parameter SEARCH_1=0,SEARCH_11=1,SEARCH_110=2,SEARCH_1101=3,SHIFT_1=4,SHIFT_2=5,SHIFT_3=6,SHIFT_4=7,COUNTING=8,DONE=9;
    reg [3:0]state,next;
    reg [9:0]thousand_counter;
    
    always @(*) begin
        case(state)
            SEARCH_1: begin
                if(data) next=SEARCH_11;
                else next=SEARCH_1;
            end
            SEARCH_11: begin
                if(data) next=SEARCH_110;
                else next=SEARCH_1;
            end
            SEARCH_110: begin
                if(!data) next=SEARCH_1101;
                else next=SEARCH_110;
            end
            SEARCH_1101: begin
                if(data) next=SHIFT_1;
                else next=SEARCH_1;
            end
            SHIFT_1: next=SHIFT_2;
            SHIFT_2: next=SHIFT_3;
            SHIFT_3: next=SHIFT_4;
            SHIFT_4: next=COUNTING;
            COUNTING: begin
                if(thousand_counter==1 & count==0) next=DONE;
                else next=COUNTING;
            end
            DONE: begin
                if(ack) next=SEARCH_1;
                else next=DONE;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=SEARCH_1;
            thousand_counter<=10'd1000;
        end
        else begin
            state<=next;
            case(state)
                SHIFT_1:count[3]<=data;
                SHIFT_2:count[2]<=data;
                SHIFT_3:count[1]<=data;
                SHIFT_4:count[0]<=data;
                COUNTING: begin
                    if(thousand_counter==1) begin
                        count<=count-1;
                        thousand_counter<=10'd1000;
                    end
                    else thousand_counter<=thousand_counter-1;
                end
                DONE: thousand_counter<=10'd1000;
            endcase
        end
    end
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
	
endmodule
