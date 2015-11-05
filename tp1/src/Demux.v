module Demux (
    //01 unidade funcional x
    input       [4:0]   x_wb_regdest,
    input               x_wb_writereg,
    input       [31:0]  x_wb_wbvalue,
    //11 unidade funcional y
    input       [4:0]   y_wb_regdest,
    input               y_wb_writereg,
    input       [31:0]  y_wb_wbvalue,
    //10 unidade funcional m
    input       [4:0]   m_wb_regdest,
    input               m_wb_writereg,
    input       [31:0]  m_wb_wbvalue,
    //writeback
    output reg  [4:0]   ex_wb_regdest,
    output reg          ex_wb_writereg,
    output reg  [31:0]  ex_wb_wbvalue
    );

    always @(*) begin
        if(x_wb_writereg) begin
            ex_wb_regdest <= x_wb_regdest;
            ex_wb_writereg <= x_wb_writereg;
            ex_wb_wbvalue <= x_wb_wbvalue;
        end else if(m_wb_writereg) begin
            ex_wb_regdest <= m_wb_regdest;
            ex_wb_writereg <= m_wb_writereg;
            ex_wb_wbvalue <= m_wb_wbvalue;
        end else if(y_wb_writereg) begin
            ex_wb_regdest <= y_wb_regdest;
            ex_wb_writereg <= y_wb_writereg;
            ex_wb_wbvalue <= y_wb_wbvalue;
        end else begin
            ex_wb_regdest <= 5'b00000;
            ex_wb_writereg <= 0;
            ex_wb_wbvalue <= 32'h0000_0000;
        end
    end

endmodule

