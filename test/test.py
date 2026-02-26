# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

@cocotb.test()
async def test_oscillator_network(dut):
    dut._log.info("Starting LIF Oscillator Network Test")

    # Set clock to 20ns (50MHz) to match config.json CLOCK_PERIOD
    clock = Clock(dut.clk, 20, units="ns") 
    cocotb.start_soon(clock.start())

    # Reset the system
    dut._log.info("Resetting...")
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # Provide a 'bias' current to start the oscillation
    # This current + the 150 'kick' from the spike will cross the 200 threshold
    dut.ui_in.value = 60 
    dut._log.info("Bias current applied. Monitoring spikes...")

    # Observe the spikes on uio_out[3:0]
    # We expect to see sp1, then sp2, then sp3, then sp4 in order
    for i in range(100):
        await RisingEdge(dut.clk)
        spikes = dut.uio_out.value >> 4 # Spikes are mapped to uio_out[7:4]
        if spikes > 0:
            dut._log.info(f"Cycle {i}: Spike pattern detected: {bin(int(spikes))}")

    dut._log.info("Oscillation test complete")