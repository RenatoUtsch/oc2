module Execute_Y (
    input               clock,
    input               reset,
    // Issue
    input       [31:0]  is_y_rega,
    input       [31:0]  is_y_regb,
    input       [4:0]   is_y_regdest,
    input               is_y_writereg,
    // Writeback
    output      [4:0]   y_wb_regdest,
    output              y_wb_writereg,
    output      [31:0]  y_wb_wbvalue
);

    Execute_Y0 e_Y0();
    Execute_Y1 e_Y1();
    Execute_Y2 e_Y2();
    Execute_Y3 e_Y3();

endmodule

module Execute_Y0 (

);



endmodule

module Execute_Y1 (

);



endmodule

module Execute_Y2 (

);



endmodule

module Execute_Y3 (

    // Output
    output      [4:0]   y3_y_regdest,
    output              y3_y_writereg,
    output      [31:0]  y3_y_wbvalue
);



endmodule
