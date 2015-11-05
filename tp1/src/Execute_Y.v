module Execute_Y (
    input               clock,
    input               reset,
    // Issue
    input       [1:0]   is_y_functionalunit,
    input       [31:0]  is_y_rega,
    input       [31:0]  is_y_regb,
    input       [4:0]   is_y_regdest,
    // Writeback
    output      [4:0]   y_wb_regdest,
    output              y_wb_writereg,
    output      [31:0]  y_wb_wbvalue
);

    wire            stall;
    wire            y0_y1_stall;
    wire            y0_y1_positive;
    wire            y0_y1_zero;
    wire    [31:0]  y0_y1_rega;
    wire    [31:0]  y0_y1_regb;
    wire    [4:0]   y0_y1_regdest;
    wire            y1_y2_stall,
    wire            y1_y2_positive;
    wire            y1_y2_zero;
    wire    [31:0]  y1_y2_rega,
    wire    [31:0]  y1_y2_regb,
    wire    [4:0]   y1_y2_regdest,
    wire            y2_y3_stall,
    wire            y2_y3_positive;
    wire            y2_y3_zero;
    wire    [63:0]  y2_y3_result,
    wire    [4:0]   y2_y3_regdest,

    assign stall = (is_x_functionalunit == 3) ? 0 : 1;

    Execute_Y0 e_Y0(.clock(clock),.reset(reset),.y_y0_stall(stall),
        .y_y0_rega(is_y_rega),.y_y0_regb(is_y_regb),.y_y0_regdest(is_y_regdest),
        .y0_y1_stall(y0_y1_stall),.y0_y1_positive(y0_y1_positive),
        .y0_y1_zero(y0_y1_zero),.y0_y1_rega(y0_y1_rega),.y0_y1_regb(y0_y1_regb),
        .y0_y1_regdest(y0_y1_regdest));

    Execute_Y1 e_Y1(.clock(clock),.reset(reset),.y0_y1_stall(y0_y1_stall),
        .y0_y1_positive(y0_y1_positive),.y0_y1_zero(y0_y1_zero),
        .y0_y1_rega(y0_y1_rega),.y0_y1_regb(y0_y1_regb),
        .y0_y1_regdest(y0_y1_regdest),.y1_y2_stall(y1_y2_stall),
        .y1_y2_positive(y1_y2_positive),.y1_y2_zero(y1_y2_zero),
        .y1_y2_rega(y1_y2_rega),.y1_y2_regb(y1_y2_regb),
        .y1_y2_regdest(y1_y2_regdest));

    Execute_Y2 e_Y2(.clock(clock),.reset(reset),.y1_y2_stall(y1_y2_stall),
        .y1_y2_positive(y1_y2_positive),.y1_y2_zero(y1_y2_zero),
        .y1_y2_rega(y1_y2_rega),.y1_y2_regb(y1_y2_regb),
        .y1_y2_regdest(y1_y2_regdest),.y2_y3_stall(y2_y3_stall),
        .y2_y3_positive(y2_y3_positive),.y2_y3_zero(y2_y3_zero),
        .y2_y3_result(y2_y3_result),.y2_y3_regdest(y2_y3_regdest)));

    Execute_Y3 e_Y3(.clock(clock),.reset(reset),.y2_y3_stall(y2_y3_stall),
        .y2_y3_positive(y2_y3_positive),.y2_y3_zero(y2_y3_zer0),
        .y2_y3_result(y2_y3_result),.y2_y3_regdest(y2_y3_regdest),
        .y3_y_regdest(y_wb_regdest),.y3_y_writereg(y_wb_writereg),
        .y3_y_wbvalue(y_wb_wbvalue)));

endmodule

module Execute_Y0 (
    input               clock,
    input               reset,
    // Input
    input               y_y0_stall,
    input       [31:0]  y_y0_rega,
    input       [31:0]  y_y0_regb,
    input       [4:0]   y_y0_regdest,

    // Output
    output reg          y0_y1_stall,
    output reg          y0_y1_positive,
    output reg          y0_y1_zero,
    output reg  [31:0]  y0_y1_rega,
    output reg  [31:0]  y0_y1_regb,
    output reg  [4:0]   y0_y1_regdest
);

    always @(posedge clock or negedge reset) begin
        if(~reset or y_y0_stall) begin
            y0_y1_stall <= y_y0_stall;
            y0_y1_positive <= 0;
            y0_y1_zero <= 0;
            y0_y1_rega <= 32'h0000_0000;
            y0_y1_regb <= 32'h0000_0000;
            y0_y1_regdest <= 5'b00000;
        end else begin
            if(($signed(rega) > 32'sh0000_0000 && $signed(regb) > 32'sh0000_0000) ||
                    ($signed(rega) < 32'sh0000_0000 && $signed(regb) < 32'sh0000_0000))
                y0_y1_positive <= 1;
            else
                y0_y1_positive <= 0;

            y0_y1_zero <= (rega == 0 || regb == 0) ? 1 : 0;
            y0_y1_rega <= y_y0_rega;
            y0_y1_regb <= y_y0_regb;
            y0_y1_regdest <= y_y0_regdest;
            y0_y1_stall <= y_y0_stall;
        end
    end

