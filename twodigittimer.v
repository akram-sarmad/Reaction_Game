module twodigittimer(
    input  wire clk,
    input  wire rst,
    input  wire timer_enable,
    input  wire timer_reconfig,

    output wire time_out,
    output reg  timer_done,
    output wire [3:0] tens_digit,
    output wire [3:0] units_digit
);

    wire one_sec_pulse;
    wire borrow_units;
    wire borrow_tens;
    wire unused1, unused2;

    // 1-second pulse generator
    oneSecondTimer T1(
        clk,
        rst,
        timer_enable,
        one_sec_pulse
    );

    // Freeze when timer reaches 00
    wire freeze = timer_done;
    reg gated_one_sec_pulse;
    reg gated_borrow_units;

    always @(*) begin
        if (freeze)
            gated_one_sec_pulse = 1'b0;
        else
            gated_one_sec_pulse = one_sec_pulse;

        if (freeze)
            gated_borrow_units = 1'b0;
        else
            gated_borrow_units = borrow_units;
    end


    digit_timer U1(
        gated_one_sec_pulse,  // borrowdn
        1'b0,                 // noborrowup
        clk,
        rst,
        timer_reconfig,       // reload/decrement trigger
        borrow_units,         // borrowup
        unused1,              // noborrowdn
        units_digit           // digit
    );


    digit_timer U2(
        gated_borrow_units,   // borrowdn
        1'b0,                 // noborrowup
        clk,
        rst,
        timer_reconfig,
        borrow_tens,          // borrowup
        unused2,              // noborrowdn
        tens_digit            // digit
    );

    assign time_out = borrow_tens;

    //timer done
    always @(posedge clk) begin
        if (!rst)
            timer_done <= 1'b0;
        else
            timer_done <= (tens_digit == 4'd0 && units_digit == 4'd0);
    end

endmodule

