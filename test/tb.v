// `default_nettype none
// `timescale 1ns / 1ps

// /* This testbench just instantiates the module and makes some convenient wires
//    that can be driven / tested by the cocotb test.py.
// */
// module tb ();

//   // Dump the signals to a FST file. You can view it with gtkwave or surfer.
//   initial begin
//     $dumpfile("tb.fst");
//     $dumpvars(0, tb);
//     #1;
//   end

//   // Wire up the inputs and outputs:
//   reg clk;
//   reg rst_n;
//   reg ena;
//   reg [7:0] ui_in;
//   reg [7:0] uio_in;
//   wire [7:0] uo_out;
//   wire [7:0] uio_out;
//   wire [7:0] uio_oe;
// `ifdef GL_TEST
//   wire VPWR = 1'b1;
//   wire VGND = 1'b0;
// `endif

//   // Replace tt_um_example with your module name:
//   tt_um_example user_project (

//       // Include power ports for the Gate Level test:
// `ifdef GL_TEST
//       .VPWR(VPWR),
//       .VGND(VGND),
// `endif

//       .ui_in  (ui_in),    // Dedicated inputs
//       .uo_out (uo_out),   // Dedicated outputs
//       .uio_in (uio_in),   // IOs: Input path
//       .uio_out(uio_out),  // IOs: Output path
//       .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
//       .ena    (ena),      // enable - goes high when design is selected
//       .clk    (clk),      // clock
//       .rst_n  (rst_n)     // not reset
//   );

// endmodule



`default_nettype none
`timescale 1ns / 1ps

/* Este testbench instancia el módulo y crea los cables necesarios
   que serán controlados y probados por el archivo test.py de cocotb.
*/
module tb ();

  // Configuración para generar el archivo de ondas (simulación visual)
  // Puedes abrir tb.fst con GTKWave para ver cómo se comportan las señales.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Declaración de señales para conectar al módulo
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  // Señales de alimentación para pruebas de Gate Level (GL)
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // --- INSTANCIACIÓN DEL PROYECTO ---
  // IMPORTANTE: Asegúrate de que 'tt_um_reloj_binario' sea el nombre exacto 
  // que pusiste en tu archivo principal de Verilog.
  tt_um_BDC user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Entradas dedicadas
      .uo_out (uo_out),   // Salidas dedicadas
      .uio_in (uio_in),   // IOs: Camino de entrada
      .uio_out(uio_out),  // IOs: Camino de salida
      .uio_oe (uio_oe),   // IOs: Habilitación (0=input, 1=output)
      .ena    (ena),      // Habilitar (se pone en alto cuando el diseño es seleccionado)
      .clk    (clk),      // Reloj
      .rst_n  (rst_n)     // Reset (activo en bajo)
  );

endmodule
