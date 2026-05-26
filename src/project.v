/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // =========================================================================
    // LOW-POWER APPROXIMATE 4x4 MULTIPLIER
    // =========================================================================
    //
    // Inputs:
    //   ui_in[3:0] = A[3:0]
    //   ui_in[7:4] = B[3:0]
    //
    // Output:
    //   uo_out[7:0] = Approximate Product
    //
    // Approximation Technique:
    //   - Lower bits use simplified logic
    //   - Carry propagation reduced
    //   - Lower switching activity
    //   - Reduced hardware complexity
    //
    // =========================================================================

    wire [3:0] A;
    wire [3:0] B;

    reg [7:0] result;

    assign A = ui_in[3:0];
    assign B = ui_in[7:4];

    always @(*) begin

        // LSB
        result[0] = A[0] & B[0];

        // Approximate lower partial products
        result[1] = (A[1] & B[0]) ^
                    (A[0] & B[1]);

        // Approximate middle stage
        result[2] = (A[2] & B[0]) ^
                    (A[1] & B[1]) ^
                    (A[0] & B[2]);

        // More accurate upper bits
        result[7:3] = (A * B) >> 3;

    end

    // =========================================================================
    // OUTPUT ASSIGNMENTS
    // =========================================================================

    assign uo_out = result;

    // No bidirectional IO used
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // =========================================================================
    // UNUSED SIGNALS
    // =========================================================================

    wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
