// /*
//  * Copyright (c) 2024 Your Name
//  * SPDX-License-Identifier: Apache-2.0
//  */

// `default_nettype none

// module tt_um_example (
//     input  wire [7:0] ui_in,    // Dedicated inputs
//     output wire [7:0] uo_out,   // Dedicated outputs
//     input  wire [7:0] uio_in,   // IOs: Input path
//     output wire [7:0] uio_out,  // IOs: Output path
//     output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
//     input  wire       ena,      // always 1 when the design is powered, so you can ignore it
//     input  wire       clk,      // clock
//     input  wire       rst_n     // reset_n - low to reset
// );

//   // All output pins must be assigned. If not used, assign to 0.
//   assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
//   assign uio_out = 0;
//   assign uio_oe  = 0;

//   // List all unused inputs to prevent warnings
//   wire _unused = &{ena, clk, rst_n, 1'b0};

// endmodule




/*
 * Copyright (c) 2026 Ares Ulises & Isaac Tadeo
 * SPDX-License-Identifier: Apache-2.0
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

  // 1. CONFIGURACIÓN DE PINES
  assign uio_oe  = 8'b00000111; // Pines 0,1,2 como salidas para control de dígitos
  assign uio_out[7:3] = 5'b00000;

  // 2. CONTADOR (Base de tiempo ajustada a 50MHz)
  reg [23:0] clk_div;
  reg [7:0] contador_reg;

  always @(posedge clk) begin
    if (!rst_n) begin
      clk_div <= 24'd0;
      contador_reg <= 8'd0;
    end else if (clk_div >= 24'd12499999) begin // 4Hz
      clk_div <= 24'd0;
      contador_reg <= (contador_reg >= 8'd255) ? 8'd0 : contador_reg + 1'b1;
    end else begin
      clk_div <= clk_div + 1'b1;
    end
  end

  // 3. INSTANCIA BCD (Desde bcd.v)
  wire [3:0] c, d, u;
  BCD_Converter bcd_inst (.bin_in(contador_reg), .bcd_centenas(c), .bcd_decenas(d), .bcd_unidades(u));

  // 4. MULTIPLEXADO RÁPIDO
  reg [15:0] refresh_cnt;
  always @(posedge clk) refresh_cnt <= (!rst_n) ? 16'd0 : refresh_cnt + 1'b1;

  reg [3:0] bcd_actual;
  reg [2:0] sel_dig;

  always @(*) begin
    case (refresh_cnt[15:14])
      // CAMBIO: Si usas transistores NPN, cambia 3'b110 por 3'b001, etc.
      2'b00: begin sel_dig = 3'b110; bcd_actual = u; end 
      2'b01: begin sel_dig = 3'b101; bcd_actual = d; end
      2'b10: begin sel_dig = 3'b011; bcd_actual = c; end
      default: begin sel_dig = 3'b111; bcd_actual = 4'h0; end
    endcase
  end
  assign uio_out[2:0] = sel_dig;

  // 5. DECODIFICADOR Y MAPEO ESTÁNDAR TT
  wire [6:0] s;
  SevenSeg_Encoder seg_inst (.nibble_in(bcd_actual), .segments_out(s));

  // ASIGNACIÓN SEGÚN ESTÁNDAR TINYTAPEOUT (A=pin0, G=pin6)
  assign uo_out[0] = s[6]; // A (En tu Encoder, s[6] es A si s=7'bABCDEFG)
  assign uo_out[1] = s[5]; // B
  assign uo_out[2] = s[4]; // C
  assign uo_out[3] = s[3]; // D
  assign uo_out[4] = s[2]; // E
  assign uo_out[5] = s[1]; // F
  assign uo_out[6] = s[0]; // G
  assign uo_out[7] = 1'b1; // DP apagado

  wire _unused = &{ui_in, uio_in, ena, 1'b0};

endmodule
