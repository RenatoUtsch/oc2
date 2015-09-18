module Ram (
    input    [8:0]    addr,
    inout    [31:0]    data,
    input              wre,
	 input				  flag	//memoria de dados/memoria de instruçoes
);

    reg     [31:0]  memory    [0:127];

    assign data[31:0] = wre ? memory[addr>>2] : 32'hZZZZ_ZZZZ;

    always @(wre or addr or data) begin
		  if(flag)begin
				memory[0] = 32'b00000000000000000000000000000000;
				memory[1] = 32'b00000000000000000000000000000000;
				memory[2] = 32'b00100000000100010000000000000001;///////////////////////////
				memory[3] = 32'b00000010001100011001000000100000;/////////////////////////////
		  end
        if (!wre)
            memory[addr>>2] = data[31:0];
    end

endmodule
