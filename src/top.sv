`include "src/decoder.sv"
`include "src/pwm.sv"
`include "src/btnSM.sv"
module top (
    input logic clk,
    input logic dip,
    input logic btnR,
    input logic btnG,
    output logic [7:0] seg7,
    output logic Red,
    output logic Green
);


    logic [3:0] g_duty;
    logic [3:0] r_duty;

    // state machine stuff
    btnSM redSM(.clk(clk), .in(btnR), .duty_cycle(r_duty));
    btnSM greenSM(.clk(clk), .in(btnG), .duty_cycle(g_duty));

    logic [7:0] r_duty_as_percent;
    logic [7:0] g_duty_as_percent;
    assign r_duty_as_percent = r_duty * 8'd10;
    assign g_duty_as_percent = g_duty * 8'd10;

    pwm #(.CLK_HZ(25_000_000), .PERIOD_MS(1)) redPWM(.clk(clk), .duty_cycle(r_duty_as_percent), .pwm_out(Red));
    pwm #(.CLK_HZ(25_000_000), .PERIOD_MS(1)) greenPWM(.clk(clk), .duty_cycle(g_duty_as_percent), .pwm_out(Green));

    logic [3:0] disp_val;
    assign disp_val = dip ? g_duty : r_duty;

    decoder dec (
        .bcd  (disp_val),
        .seg7 (seg7[6:0])
    );

    assign seg7[7] = dip;

endmodule