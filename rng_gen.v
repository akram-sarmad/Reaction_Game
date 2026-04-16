module rng_gen(
    input  clk,
    input  rst,
    input  rng_gen,
    output reg [3:0] random_num
);

    // 4-bit LFSR register
    reg [3:0] lfsr;

    // Feedback for maximal-length 4-bit LFSR (x^4 + x^3 + 1)
    wire feedback = lfsr[3] ^ lfsr[2];

    always @(posedge clk) begin
        if (!rst) begin
            random_num <= 4'b0000;   // keep your original output reset
            lfsr       <= 4'b1101;   // seed matches your original b3 b2 b1 b0
        end 
        else if (rng_gen) begin
            // Shift LFSR
            lfsr[3] <= lfsr[2];
				lfsr[2] <= lfsr[1];
				lfsr[1] <= lfsr[0];
				lfsr[0] <= feedback;

            // Output new random number
            random_num <= lfsr;
        end
    end

endmodule


/*module rng_gen(
    input  clk,
    input  rst,
    input  rng_gen,
    output reg [3:0] random_num
);

    reg b0, b1, b2, b3;

    always @(posedge clk) begin
        if (!rst) begin
            random_num <= 4'b0000;
            b0 <= 1'b1;
            b1 <= 1'b0;
            b2 <= 1'b1;
            b3 <= 1'b1;
        end 
        else if (rng_gen) begin
            b0 <= b3 ^ b2;
            b1 <= b0;
            b2 <= b1;
            b3 <= b2;

            random_num[0] <= b0;
            random_num[1] <= b1;
            random_num[2] <= b2;
            random_num[3] <= b3;
        end
    end

endmodule
*/