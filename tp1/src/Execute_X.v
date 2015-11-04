module Execute_X (
    input               clock,
    input               reset,
    // Issue
    input       [1:0]   is_x_functionalunit,
    input               is_x_selalushift,
    input               is_x_selimregb,
    input       [2:0]   is_x_aluop,
    input               is_x_unsig,
    input       [1:0]   is_x_shiftop,
    input       [4:0]   is_x_shiftamt,
    input       [31:0]  is_x_rega,
    input       [31:0]  is_x_regb,
    input       [31:0]  is_x_imedext,
    input       [4:0]   is_x_regdest,
    input               is_x_writereg,
    input               is_x_writeov,
    // Writeback
    output      [4:0]   x_wb_regdest,
    output              x_wb_writereg,
    output      [31:0]  x_wb_wbvalue
);

    wire            stall;
    wire            x0_x1_stall;
    wire    [4:0]   x0_x1_regdest;
    wire            x0_x1_writereg;
    wire    [31:0]  x0_x1_wbvalue;
    wire            x1_x2_stall;
    wire    [4:0]   x1_x2_regdest;
    wire            x1_x2_writereg;
    wire    [31:0]  x1_x2_wbvalue;
    wire            x2_x3_stall;
    wire    [4:0]   x2_x3_regdest;
    wire            x2_x3_writereg;
    wire    [31:0]  x2_x3_wbvalue;

    assign stall = (is_x_functionalunit == 1) ? 0 : 1;

    Execute_X0 e_X0(.clock(clock),.reset(reset),.x_x0_stall(stall),
        .x_x0_selalushift(is_x_selalushift),
        .x_x0_selimregb(is_x_selimregb),.x_x0_aluop(is_x_aluop),.x_x0_unsig(is_x_unsig),
        .x_x0_shiftop(is_x_shiftop),.x_x0_shiftamt(is_x_shiftamt),.x_x0_rega(is_x_rega),
        .x_x0_regb(is_x_regb),.x_x0_imedext(is_x_imedext),.x_x0_regdest(is_x_regdest),
        .x_x0_writereg(is_x_writereg),.x_x0_writeov(is_x_writeov),
        .x0_x1_stall(x0_x1_stall),.x0_x1_regdest(x0_x1_regdest),
        .x0_x1_writereg(x0_x1_writereg),.x0_x1_wbvalue(x0_x1_wbvalue));

    Execute_S e_X1(.clock(clock),.reset(reset),.in_stall(x0_x1_stall),
        .in_regdest(x0_x1_regdest),
        .in_writereg(x0_x1_writereg),.in_wbvalue(x0_x1_wbvalue),
        .out_stall(x1_x2_stall),
        .out_regdest(x1_x2_regdest),.out_writereg(x1_x2_writereg),
        .out_wbvalue(x1_x2_wbvalue));

    Execute_S e_X2(.clock(clock),.reset(reset),.in_stall(x1_x2_stall),
        .in_regdest(x1_x2_regdest),
        .in_writereg(x1_x2_writereg),.in_wbvalue(x1_x2_wbvalue),
        .out_stall(x2_x3_stall),
        .out_regdest(x2_x3_regdest),.out_writereg(x2_x3_writereg),
        .out_wbvalue(x2_x3_wbvalue));

    Execute_S e_X3(.clock(clock),.reset(reset),.in_stall(x2_x3_stall),
        .in_regdest(x2_x3_regdest),
        .in_writereg(x2_x3_writereg),.in_wbvalue(x2_x3_wbvalue),
        .out_regdest(x_wb_regdest),.out_writereg(x_wb_writereg),
        .out_wbvalue(x_wb_wbvalue));
endmodule

module Execute_X0 (
    input               clock,
    input               reset,
    // Input (issue)
    input               x_x0_stall,
    input               x_x0_selalushift,
    input               x_x0_selimregb,
    input       [2:0]   x_x0_aluop,
    input               x_x0_unsig,
    input       [1:0]   x_x0_shiftop,
    input       [4:0]   x_x0_shiftamt,
    input       [31:0]  x_x0_rega,
    input       [31:0]  x_x0_regb,
    input       [31:0]  x_x0_imedext,
    input       [4:0]   x_x0_regdest,
    input               x_x0_writereg,
    input               x_x0_writeov,
    // Output
    output reg          x0_x1_stall,
    output reg  [4:0]   x0_x1_regdest,
    output reg          x0_x1_writereg,
    output reg  [31:0]  x0_x1_wbvalue
);

    wire    [31:0]    aluout;
    wire              aluov;
    wire    [31:0]    result;
    wire    [31:0]    mux_imregb;

    assign mux_imregb = (x_x0_selimregb) ? x_x0_imedext : x_x0_regb;

    Alu ALU(.a(x_x0_rega),.b(mux_imregb),.aluout(aluout),.op(x_x0_aluop),
        .unsig(x_x0_unsig),.overflow(aluov));
    Shifter SHIFTER(.in(x_x0_regb),.shiftop(x_x0_shiftop),.shiftamt(x_x0_shiftamt),
        .result(result));

    always @(posedge clock or negedge reset) begin
        if (~reset|x_x0_stall) begin
            x0_x1_regdest <= 5'b00000;
            x0_x1_writereg <= 1'b0;
            x0_x1_wbvalue <= 32'h0000_0000;
            x0_x1_stall <= x_x0_stall;
        end else begin
            x0_x1_regdest <= x_x0_regdest;
            x0_x1_writereg <= (!aluov | x_x0_writeov) & x_x0_writereg;
            x0_x1_wbvalue <= (x_x0_selalushift) ? result : aluout;
            x0_x1_stall <= x_x0_stall;
        end
    end


endmodule

