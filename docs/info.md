# Low-Power Approximate Multiplier

## How it works

This project implements a low-power approximate 4x4 multiplier using Verilog HDL.

The design takes:
- 4-bit input A
- 4-bit input B

and produces:
- 8-bit approximate product output.

Approximation techniques are used in lower partial product computation to reduce:
- hardware complexity
- switching activity
- power consumption
- area utilization

The design is optimized for TinyTapeout SKY130 OpenLane flow.

Inputs:
- ui_in[3:0] = A[3:0]
- ui_in[7:4] = B[3:0]

Outputs:
- uo_out[7:0] = Approximate Product

Unused bidirectional IOs are tied to zero.

---

## How to test

Apply two 4-bit operands:
- A through ui_in[3:0]
- B through ui_in[7:4]

Observe the approximate multiplication result on:
- uo_out[7:0]

Example:
- A = 7
- B = 3

Expected approximate result:
- Close to decimal 21

The output may slightly differ from exact multiplication because approximate arithmetic is intentionally used to reduce power and area.
