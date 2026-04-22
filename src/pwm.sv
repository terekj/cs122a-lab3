module pwm #(
    parameter int CLK_HZ = 25_000_000,
    parameter int PERIOD_MS = 100
) (
    input  logic clk,
    input  logic [7:0] duty_cycle,
    output logic pwm_out
);

    localparam int PERIOD_CYCLES = (CLK_HZ / 1_000) * PERIOD_MS;

    logic [$clog2(PERIOD_CYCLES)-1:0] cnt = '0;

    always_ff @(posedge clk) begin
        if (cnt == PERIOD_CYCLES - 1) cnt <= '0;
        else cnt <= cnt + 1'b1;
    end

    assign pwm_out = (cnt < (duty_cycle * PERIOD_CYCLES) / 100);

endmodule