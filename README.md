# Synchronous FIFO Design Using Verilog HDL

## Overview

This project implements an 8-bit wide, 16-depth Synchronous FIFO (First-In First-Out) using Verilog HDL.

A FIFO is a memory-based data structure in which the first data written is the first data read. It is commonly used in digital systems for temporary data storage and buffering between hardware modules.

## Design Specifications

| Parameter | Value |
|---|---|
| FIFO Type | Synchronous FIFO |
| Data Width | 8 bits |
| FIFO Depth | 16 locations |
| Clock | Single clock |
| Reset | Synchronous, active-high |

## Features

- Independent read and write enable controls
- 8-bit data storage
- 16 memory locations
- Read and write pointer management
- Full and empty flag generation
- Overflow protection
- Underflow protection
- Pointer wraparound
- Simultaneous read and write operations

## Simulation and Verification

The FIFO design was verified using a Verilog testbench in Xilinx Vivado.

The following test scenarios were successfully simulated:

| Test | Description | Result |
|---|---|---|
| 1 | Normal write and read operations | PASS |
| 2 | Full detection and overflow protection | PASS |
| 3 | Empty detection and underflow protection | PASS |
| 4 | Simultaneous read and write operations | PASS |
| 5 | Pointer wraparound and address reuse | PASS |

**Overall Result: All 5 test cases passed.**

## RTL Schematic

![FIFO RTL Schematic](Results/Synchronous-FIFO%20RTL.png)

## Simulation Waveform

![FIFO Simulation Waveform](Results/Synchronous-FIFO%20waveform.png)

## Simulation Results

![FIFO Simulation Results](Results/Synchronous-FIFO%20simulation.png)

## Tools and Technologies

- Verilog HDL
- Xilinx Vivado
- RTL Simulation
- Testbench Verification

## Author

**Samyak Rastogi**

[GitHub Profile](https://github.com/Samyak0039)
