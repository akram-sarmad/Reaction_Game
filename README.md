![Verilog](https://img.shields.io/badge/Verilog-HDL-blue?logo=verilog)
![Quartus](https://img.shields.io/badge/Intel-Quartus-green?logo=intel)
![ModelSim](https://img.shields.io/badge/ModelSim-Simulation-orange)
![FPGA](https://img.shields.io/badge/DE10--Lite-FPGA-blueviolet)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
# Password-Protected Math Game — FPGA Digital System in Verilog

A fully integrated digital system implemented in Verilog and deployed on an FPGA, featuring password-based access control, a real-time countdown timer, a pseudo-random number generator, and an interactive arithmetic game — all built from scratch using RTL design principles.

---

## Project Overview

This project implements a complete hardware game system on an FPGA. The player must first authenticate using a 4-digit password stored in ROM. Once logged in, the system generates a random number using a 4-bit LFSR, displays it on 7-segment displays, and challenges the player to input a number that sums to a target value — all within a countdown timer. Correct answers increment the score; the final score is displayed when time runs out.

---

## System Architecture

The design is fully modular, composed of the following RTL components:

| Module | Description |
|---|---|
| `game_access_fsm` | FSM-based password authentication with ROM verification |
| `timer_control_fsm` | FSM controlling game flow: load, generate, countdown, reconfig |
| `twodigittimer` | Two-digit BCD countdown timer (tens and units) |
| `rng_gen` | 4-bit LFSR pseudo-random number generator |
| `adder` | Combinational adder for player input + RNG |
| `decoder` | 4-bit to 7-segment display decoder |
| `LoadRegister` | Register for latching player input |
| `ButtonShaper` | Debounce and pulse-shaping for physical button inputs |
| `Lab4_MOHAMMED_sarmadakram` | Top-level module integrating all submodules |

---

## Key Features

- **Password Authentication:** 13-state FSM reads a 4-digit password from on-chip ROM and grants or denies access based on digit-by-digit comparison
- **LFSR Random Number Generation:** 4-bit maximal-length LFSR (polynomial x⁴ + x³ + 1) generates pseudo-random numbers each round
- **Real-Time Countdown Timer:** Two-digit BCD timer with enable, done, and reconfiguration signals coordinated by the timer control FSM
- **Score Tracking:** Increments score on correct answer within the active round window; displays final score on timer expiry
- **7-Segment Display Output:** Six independent 7-segment outputs showing timer, RNG value, player input, sum, and score
- **LED Status Indicators:** Four LEDs indicating login state and answer correctness
- **Button Debouncing:** Hardware-level button shaping for reliable single-pulse detection

---

## Tools & Technologies

- **Language:** Verilog (RTL)
- **Design Tool:** Intel Quartus Prime
- **Target Platform:** FPGA (Altera/Intel DE-series board)
- **Concepts Applied:** FSM design, synchronous logic, ROM instantiation, LFSR, BCD arithmetic, 7-segment decoding, clock-driven design

---

## How It Works

1. **Login:** Player enters a 4-digit password via switches and a button. The FSM reads stored digits from ROM and compares — granting access only on a full match.
2. **Game Start:** Once logged in, the player generates a random number by pressing the RNG button. The LFSR produces a new 4-bit value displayed on a 7-segment display.
3. **Player Input:** The player enters a number via switches and confirms. The hardware adder computes the sum in real time.
4. **Scoring:** If the sum equals the target value (7), the score increments and the round resets.
5. **Timer Expiry:** When the countdown hits zero, the final score replaces the running display, and the system logs out automatically.

---

## Module Highlight: FSM-Based Password Authentication

The `game_access_fsm` uses a 13-state Moore FSM to implement secure digit entry and ROM-based password verification:

```
digit1 → digit2 → digit3 → digit4
  → verify0_set → verify0_cap
  → verify1_set → verify1_cap
  → verify2_set → verify2_cap
  → verify3_set → verify3_cap
  → pass_state (if match) / digit1 (if mismatch)
```

ROM is read sequentially using a 2-bit address register, and the captured digits are compared against the stored password in the final verification state.

---

## Author

**Sarmad Akram Mohammed**  
M.S. Computer & Systems Engineering — University of Houston  
Course: Digital Systems / RTL Design
