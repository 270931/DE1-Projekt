## 1. 7-Segment Display Multiplexing

### Description

The first simulation demonstrates the behavior of the 7-segment display controller using time-division multiplexing. The display is controlled via a shared segment bus (`seg[6:0]`) and individual anode signals (`anode[7:0]`).

### Simulation Waveform

![7-segment multiplexing simulation](img/display_driver_simulation.png)

*Figure 1: Time-multiplexed control of the 7-segment display. Each anode is activated sequentially while segment data is updated accordingly.*

### Behavior Analysis

- The `anode` signal cycles through digits sequentially:
