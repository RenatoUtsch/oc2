module topo (
	 input[4:0]	 	 SW, // Switches
    input [3:0]   KEY,
	 output [0:6]  HEX0,
    output [0:6]  HEX1,
	 output [0:6]  HEX2,
	 output [0:6]  HEX3,
	 output [0:6]  HEX4,
	 output [0:6]  HEX5,
	 output [0:6]  HEX6,
	 output [0:6]  HEX7
);

	 wire		[4:0] addrout;
	 wire		[31:0] regout;
	 
	 reg [31:0] saida;  
	 
	 displayDecoder DP7_0(.entrada(saida[3:0]),.saida(HEX0));
	 displayDecoder DP7_1(.entrada(saida[7:4]),.saida(HEX1));
	 displayDecoder DP7_2(.entrada(saida[11:8]),.saida(HEX2));
	 displayDecoder DP7_3(.entrada(saida[15:12]),.saida(HEX3));
	 displayDecoder DP7_4(.entrada(saida[19:16]),.saida(HEX4));
	 displayDecoder DP7_5(.entrada(saida[23:20]),.saida(HEX5));
	 displayDecoder DP7_6(.entrada(saida[27:24]),.saida(HEX6));
	 displayDecoder DP7_7(.entrada(saida[31:28]),.saida(HEX7));
	 
	 always@(negedge KEY[1])begin
		saida = regout;
	 end
	
    Mips MIPS(.clock(KEY[3]),.reset(KEY[2]),.regout(regout),.addrout(addrout));

endmodule
