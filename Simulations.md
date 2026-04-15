## 1. 7-Segment Display Multiplexing

### Description

The first simulation demonstrates the behavior of the 7-segment display controller using time-division multiplexing. The display is controlled via a shared segment bus (`seg[6:0]`) and individual anode signals (`anode[7:0]`).

### Simulation Waveform

![7-segment multiplexing simulation](img/display_driver_simulation.png)

*Figure 1: Time-multiplexed control of the 7-segment display. Each anode is activated sequentially while segment data is updated accordingly.*

### Behavior Analysis

- The `anode` signal cycles through digits sequentially:

  11111110 → 11111101 → 11111011 → 11110111 → ...

- At each time step, only one digit is active (active-low logic).
- The `seg` output changes according to the active digit.

### Conclusion

The simulation confirms correct multiplexing behavior and proper synchronization between `seg` and `anode` signals.

---

## 2. Binary to 7-Segment Decoder (bin2seg)

### Description

This simulation verifies the functionality of the `bin2seg` module, which converts a binary value into a 7-segment representation.

### Simulation Waveform

![bin2seg simulation](img/bin2seg_simulation.png)

*Figure 2: Output response of the `bin2seg` decoder for sequential binary inputs.*

### Behavior Analysis

- The input `bin` increments from:

  00 → 01 → 02 → ... → 14

- The output `seg` updates immediately, confirming combinational logic behavior.
- Each value is correctly mapped to its corresponding 7-segment encoding.
  

>[!NOTE]
>The segment mapping uses reversed bit ordering, where seg(6) corresponds to segment 'g' and seg(0) to segment 'a'

### Conclusion

The `bin2seg` module correctly implements binary-to-7-segment decoding and is suitable for displaying numerical values.
