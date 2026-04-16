module oneSecondTimer(
    input clk,
    input rst,
    input enable,
    output timeout
);

    wire t1ms;
    wire t100;
    wire t10;

    lfsr_1ms_timer u1(clk, rst, enable, t1ms);
    countTo100 u2(clk, rst, t1ms, t100);
    countTo10  u3(clk, rst, t100, timeout);

endmodule

