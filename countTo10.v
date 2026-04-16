module countTo10(
    input clk,
    input rst,
    input enable,
    output reg timeout
);

    reg [3:0] count;  // 0–9

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            timeout <= 0;
        end else if (enable) begin
            if (count == 9) begin
                count <= 0;
                timeout <= 1;
            end else begin
                count <= count + 1;
                timeout <= 0;
            end
        end else begin
            timeout <= 0;
        end
    end

endmodule



