module Issue(
    input                   clock,
    input                   reset,
    //Decode
    input                   id_is_selalushift,
    input                   id_is_selimregb,
    input         [2:0]     id_is_aluop,
    input                   id_is_unsig,
    input         [1:0]     id_is_shiftop,
    input         [4:0]     id_is_shiftamt,
    input                   id_is_readmem,
    input                   id_is_writemem,
    input         [31:0]    id_is_imedext,
    input                   id_is_selwsource,
    input         [4:0]     id_is_regdest,
    input                   id_is_writereg,
    input                   id_is_writeov,
    input         [4:0]     id_is_addra,
    input         [4:0]     id_is_addrb,
    //Numero de operandos de cada instrucao
    input         [1:0]     id_is_numop,

    input                   execute_stall,
    //Fetch
    output reg              is_if_stall,
    //Execute
    output reg              is_ex_selalushift,
    output reg              is_ex_selimregb,
    output reg      [2:0]   is_ex_aluop,
    output reg              is_ex_unsig,
    output reg      [1:0]   is_ex_shiftop,
    output reg      [4:0]   is_ex_shiftamt,
    output reg      [31:0]  is_ex_rega,
    output reg              is_ex_readmem,
    output reg              is_ex_writemem,
    output reg      [31:0]  is_ex_regb,
    output reg      [31:0]  is_ex_imedext,
    output reg              is_ex_selwsource,
    output reg      [4:0]   is_ex_regdest,
    output reg              is_ex_writereg,
    output reg              is_ex_writeov,
    output reg      [1:0]   is_ex_unidadefuncional,
    //Registers
    output reg      [4:0]   is_reg_addra,
    output reg      [4:0]   is_reg_addrb,
    input           [31:0]  reg_is_dataa,
    input           [31:0]  reg_is_datab,
    input           [31:0]  reg_is_ass_dataa,
    input           [31:0]  reg_is_ass_datab
    );

    wire [31:0] pnd_sgn;
    reg wre;

    assign id_if_rega = reg_is_ass_dataa;
    assign is_reg_addra = id_is_addra;
    assign is_reg_addrb = id_is_addrb;
    assign is_ex_rega = reg_is_dataa;
    assign is_ex_regb = reg_is_datab;

    Scoreboard SCOREBOARD(.clock(clock),.reset(reset),.reg_addr(id_is_regdest),
        .func_uni(is_ex_unidadefuncional),.wre(wre),.pnd_sgn(pnd_sgn));

    assign is_ex_selalushift = (is_if_stall) ? 1'b0 : id_is_selalushift;
    assign is_ex_selimregb = (is_if_stall) ? 1'b0 : id_is_selimregb;
    assign is_ex_aluop = (is_if_stall) ? 3'b000 : id_is_aluop;
    assign is_ex_unsig = (is_if_stall) ? 1'b0 : id_is_unsig;
    assign is_ex_shiftop = (is_if_stall) ? 2'b00 : id_is_shiftop;
    assign is_ex_shiftamt = id_is_shiftamt; 
    assign is_ex_writemem = (is_if_stall) ? 1'b0 : id_is_writemem;
    assign is_ex_readmem = (is_if_stall) ? 1'b0 : id_is_readmem;
    assign is_ex_writereg = (is_if_stall) ? 1'b0: id_is_writereg;
    assign is_ex_imedext = id_is_imedext;
    assign is_ex_selwsource = (is_if_stall) ? 1'b0 : id_is_selwsource;
    assign is_ex_regdest = (is_if_stall) ? 5'b00000 : id_is_regdest;
    assign is_ex_writeov = (is_if_stall) ? 1'b0 : id_is_writeov;

    always @(posedge clock or negedge reset) begin
        if(!reset) begin
            is_if_stall = 1'b0;
            wre =  1'b1;
        end
        else begin
            if(((id_is_numop == 1) && pnd_sgn[id_is_addra]) ||
               ((id_is_numop == 2) && (pnd_sgn[id_is_addra] || pnd_sgn[id_is_addrb])))begin
                is_if_stall = 1'b1;
                is_ex_unidadefuncional = 2'b00;
            end
            else begin
                if(id_is_readmem || id_is_writemem)
                    is_ex_unidadefuncional = 2'b10;
                else if(id_is_aluop == 3'b111 )
                    is_ex_unidadefuncional = 2'b11;
                else
                    is_ex_unidadefuncional = 2'b01;
                is_if_stall = 1'b0;
            end

            wre = (is_if_stall) || !(id_is_numop);
        end
     end

endmodule

