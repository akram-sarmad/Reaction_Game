module digit_timer(
    input  wire borrowdn,
    input  wire noborrowup,
    input  wire clk,
    input  wire rst,
    input  wire timer_reconfig,   
    output reg  borrowup,
    output reg  noborrowdn,
    output reg [3:0] digit
);

reg ctr;

    always @(posedge clk) begin
        if (!rst) begin
            digit      <= 4'd0;
            borrowup   <= 0;
            noborrowdn <= 0;
				
        end else begin
            borrowup   <= 0;
            noborrowdn <= 0;

            
            if (borrowdn || timer_reconfig) begin
                if (digit == 0) begin
                    digit    <= 4'd9;
                    borrowup <= 1;
                end else begin
                    digit <= digit - 1;
                end
            end

            else if (noborrowup) begin
                if (digit == 9) begin
                    digit      <= 4'd0;
                    noborrowdn <= 1;
                end else begin
                    digit <= digit + 1;
                end
            end
        end
    end

endmodule
