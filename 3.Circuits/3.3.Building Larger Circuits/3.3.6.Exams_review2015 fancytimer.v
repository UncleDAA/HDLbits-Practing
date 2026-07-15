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

