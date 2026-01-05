<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Este proyecto consiste en un Reloj Digital en formato BCD (Binary Coded Decimal). El diseño toma una señal de reloj externa y la procesa a través de una jerarquía de módulos:

Divisor de Frecuencia: Reduce la señal de reloj de entrada (típicamente 10 MHz en Tiny Tapeout) hasta una frecuencia de 1 Hz (un pulso por segundo).

Contadores BCD: Utiliza dos contadores independientes para los segundos:

Unidades: Cuenta de 0 a 9. Al llegar al límite, genera un pulso de acarreo y vuelve a 0.

Decenas: Se incrementa con el acarreo de las unidades y cuenta de 0 a 5.

Salida: El valor se presenta en formato BCD de 8 bits a través del puerto uo_out. Los 4 bits bajos (uo_out[3:0]) representan las unidades y los 4 bits altos (uo_out[7:4]) representan las decenas.

## How to test

Para probar el proyecto en simulación o en el chip físico:

Reset: Aplica un pulso bajo en rst_n para inicializar los contadores a cero.

Habilitación: Asegúrate de que ena esté en alto para activar el diseño.

Reloj: Proporciona una señal de reloj en el pin clk.

Observación: * Conecta LEDs o un analizador lógico al puerto de salida uo_out.

Verás cómo los bits [3:0] cuentan en binario hasta 1001 (9).

En el siguiente pulso de segundo, [3:0] volverá a 0000 y el bit [4] se pondrá en alto, indicando que han pasado 10 segundos (0001 0000 en BCD).

## External hardware

Para visualizar el funcionamiento del reloj de forma física, se recomienda:

8 LEDs con resistencias: Conectados a las salidas uo_out[7:0] para ver el código binario directamente.

Módulo de 7 Segmentos (Opcional): Se puede conectar un decodificador BCD a 7 segmentos (como el 74LS47) a cada nibble (4 bits) para mostrar los números en una pantalla numérica común.

PMD Display: Si usas la placa de demostración de Tiny Tapeout, puedes mapear las salidas a los segmentos del display integrado.
