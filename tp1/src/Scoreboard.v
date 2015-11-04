module Scoreboard(
	input 		   	clock,
	input 		   	reset,
	input	[4:0] 	reg_addr,
	input [1:0]    func_uni,
	input					  wre,
	output [31:0]	 pnd_sgn
);

	/* O SCOREBOARD SERA DIVIDO EM TRES TABELAS. A PRIMEIRA PARTE FICA
	** RESPONSAVEL POR INFORMAR SE UM REGISTRADOR ESTÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â PENDENTE, A SEGUNDA
	** EM QUAL UNIDADE FUNCIONAL ESTÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â E A TERCEITA RESPONSAVEL POR MOSTRAR
	** EM QUAL ESTÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚ÂGIO DE EXECUÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢O ELE ESTÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â.                           */

	reg [31:0]	     pnd_table;
	reg [1:0] fun_table [31:0];
	reg [5:0] pth_table [31:0];
	reg [5:0] 			       i;
	reg [5:0]					 j;

	assign pnd_sgn = pnd_table;
	
	always @(reset or reg_addr or clock) begin
		/* Marcando o registrador como pendente e identificando em qual unid.
		** funcional ele estarÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡.														 */
		if(!wre) begin
			fun_table[reg_addr] <=  func_uni;
			pnd_table[reg_addr] <= 		 1'b1; 
			pth_table[reg_addr] <= 6'b100000;
		end			
		// Em caso de reset, zerar todas as tabelas.
		if(!reset) begin
			for(i = 0; i < 32; i = i + 1) begin 
				pnd_table[i] <=      1'b0;
				fun_table[i] <= 	  2'b00;
				pth_table[i] <= 6'b000000;
			end
		end else if(clock) begin
			for(j = 0; j < 32; j = j + 1) begin
				pth_table[j] = pth_table[j] >> 1;
				pnd_table[j] = pnd_table[j] ^ pth_table[j][0];	
			end
		end
		
	end
	
endmodule
