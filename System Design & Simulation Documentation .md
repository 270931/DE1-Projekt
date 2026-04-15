# Simulation and Verification

This section describes the performed simulations used to verify the functionality of the implemented VHDL modules. The simulations focus mainly on the 7-segment display driver and the binary-to-segment decoder, which are essential for visual output in the LED Ping-Pong system.

---

## 1. 7-Segment Display Multiplexing

### Related Modules
- `LED_PingPong_top`
- `GameLogic` (output interface)
- 7-segment display driver (internal logic)

### Description

The first simulation demonstrates the behavior of the 7-segment display controller using time-division multiplexing. The display is controlled via a shared segment bus (`seg[6:0]`) and individual anode signals (`anode[7:0]`).

In the top-level module (`LED_PingPong_top`), the display signals are directly driven by the `GameLogic` module, which provides the encoded segment data and digit selection.

### Observed Signals

- `clk` – system clock (100 MHz from FPGA board)
- `rst` – reset signal (mapped to `btnc`)
- `data[39:0]` – internal data bus containing characters to display
- `seg[6:0]` – segment control output
- `anode[7:0]` – active-low digit enable signals

### Behavior Analysis
