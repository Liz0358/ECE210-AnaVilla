## How it works

This project implements a **4-neuron Ring Oscillator Network** based on the digital Leaky Integrate-and-Fire (LIF) model. Each individual neuron integrates an 8-bit input current into its internal membrane potential (`state`) while applying a 50% "leak" every clock cycle via a bitwise right-shift (`state >> 1`)

The neurons are connected in a loop to create a sequential firing pattern:
* **Integration & Leak**: Each neuron adds the `current` input to half of its previous `state`
* **Threshold & Spike**: When a neuron's potential reaches the threshold of **200**, it triggers a `spike`.
* **Reset-after-Spike**: Upon spiking, the neuron's state resets to **0** to allow for the next integration cycle
* **Synaptic Coupling**: The `spike` from one neuron acts as a "kick," adding a large value (**8'd150**) to the `current` input of the next neuron in the ring



## How to test

1.  **Initialize**: Apply a low signal to `rst_n` to clear all neuron states to 0
2.  **Start the Wave**: Set the base input current `ui_in` (pins 0-7) to a value between **50 and 70**. This provides the necessary "bias" so that the combined current (bias + 150 kick) is enough to cross the threshold
3.  **Monitor Spikes**: Observe pins `uio_out[7:4]`. You should see the four spike bits flash in a sequential sequence as the activity rotates through the network
4.  **Observe Potential**: Monitor the 8-bit `uo_out` port to see the real-time membrane potential of the first neuron rising and resetting
