module Lab4_MOHAMMED_sarmadakram(
    input  wire        clk,
    input  wire        rst,

    input  wire [3:0]  in_p1,
    input  wire        b_in_p1,

    input  wire [3:0]  in_pass,
    input  wire        b_in_pass,

    input  wire        b_in_rng,

    output reg  [6:0]  d_timer_tens,
    output reg  [6:0]  d_timer_units, 
    output reg  [6:0]  d_sum,
    output reg  [6:0]  d_rng,
    output reg  [6:0]  d_p1,
    output reg  [6:0]  d_score,

    output reg         LEDR0s,
    output reg         LEDR1s,
    output reg         LEDR9s,
    output reg         LEDR8s
);

    wire wb_p1;
    wire wb_pass;
    wire wb_rng;
    wire wb_reconfig;

    ButtonShaper bs_p1      (b_in_p1,   clk, wb_p1,      rst);
    ButtonShaper bs_pass    (b_in_pass, clk, wb_pass,    rst);
    ButtonShaper bs_rng     (b_in_rng,  clk, wb_rng,     rst);
    ButtonShaper bs_reconfig(b_in_pass, clk, wb_reconfig, rst);

    wire       loadp1_out;
    wire [3:0] x1;
    reg  [3:0] score;

    reg rng_ready;       
    reg round_active;    

    LoadRegister lr1(
        in_p1,
        x1,
        clk,
        rst,
        loadp1_out
    );

    wire        timer_enable;
    wire        timer_done;
    wire        timer_reconfig_out;
    wire        dummy_time_out;
    wire [3:0]  tens_digit;
    wire [3:0]  units_digit;


    wire        rng_gen_signal;
    wire [3:0]  random_number;
    wire [6:0]  wsum;

    wire [6:0]  wd_tens;
    wire [6:0]  wd_units;
    wire [6:0]  wd_rng;
    wire [6:0]  wd_p1;


    wire loggedout;
    wire loggedin;


timer_control_fsm TIMER_FSM (
    .clk(clk),
    .rst(rst),
    .loggedin(loggedin),
    .loadp1_in(wb_p1),
    .rng_in(wb_rng),
    .timer_done(timer_done),
    .timer_reconfig_in(wb_reconfig),

    .loadp1_out(loadp1_out),
    .timer_enable(timer_enable),
    .rng_gen(rng_gen_signal),
    .timer_reconfig_out(timer_reconfig_out)
);

	 game_access_fsm ACCESS_FSM (
    .clk(clk),
    .rst(rst),
    .b_in(wb_pass),
    .in(in_pass),
	 .log_out(wb_p1),
	 .timer_done(timer_done),
    .loggedout(loggedout),
    .loggedin(loggedin)
);


    rng_gen RNG(
        clk,
        rst,
        rng_gen_signal,
        random_number
    );

    twodigittimer timer(
        clk,
        rst,
        timer_enable,
        timer_reconfig_out,
        dummy_time_out,
        timer_done,
        tens_digit,
        units_digit
    );

    decoder dec_tens  (tens_digit,  wd_tens);
    decoder dec_units (units_digit, wd_units);
    decoder dec_rng   (random_number, wd_rng);
    decoder dec_p1    (x1, wd_p1);

    wire [3:0] score_units = score % 10;
    wire [3:0] score_tens  = score / 10;

    wire [6:0] wd_score_units;
    wire [6:0] wd_score_tens;

    decoder dec_score_units(score_units, wd_score_units);
    decoder dec_score_tens (score_tens,  wd_score_tens);

    adder add(
        x1,
        random_number,
        wsum
    );

    always @(posedge clk) begin
        if (!rst) begin
            d_timer_tens  <= 7'b1111111;
            d_timer_units <= 7'b1111111;
            d_sum         <= 7'b1111111;
            d_rng         <= 7'b1111111;
            d_p1          <= 7'b1111111;
            d_score       <= 7'b1111111;

            LEDR0s <= 0;
            LEDR1s <= 1;
            LEDR9s <= 1;
            LEDR8s <= 0;

            score        <= 0;
            rng_ready    <= 0;
            round_active <= 0;

        end else begin
            d_timer_tens  <= wd_tens;
            d_timer_units <= wd_units;

            LEDR1s <= loggedout;
            LEDR0s <= loggedin;

            if (wsum == 7'b0001110) begin
                LEDR9s <= 0;
                LEDR8s <= 1;
            end else begin
                LEDR9s <= 1;
                LEDR8s <= 0;
            end

            if (wb_rng) begin
                rng_ready    <= 1;
                round_active <= 0;
            end

            if (wb_p1 && rng_ready) begin
                round_active <= 1;
            end

            if (!timer_done) begin
                if (rng_ready && round_active && wsum == 7'b0001110) begin
                    score <= score + 1;
                    rng_ready <= 0;   
                end
            end

            if (timer_reconfig_out) begin
                score        <= 0;
                rng_ready    <= 0;
                round_active <= 0;
            end

            if (!timer_done) begin
                d_sum   <= wsum;            
                d_score <= 7'b1000000;      
            end else begin
                d_sum   <= wd_score_units;  
                d_score <= wd_score_tens;   
            end

            d_rng <= wd_rng;
            d_p1  <= wd_p1;

        end
    end

endmodule


