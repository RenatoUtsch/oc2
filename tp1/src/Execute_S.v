module Execute_S (
    input               clock,
    input               reset,

    // Input
    input       [4:0]   in_regdest,
    input               in_writereg,
    input       [31:0]  in_wbvalue
    // Output
    output reg  [4:0]   out_regdest,
    output reg          out_writereg,
    output reg  [31:0]  out_wbvalue
);

always @(posedge clock or negedge reset) begin
    if(~reset) begin
        out_regdest <= 5'b00000;
        out_writereg <= 1'b0;
        out_wbvalue <= 32'h0000_0000;
    end else begin
        out_regdest <= in_regdest;
        out_writereg <= in_writereg;
        out_wbvalue <= in_wbvalue;
    end
end

endmodule
