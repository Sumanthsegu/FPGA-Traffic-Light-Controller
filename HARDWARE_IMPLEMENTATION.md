# Hardware Implementation

## Target Platform

The traffic light controller was implemented and tested on a **Zynq-7000 FPGA development board**.

## Hardware Mapping

```text
                FPGA
                 |
        +--------+--------+
        |                 |
      Road A            Road B
     R / Y / G         R / Y / G
```

The traffic-light outputs were mapped to FPGA board GPIO/LED outputs using a board-specific XDC constraint configuration.

## Timing

The design uses a 100 MHz FPGA clock by default.

| Signal state | Duration |
|---|---:|
| Road A Green | 5 s |
| Road A Yellow | 2 s |
| All Red | 1 s |
| Road B Green | 5 s |
| Road B Yellow | 2 s |
| All Red | 1 s |

The timing is parameterized in the RTL.

## Verification Flow

```text
Verilog RTL
     |
     v
Behavioral Simulation
     |
     v
RTL / Synthesis
     |
     v
Implementation
     |
     v
Bitstream Generation
     |
     v
Zynq-7000 FPGA
     |
     v
Hardware Testing
```

## Board Constraint File

The original `.xdc` file used for the hardware implementation is not currently available. Therefore, no board-specific pin numbers are claimed in this repository.

If the original XDC file is recovered later, it can be added under:

```text
constraints/
└── <board_constraints>.xdc
```

## Evidence

Hardware photographs, Vivado implementation screenshots, and simulation waveforms can be added to this directory when available.
