# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):

    dut._log.info("Starting Low-Power Approximate Multiplier Test")

    # Clock: 100 KHz
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 5)

    dut.rst_n.value = 1

    dut._log.info("Reset Complete")

    # ============================================================
    # TEST VECTORS
    # ============================================================

    test_vectors = [
        (3, 2),
        (4, 5),
        (7, 3),
        (8, 8),
        (15, 15),
        (15, 10),
        (9, 6),
        (12, 11)
    ]

    # ============================================================
    # APPLY TESTS
    # ============================================================

    for A, B in test_vectors:

        # ui_in[3:0]  = A
        # ui_in[7:4]  = B
        dut.ui_in.value = (B << 4) | A

        await ClockCycles(dut.clk, 1)

        result = dut.uo_out.value.integer

        expected = A * B

        dut._log.info(
            f"A={A}, B={B}, Approx={result}, Exact={expected}"
        )

        # Approximate multiplier tolerance
        assert abs(result - expected) <= 20, \
            f"FAILED: A={A}, B={B}, Got={result}, Expected={expected}"

    dut._log.info("ALL APPROXIMATE MULTIPLIER TESTS PASSED")
