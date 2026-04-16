module countTo100(
    input clk,
    input rst,
    input enable,
    output reg timeout
);

    reg [6:0] count;  // 0–99

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            timeout <= 0;
        end else if (enable) begin
            if (count == 99) begin
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



