module Ram (
    input    [6:0]    addr,
    inout    [31:0]    data,
    input              wre
);

    reg     [31:0]    memory    [0:127];

    assign data[31:0] = wre ? memory[addr>>2] : 32'hZZZZ_ZZZZ;

    always @(wre or addr or data) begin
        if (!wre)
            memory[addr>>2] = data[31:0];
    end

endmodule
