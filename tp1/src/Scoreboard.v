module Scoreboard(
	input 		   	clock,
	input 		   	reset,
	input	[4:0] 	reg_addr,
	input [1:0]    func_uni,
	input					  wre,
	output [31:0]	 pnd_sgn
);

	/* O SCOREBOARD SERA DIVIDO EM TRES TABELAS. A PRIMEIRA PARTE FICA
	** RESPONSAVEL POR INFORMAR SE UM REGISTRADOR ESTÁ PENDENTE, A SEGUNDA
	** EM QUAL UNIDADE FUNCIONAL ESTÁ E A TERCEITA RESPONSAVEL POR MOSTRAR
	** EM QUAL ESTÁGIO DE EXECUÇÃO ELE ESTÁ.                           */

	reg [31:0]	     pnd_table;
	reg [1:0] fun_table [31:0];
	reg [5:0] pth_table [31:0];
	reg [5:0] 			       i;
	reg [5:0]					 j;

	assign pnd_sgn = pnd_table;
	
	
	always @(negedge clock or negedge reset or negedge wre) begin
		/* Marcando o registrador como pendente e identificando em qual unid.
		** funcional ele estará.														 */
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

		end else begin
			/* Reliza o deslocamento para indicar em qual estágio um dado está e
			** retira o estado de pendente caso já tenha chegado no Writeback.*/
			for(j = 0; j < 32; j = j + 1) begin
				pth_table[j] = pth_table[j] >> 1;
				pnd_table[j] = pnd_table[j] ^ pth_table[j][0];
				
			end
			
		end
		
	end


endmodule