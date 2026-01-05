/*
 * Módulos de soporte para el Contador BCD
 * Incluye: Convertidor de Binario a BCD y Decodificador de 7 Segmentos
 */

`default_nettype none

// 1. Convertidor de Binario a BCD (Binary Coded Decimal)
// Transforma un número de 8 bits (0-255) en centenas, decenas y unidades individuales.
module BCD (
    input  wire [7:0] bin_in,          // Entrada binaria (0-255)
    output wire [3:0] bcd_centenas,   // Dígito de centenas
    output wire [3:0] bcd_decenas,    // Dígito de decenas
    output wire [3:0] bcd_unidades    // Dígito de unidades
);
    // Cálculo mediante operadores de división y residuo
    assign bcd_centenas = bin_in / 100;
    
    wire [7:0] residuo;
    assign residuo      = bin_in % 100;
    assign bcd_decenas  = residuo / 10;
    assign bcd_unidades = residuo % 10;
endmodule

// 2. Decodificador de 7 Segmentos (Encoder)
// Convierte un dígito BCD (0-9) en el patrón de encendido para los LEDs a-g.
module Encoder (
    input  wire [3:0] nibble_in,       // Dígito de entrada
    output reg  [6:0] segments_out     // Salida para segmentos a-g
);
    always @(*) begin
        case (nibble_in)
            // Mapeo de segmentos: {a, b, c, d, e, f, g}
            4'h0: segments_out = 7'b111_1110;
            4'h1: segments_out = 7'b011_0000;
            4'h2: segments_out = 7'b110_1101;
            4'h3: segments_out = 7'b111_1001;
            4'h4: segments_out = 7'b011_0011;
            4'h5: segments_out = 7'b101_1011;
            4'h6: segments_out = 7'b101_1111;
            4'h7: segments_out = 7'b111_0000;
            4'h8: segments_out = 7'b111_1111;
            4'h9: segments_out = 7'b111_1011;
            default: segments_out = 7'b000_0000;
