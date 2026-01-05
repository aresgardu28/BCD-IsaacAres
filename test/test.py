# # SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# # SPDX-License-Identifier: Apache-2.0

# import cocotb
# from cocotb.clock import Clock
# from cocotb.triggers import ClockCycles


# @cocotb.test()
# async def test_project(dut):
#     dut._log.info("Start")

#     # Set the clock period to 10 us (100 KHz)
#     clock = Clock(dut.clk, 10, unit="us")
#     cocotb.start_soon(clock.start())

#     # Reset
#     dut._log.info("Reset")
#     dut.ena.value = 1
#     dut.ui_in.value = 0
#     dut.uio_in.value = 0
#     dut.rst_n.value = 0
#     await ClockCycles(dut.clk, 10)
#     dut.rst_n.value = 1

#     dut._log.info("Test project behavior")

#     # Set the input values you want to test
#     dut.ui_in.value = 20
#     dut.uio_in.value = 30

#     # Wait for one clock cycle to see the output values
#     await ClockCycles(dut.clk, 1)

#     # The following assersion is just an example of how to check the output values.
#     # Change it to match the actual expected output of your module:
#     assert dut.uo_out.value == 50

#     # Keep testing the module by changing the input values, waiting for
#     # one or more clock cycles, and asserting the expected output values.

# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Iniciando simulación del Reloj BCD")

    # Configurar el reloj: 10us de periodo (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # --- Secuencia de Reset ---
    dut._log.info("Aplicando Reset...")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10) # Esperar 10 ciclos de reloj
    dut.rst_n.value = 1
    dut._log.info("Reset liberado")

    # --- Prueba de funcionamiento ---
    dut._log.info("Observando el contador BCD...")

    # Vamos a esperar unos cuantos ciclos para ver el cambio.
    # Nota: Si tu diseño tiene un divisor de frecuencia interno muy grande 
    # (ej. para bajar de 10MHz a 1Hz), el test tardará mucho.
    # Aquí asumimos que queremos ver los primeros cambios en las salidas.
    
    for i in range(10):
        await ClockCycles(dut.clk, 1)
        # Leemos el valor actual en la salida uo_out
        valor_salida = dut.uo_out.value
        dut._log.info(f"Ciclo {i}: Salida uo_out = {valor_salida} (Hex: {valor_salida.hex})")

    # --- Ejemplo de Aserción ---
    # Si después de unos ciclos esperamos que el contador ya no sea 0:
    # assert dut.uo_out.value != 0, "Error: El contador no está avanzando"

    dut._log.info("Prueba finalizada con éxito")
