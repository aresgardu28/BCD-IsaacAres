/*
 * Módulos de soporte para el Contador BCD
 * Incluye: Convertidor de Binario a BCD y Decodificador de 7 Segmentos
 */

`default_nettype none

module tt_um_BCD (
    input  wire [7:0] ui_in,    
    output wire [7:0] uo_out,   
    input  wire [7:0] uio_in,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);
  assign uio_oe  = 8'b00000111;
  assign uio_out[7:3] = 5'b00000;

  reg [23:0] clk_div;
  reg [7:0] contador_reg;

  always @(posedge clk) begin
    if (!rst_n) begin
      clk_div <= 24'd0;
      contador_reg <= 8'd0;
    end else if (clk_div >= 24'd12499999) begin
      clk_div <= 24'd0;
      contador_reg <= (contador_reg >= 8'd255) ? 8'd0 : contador_reg + 1'b1;
    end else begin
      clk_div <= clk_div + 1'b1;
    end
  end

  wire [3:0] c, d, u;
  // Nombres de módulos corregidos para coincidir con BCD.v
  BCD bcd_inst (.bin_in(contador_reg), .bcd_centenas(c), .bcd_decenas(d), .bcd_unidades(u));

  reg [15:0] refresh_cnt;
  always @(posedge clk) refresh_cnt <= (!rst_n) ? 16'd0 : refresh_cnt + 1'b1;

  reg [3:0] bcd_actual;
  reg [2:0] sel_dig;

  always @(*) begin
    case (refresh_cnt[15:14])
      2'b00: begin sel_dig = 3'b110; bcd_actual = u; end 
      2'b01: begin sel_dig = 3'b101; bcd_actual = d; end
      2'b10: begin sel_dig = 3'b011; bcd_actual = c; end
      default: begin sel_dig = 3'b111; bcd_actual = 4'h0; end
    endcase
  end
  assign uio_out[2:0] = sel_dig;

  wire [6:0] s;
  Encoder seg_inst (.nibble_in(bcd_actual), .segments_out(s));

  assign uo_out[0] = s[6];
  assign uo_out[1] = s[5];
  assign uo_out[2] = s[4];
  assign uo_out[3] = s[3];
  assign uo_out[4] = s[2];
  assign uo_out[5] = s[1];
  assign uo_out[6] = s[0];
  assign uo_out[7] = 1'b1;

  wire _unused = &{ui_in, uio_in, ena, 1'b0};
endmodule
