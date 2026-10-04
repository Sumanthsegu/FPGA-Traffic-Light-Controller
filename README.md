# FPGA Traffic Light Controller

A parameterized two-road traffic light controller implemented in Verilog HDL using a Moore finite state machine (FSM).

The design was developed and simulated using **Xilinx Vivado** and was also tested on a **Zynq-7000 FPGA development board**.

## Project Overview

The controller manages traffic signals for two roads:

- Road A: Red / Yellow / Green
- Road B: Red / Yellow / Green

Only one road is permitted to have a green signal at a time. An all-red interval is inserted between road transitions for safer operation.

## FSM Sequence

```text
        +-------------+
        |  A GREEN    |
        +------+------+
               |
               v
        +-------------+
        |  A YELLOW   |
        +------+------+
               |
               v
        +-------------+
        |  ALL RED    |
        +------+------+
               |
               v
        +-------------+
        |  B GREEN    |
        +------+------+
               |
               v
        +-------------+
        |  B YELLOW   |
        +------+------+
               |
               v
        +-------------+
        |  ALL RED    |
        +------+------+
               |
               +-------> A GREEN
```

## State Encoding

| State | Road A | Road B |
|---|---|---|
| `S_A_GREEN` | Green | Red |
| `S_A_YELLOW` | Yellow | Red |
| `S_ALL_RED_1` | Red | Red |
| `S_B_GREEN` | Red | Green |
| `S_B_YELLOW` | Red | Yellow |
| `S_ALL_RED_2` | Red | Red |

## Design Features

- Moore FSM architecture
- Parameterized green, yellow and all-red durations
- Clock-based state timing
- Separate state register and next-state logic
- Combinational output decoder
- Safety checks in the testbench
- Designed for a 100 MHz FPGA clock by default

## Timing Parameters

The RTL uses:

```verilog
GREEN_TIME   = 5
YELLOW_TIME  = 2
ALL_RED_TIME = 1
CLK_FREQ_HZ  = 100_000_000
```

For example:

```text
Green duration = 100,000,000 × 5
               = 500,000,000 clock cycles
               = 5 seconds
```

The testbench overrides `CLK_FREQ_HZ` to `1` so that the state transitions can be observed quickly during simulation.

## Verification

The testbench checks that:

1. Both roads never become green simultaneously.
2. A road never has more than one light active simultaneously.
3. The FSM cycles through the expected sequence.

## Hardware

**Target platform:** Zynq-7000 FPGA development board

The board-specific XDC/pin-constraint file is not included in this repository because the original project constraint file is currently unavailable.

The RTL can be adapted to a specific Zynq-7000 board by assigning the clock, reset and LED output pins in an XDC file.

## Repository Structure

```text
FPGA-Traffic-Light-Controller/
├── README.md
├── rtl/
│   └── traffic_light_controller.v
├── simulation/
│   └── traffic_light_controller_tb.v
└── docs/
    └── simulation_waveform.png
```

## Tools

- Verilog HDL
- Xilinx Vivado 2023.1
- Zynq-7000 FPGA
- RTL Simulation

## Future Improvements

- Add board-specific XDC constraints
- Add pedestrian crossing control
- Add emergency vehicle priority
- Add programmable timing control
- Add seven-segment countdown display
- Add assertions for complete FSM sequence verification
