<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This digital Leaky Integrate-and-Fire (LIF) neuron integrates 8-bit input current into an internal state while applying a 50% "leak" via a bitwise right-shift. When the membrane potential reaches the hardcoded threshold of 200, the circuit triggers a spike signal on the uio_out[7] pin.

## How to test

To test the design, apply a high input value to ui_in and monitor the 8-bit state on uo_out to see the potential rise and fire.

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
