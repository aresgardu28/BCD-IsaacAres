module BCD (
    input [7:0] bin_in,          // Entrada binaria (0-255) [cite: 63]
    output [3:0] bcd_centenas,   // Centenas (0-2) [cite: 63]
    output [3:0] bcd_decenas,    // Decenas (0-9) [cite: 63]
    output [3:0] bcd_unidades    // Unidades (0-9) [cite: 63]
);
    // Cálculo de Centenas [cite: 65]
    assign bcd_centenas = bin_in / 100;

    // Cálculo de Decenas y Unidades usando el residuo [cite: 67, 69, 71]
    wire [7:0] residuo;
    assign residuo = bin_in % 100;
    assign bcd_decenas = residuo / 10;
    assign bcd_unidades = residuo % 10;

endmodule

module Encoder (
    input [3:0] nibble_in,       // Dígito BCD [cite: 128]
    output reg [6:0] segments_out // Salida a-g [cite: 128]
);
    always @(*) begin
        case (nibble_in)
            // Mapeo de segmentos (a,b,c,d,e,f,g) [cite: 137-140]
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
            default: segments_out = 7'b000_0000; // Apagado [cite: 141]
        endcase
    end
endmodule

module Display (
    input clk,                   // Reloj maestro [cite: 191]
    input btn_reset,             // Botón de reinicio [cite: 194]
    output reg [2:0] dig,        // Selección de dígito (Comunes) [cite: 196]
    output [7:0] seg             // Segmentos finales [cite: 199]
);
    // Divisor para obtener 4 Hz [cite: 203]
    reg [23:0] clk_div;
    reg [7:0] contador_reg;

    always @(posedge clk) begin
        if (btn_reset == 1'b0) begin // Reset activo en bajo [cite: 207]
            contador_reg <= 8'd0;
            clk_div <= 24'd0;
        end else if (clk_div >= 12499999) begin // Basado en reloj de 50MHz [cite: 212]
            clk_div <= 0;
            if (contador_reg >= 255) contador_reg <= 0; // Límite de 8 bits [cite: 216, 218]
            else contador_reg <= contador_reg + 1;
        end else begin
            clk_div <= clk_div + 1;
        end
    end

    // Instancia de BCD [cite: 224-227]
    wire [3:0] c, d, u;
    BCD bcd_inst (contador_reg, c, d, u);

    // Multiplexor de refresco visual [cite: 228-236]
    reg [15:0] refresh;
    always @(posedge clk) refresh <= refresh + 1;

    reg [3:0] bcd_actual;
    always @(*) begin
        case (refresh[15:14])
            2'b00: begin dig = 3'b110; bcd_actual = u; end // Unidades [cite: 234]
            2'b01: begin dig = 3'b101; bcd_actual = d; end // Decenas [cite: 234]
            2'b10: begin dig = 3'b011; bcd_actual = c; end // Centenas [cite: 235]
            default: begin dig = 3'b111; bcd_actual = 4'h0; end
        endcase
    end

    // Instancia del Encoder [cite: 237-251]
    wire [6:0] s;
    Encoder enc_inst (bcd_actual, s);
    
    // Asignación de segmentos [cite: 253-259]
    assign seg = {1'b1, s}; // Se agrega el Punto Decimal (DP) apagado
endmodule