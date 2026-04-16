module timer_control_fsm(
    input  wire clk,
    input  wire rst,
    input  wire loggedin,
    input  wire loadp1_in,
    input  wire rng_in,
    input  wire timer_done,
    input  wire timer_reconfig_in,

    output reg loadp1_out,
    output reg timer_enable,
    output reg rng_gen,
    output reg timer_reconfig_out
);

always @(posedge clk) begin
    if (!rst) begin
        loadp1_out         <= 0;
        timer_enable       <= 0;
        rng_gen            <= 0;
        timer_reconfig_out <= 0;
    end else begin

        if (!loggedin) begin
            // Before login: everything off
            loadp1_out         <= 0;
            timer_enable       <= 0;
            rng_gen            <= 0;
            timer_reconfig_out <= 0;
        end else begin
            // After login: same logic as original PASS state

            loadp1_out         <= loadp1_in;
            rng_gen            <= 0;
            timer_reconfig_out <= 0;
            timer_enable       <= 0;

            if (timer_done && timer_reconfig_in) begin
                timer_reconfig_out <= 1;
                timer_enable       <= 1;
            end
            else if (!timer_done) begin
                timer_enable <= 1;
            end

            if (timer_done) begin
                loadp1_out <= 0;
                rng_gen    <= 0;
            end else begin
                if (rng_in)
                    rng_gen <= 1;
                else
                    rng_gen <= 0;
            end
        end
    end
end

endmodule
