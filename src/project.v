/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_santosh_multiplier (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // Enable
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active-low reset
);

    // ============================================================
    // LOW-POWER APPROXIMATE 4x4 MULTIPLIER
    // ============================================================

    wire [3:0] A;
    wire [3:0] B;

    reg [7:0] result;

    assign A = ui_in[3:0];
    assign B = ui_in[7:4];

    always @(*) begin

        // Initialize output
        result = 8'b00000000;

        // Approximate multiplication logic

        // Bit 0
        result[0] = A[0] & B[0];

        // Bit 1
        result[1] = (A[1] & B[0]) ^
                    (A[0] & B[1]);

        // Bit 2
        result[2] = (A[2] & B[0]) ^
                    (A[1] & B[1]) ^
                    (A[0] & B[2]);

        // Bit 3
        result[3] = (A[3] & B[0]) ^
                    (A[2] & B[1]);

        // Bit 4
        result[4] = (A[3] & B[1]) ^
                    (A[2] & B[2]);

        // Bit 5
        result[5] = (A[3] & B[2]) ^
                    (A[2] & B[3]);

        // Bit 6
        result[6] = (A[3] & B[3]);

        // Bit 7
        result[7] = 1'b0;

    end

    // ============================================================
    // OUTPUT CONNECTIONS
    // ============================================================

    assign uo_out = result;

    // No bidirectional IO used
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // ============================================================
    // UNUSED SIGNALS
    // ============================================================

    wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
