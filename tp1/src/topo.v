module topo (
    input  [3:0]   KEY,
	 input 	  CLOCK_50,
	 output [0:6]  HEX0,
    output [0:6]  HEX1,
	 output [0:6]  HEX2,
	 output [0:6]  HEX3,
	 output [0:6]  HEX4,
	 output [7:0]  LEDG
);

	 wire		[31:0] regout$0;// Valor contido no registrador 0.
	 wire		[31:0] regout$1;// Valor contido no registrador 1.
	 wire		[31:0] regout$2;// Valor contido no registrador 2.
	 wire		[31:0] regout$3;// Valor contido no registrador 3.
	 wire		[31:0] regout$4;// Valor contido no registrador 4.
	 reg		[31:0]      clk;// Novo sinal de clock. 
	 
	 assign LEDG[0] = clk[24];
	
	 displayDecoder DP7_0(.entrada(regout$0),.saida(HEX0));
	 displayDecoder DP7_1(.entrada(regout$1),.saida(HEX1));
	 displayDecoder DP7_2(.entrada(regout$2),.saida(HEX2));
	 displayDecoder DP7_3(.entrada(regout$3),.saida(HEX3));
	 displayDecoder DP7_4(.entrada(regout$4),.saida(HEX4));
	 
    Mips MIPS(.clock(clk[24]),.reset(KEY[2]),.regout$0(regout$0),.regout$1(regout$1),
				  .regout$2(regout$2),.regout$3(regout$3),.regout$4(regout$4));

	 always @(posedge CLOCK_50)begin
		clk <= clk + 1;
	 end
	 
endmodule