endmodule

module Execute_Y1 (
    input               clock,
    input               reset,
    // Input
    input               y0_y1_stall,
    input               y0_y1_positive,
    input               y0_y1_zero,
    input       [31:0]  y0_y1_rega,
    input       [31:0]  y0_y1_regb,
    input       [4:0]   y0_y1_regdest,

    // Output
    output reg          y1_y2_stall,
    output reg          y1_y2_positive,
    output reg          y1_y2_zero,
    output reg  [31:0]  y1_y2_rega,
    output reg  [31:0]  y1_y2_regb,
    output reg  [4:0]   y1_y2_regdest
);

    always @(posedge clock or negedge reset) begin
        if(~reset or y0_y1_stall) begin
            y1_y2_stall <= y0_y1_stall;
            y1_y2_positive <= 0;
            y1_y2_zero <= 0;
            y1_y2_rega <= 32'h0000_0000;
            y1_y2_regb <= 32'h0000_0000;
            y1_y2_regdest <= 5'b00000;
        end else begin
            if($signed(y0_y1_rega) < 32'sh0000_0000)
                y1_y2_rega <= ~y0_y1_rega + 1; // Two's complement.
            if($signed(y0_y1_regb) < 32'sh0000_0000)
                y1_y2_regb <= ~y0_y1_regb + 1; // Two's complement.

            y1_y2_stall <= y0_y1_stall;
            y1_y2_positive <= y0_y1_positive;
            y1_y2_zero <= y0_y1_zero;
            y1_y2_regdest <= y0_y1_regdest;
        end
    end

endmodule

module Execute_Y2 (
    input               clock,
    input               reset,
    // Input
    input               y1_y2_stall,
    input               y1_y2_positive,
    input               y1_y2_zero,
    input       [31:0]  y1_y2_rega,
    input       [31:0]  y1_y2_regb,
    input       [4:0]   y1_y2_regdest,

    // Output
    output reg          y2_y3_stall,
    output reg          y2_y3_positive,
    output reg          y2_y3_zero,
    output reg  [63:0]  y2_y3_result,
    output reg  [4:0]   y2_y3_regdest,
);

    always @(posedge clock or negedge reset) begin
        if(~reset or y1_y2_stall) begin
            y2_y3_stall <= y1_y2_stall;
            y2_y3_positive <= 0;
            y2_y3_zero <= 0;
            y2_y3_result <= 64'h0000_0000_0000_0000;
            y2_y3_regdest <= 5'b00000;
        end else begin
            y2_y3_stall <= y1_y2_stall;
            y2_y3_positive <= y1_y2_positive;
            y2_y3_zero <= y1_y2_zero;
            y2_y3_result <= y1_y2_rega * y1_y2_regb;
            y2_y3_regdest <= y1_y2_regdest;
        end
    end

endmodule

module Execute_Y3 (

    input               y2_y3_stall,
    input               y2_y3_positive,
    input               y2_y3_zero,
    input       [63:0]  y2_y3_result,
    input       [4:0]   y2_y3_regdest,
    // Output
    output reg  [4:0]   y3_y_regdest,
    output reg          y3_y_writereg,
    output reg  [31:0]  y3_y_wbvalue
);

    always @(posedge clock or negedge reset) begin
        if(~reset or y2_y3_stall) begin
            y3_y_regdest <= 5'b00000;
            y3_y_writereg <= 0;
            y3_y_wbvalue <= 32'h0000_0000;
        end else begin
            y3_y_regdest <= y2_y3_regdest;
            y3_y_writereg <= (y2_y3_result[63:32] != 32'h0000_0000) ? 0 : 1; // Overflow.
            y3_y_wbvalue <= y2_y3_positive ? y2_y3_result[31:0] : ~y2_y3_result[31:0] + 1;
        end
    end

endmodule
