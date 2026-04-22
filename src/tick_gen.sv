module tick_gen #(
    parameter int CLK_HZ    = 25_000_000,
    parameter int PERIOD_MS = 50
) (
    input  logic clk,
    output logic tick
);
    localparam int TICK_COUNT = (CLK_HZ / 1000) * PERIOD_MS - 1;
    localparam int CNT_WIDTH  = $clog2(TICK_COUNT + 1);

    logic [CNT_WIDTH-1:0] cnt  = '0;
    logic tick_reg = 1'b0;

    always_ff @(posedge clk) begin
        if (cnt == TICK_COUNT) begin
            cnt  <= '0;
            tick_reg <= 1'b1;
        end else begin
            cnt  <= cnt + 1'b1;
            tick_reg <= 1'b0;
        end
    end

    assign tick = tick_reg;
endmodule