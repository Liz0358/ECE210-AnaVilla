/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_Oscillator(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out [6:0]= 0;
  assign uio_oe  = 1;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0, uio_in, s2, s3, s4};
  
  // Signal wires to connect the neurons in a ring
  wire [7:0] s1, s2, s3, s4; // Internal states
  wire sp1, sp2, sp3, sp4;   // Individual spikes

  // Neuron 1: Gets input from the last neuron (sp4)
  Oscillator Oscillator1 (.clk(clk), .reset_n(rst_n), .current(ui_in + (sp4 ? 8'd150 : 8'd0)), .state(s1), .spike(sp1));

  // Neuron 2: Gets input from Neuron 1 (sp1)
  Oscillator Oscillator2 (.clk(clk), .reset_n(rst_n), .current(ui_in + (sp1 ? 8'd150 : 8'd0)), .state(s2), .spike(sp2));

  // Neuron 3: Gets input from Neuron 2 (sp2)
  Oscillator Oscillator3 (.clk(clk), .reset_n(rst_n), .current(ui_in + (sp2 ? 8'd150 : 8'd0)), .state(s3), .spike(sp3));

  // Neuron 4: Gets input from Neuron 3 (sp3)
  Oscillator Oscillator4 (.clk(clk), .reset_n(rst_n), .current(ui_in + (sp3 ? 8'd150 : 8'd0)), .state(s4), .spike(sp4));

  // Assign one state to the main output to monitor it
  assign uo_out = s1; 
  // Output all spikes to the pins to see the "oscillation"
  assign uio_oe = 8'b11111111; 
  assign uio_out = {sp4, sp3, sp2, sp1, 4'b0000};
endmodule
