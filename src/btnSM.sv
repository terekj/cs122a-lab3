module btnSM (
    input  logic       clk,
    input  logic       in,
    output logic [3:0] duty_cycle
);

    localparam int STABLE_CYCLES = 250_000;

    typedef enum logic { RELEASED, PRESSED } state_t;
    state_t state = RELEASED;

    logic [31:0] cnt  = '0;
    logic [3:0] duty = 4'd0;

    always @(posedge clk) begin
        case (state)
            RELEASED: begin
                if (in) begin`
                    if (cnt == STABLE_CYCLES - 1) begin
                        state = PRESSED;
                        cnt = '0;
                        if (duty == 4'd9) duty = 4'd0;
                        else duty = duty + 4'd1;
                    end else begin
                        cnt = cnt + 1'b1;
                    end
                end else begin
                    cnt = '0;
                end
            end

            PRESSED: begin
                if (!in) begin
                    if (cnt == STABLE_CYCLES - 1) begin
                        state = RELEASED;
                        cnt   = '0;
                    end else begin
                        cnt = cnt + 1'b1;
                    end
                end else begin
                    cnt = '0;
                end
            end

            default: state = RELEASED;
        endcase
    end

    assign duty_cycle = duty;

endmodule