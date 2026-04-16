module lfsr_1ms_timer (
    input  wire clk,
    input  wire rst,
    input  wire enable,
    output reg  timeout,
    output reg [15:0] lfsr_value
);

    // 16-bit maximal-length LFSR taps
    wire feedback;
    assign feedback = lfsr_value[15] ^ lfsr_value[13] ^ lfsr_value[12] ^ lfsr_value[10];

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            lfsr_value <= 16'hACE1;   // starting
            timeout    <= 1'b0;
        end 
        else begin
            timeout <= 1'b0;

            if (enable) begin
                // SHIFT 
                lfsr_value[15] <= lfsr_value[14];
                lfsr_value[14] <= lfsr_value[13];
                lfsr_value[13] <= lfsr_value[12];
                lfsr_value[12] <= lfsr_value[11];
                lfsr_value[11] <= lfsr_value[10];
                lfsr_value[10] <= lfsr_value[9];
                lfsr_value[9]  <= lfsr_value[8];
                lfsr_value[8]  <= lfsr_value[7];
                lfsr_value[7]  <= lfsr_value[6];
                lfsr_value[6]  <= lfsr_value[5];
                lfsr_value[5]  <= lfsr_value[4];
                lfsr_value[4]  <= lfsr_value[3];
                lfsr_value[3]  <= lfsr_value[2];
                lfsr_value[2]  <= lfsr_value[1];
                lfsr_value[1]  <= lfsr_value[0];
                lfsr_value[0]  <= feedback;

                //Timeout at EF5A
                if (lfsr_value == 16'hEF5A) begin
                    timeout    <= 1'b1;
                    lfsr_value <= 16'hACE1;   // reset LFSR every timeout
                end
            end
        end
    end

endmodule
