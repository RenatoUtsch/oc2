module Fetch (
    input                   clock,
    input                   reset,
    //Execute
    input                   ex_if_stall,
    //Decode
    output reg    [31:0]    if_id_nextpc,
    output reg    [31:0]    if_id_instruc,
    input                   id_if_selpcsource,
    input         [31:0]    id_if_rega,
    input         [31:0]    id_if_pcimd2ext,
    input         [31:0]    id_if_pcindex,
    input         [1:0]     id_if_selpctype
);

    wire [6:0] addr;
    wire wre;
    wire [31:0] data;

    Ram RAM(.addr(addr),.data(data),.wre(wre),.flag(1'b1), .reset(reset));

    reg    [31:0]   pc;

    assign addr = pc[6:0];
    assign wre = 1'b1; // The fetch state always reads.

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            if_id_instruc <= 32'h0000_0000;
            pc <= 32'h0000_0000;
				if_id_nextpc <= 32'h0000_0000;
        end else begin
            if (ex_if_stall) begin
                if_id_instruc <= 32'h0000_0000;
                if_id_nextpc <= pc;
            end else begin
                if_id_instruc <= data;
                if (id_if_selpcsource) begin
                    case (id_if_selpctype)
                        2'b00: pc <= id_if_pcimd2ext;
                        2'b01: pc <= id_if_rega;
                        2'b10: pc <= id_if_pcindex;
                        2'b11: pc <= 32'h0000_0040;
                        default: pc <= 32'hXXXX_XXXX;
                    endcase
                    case (id_if_selpctype)
                        2'b00: if_id_nextpc <= id_if_pcimd2ext;
                        2'b01: if_id_nextpc <= id_if_rega;
                        2'b10: if_id_nextpc <= id_if_pcindex;
                        2'b11: if_id_nextpc <= 32'h0000_0040;
						default: if_id_nextpc <= 32'hXXXX_XXXX;
                        //default: pc <= 32'hXXXX_XXXX;
                    endcase
                end else begin
						  pc <= pc + 32'h0000_0001;
						  if_id_nextpc = pc + 1;
                end
            end
        end
    end

endmodule
