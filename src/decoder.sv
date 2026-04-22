module decoder (
    input  logic  [3:0] bcd,
    output logic [6:0] seg7
);

    always_comb begin
        case (bcd)
            4'b0000: seg7 = 7'b1111110;
            4'b0001: seg7 = 7'b0110000;
            4'b0010: seg7 = 7'b1101101;
            4'b0011: seg7 = 7'b1111001;
            4'b0100: seg7 = 7'b0110011;
            4'b0101: seg7 = 7'b1011011;
            4'b0110: seg7 = 7'b1011111;
            4'b0111: seg7 = 7'b1110000;
            4'b1000: seg7 = 7'b1111111;
            4'b1001: seg7 = 7'b1111011;
            4'b1010: seg7 = 7'b1110111;
            4'b1011: seg7 = 7'b0011111;
            4'b1100: seg7 = 7'b1001110;
            4'b1101: seg7 = 7'b0111101;
            4'b1110: seg7 = 7'b1001111;
            4'b1111: seg7 = 7'b1000111;
            default: seg7 = 7'b0000000;
        endcase
    end
endmodule