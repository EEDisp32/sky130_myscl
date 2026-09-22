//=====================================================================
// alu32 - RV32I aritmetik-mantik birimi (32 bit)
//
// Giris ve cikislar kaydedilmis (registered) -> gercek setup/hold
// yollari olusur ve D_FF_pe hucresi de devreye girer.
//
// Bu tasarim kutuphaneyi ciddi sekilde zorlar:
//   - 32 bitlik toplayici    -> uzun tasima zinciri, kritik yol
//   - barrel shifter (SLL/SRL/SRA) -> buyuk MUX agaclari
//   - karsilastiricilar (SLT/SLTU) -> isaretli/isaretsiz mantik
//   - 10 yollu sonuc secimi  -> MUX agaci
//
// ISLEMLER (RV32I)
//   0000 ADD    0001 SLL    0010 SLT    0011 SLTU
//   0100 XOR    0101 SRL    0110 OR     0111 AND
//   1000 SUB    1101 SRA
//=====================================================================

module alu32 (
    input  wire        clk,
    input  wire [31:0] a_in,
    input  wire [31:0] b_in,
    input  wire [3:0]  op_in,
    output reg  [31:0] result,
    output reg         zero
);

    // ---------------- giris kayitlari ----------------
    reg [31:0] a, b;
    reg [3:0]  op;

    always @(posedge clk) begin
        a  <= a_in;
        b  <= b_in;
        op <= op_in;
    end

    // ---------------- kombinasyonel cekirdek ----------------
    wire [4:0]  shamt = b[4:0];
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    reg [31:0] alu_out;

    always @(*) begin
        case (op)
            4'b0000: alu_out = a + b;                       // ADD
            4'b1000: alu_out = a - b;                       // SUB
            4'b0001: alu_out = a << shamt;                  // SLL
            4'b0101: alu_out = a >> shamt;                  // SRL
            4'b1101: alu_out = a_s >>> shamt;               // SRA
            4'b0010: alu_out = (a_s < b_s)  ? 32'd1 : 32'd0; // SLT
            4'b0011: alu_out = (a   < b)    ? 32'd1 : 32'd0; // SLTU
            4'b0100: alu_out = a ^ b;                       // XOR
            4'b0110: alu_out = a | b;                       // OR
            4'b0111: alu_out = a & b;                       // AND
            default: alu_out = 32'd0;
        endcase
    end

    // ---------------- cikis kayitlari ----------------
    always @(posedge clk) begin
        result <= alu_out;
        zero   <= (alu_out == 32'd0);
    end

endmodule
