module Ram (
    input    [6:0]    addr,
    inout    [31:0]    data,
    input              wre,
	 input				  flag,	//memoria de dados/memoria de instrucoes
	 input 				  reset
);

    reg     [31:0]  memory    [0:127];
	 reg     [7:0] i;

    assign data[31:0] = wre ? memory[addr] : 32'hZZZZ_ZZZZ;

    always @(wre or addr or data or reset) begin
        if (!wre)
            memory[addr] = data[31:0];
				
			if(!reset) begin
				if(flag)begin			
				
					for (i = 8'b0000_0000; i < 128; i = i + 8'b00000001) begin
						memory[i] = 32'h0000_0000;
					end
					
					memory[0] = 32'b00000000000000000000000000000000;//nop
					memory[1] = 32'b001000_01001_01001_0000000000001010;//addi $t1,$t1,10
					memory[2] = 32'b001000_01010_01010_0000000000000101;//addi $t2,$t2,5
					memory[3] = 32'b00000000000000000000000000000000;//nop
					memory[4] = 32'b00000000000000000000000000000000;//nop
					memory[5] = 32'b00000000000000000000000000000000;//nop
					memory[6] = 32'b000000_01001_01010_01000_00000_100000;//add $t0,$t1,$t2 
					memory[7] = 32'b001000_01000_01000_0000000000001010;//addi $t0,$t0,10
				 /*memory[8] = 32'b00000000000010000100100000100000;
					memory[9] = 32'b00000000000000000000000000000000;
					memory[10] = 32'b00000000000000000000000000000000;
					memory[11] = 32'b00000000000000000000000000000000;///////////////////////////
					memory[12] = 32'b00000000000010000100100000100000;
					memory[13] = 32'b00000000000000000000000000000000;
					memory[14] = 32'b00000000000000000000000000000000;
					memory[15] = 32'b00000001000010010101000000100010;///////////////////////////
					memory[16] = 32'b10101100000010000000000000000000;
					memory[17] = 32'b00000000000000000000000000000000;
					memory[18] = 32'b00000000000000000000000000000000;
					memory[19] = 32'b00000000000000000000000000000000;///////////////////////////
					memory[20] = 32'b00000000000000000000000000000000;
					memory[21] = 32'b10001100000010110000000000000000;*/
					
					
				end
			end
    end

endmodule
