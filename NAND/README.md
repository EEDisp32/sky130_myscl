# CMOS 2-Input NAND Gate (`sky130_myscl_nand2`)

Basic 2-input NAND standard cell designed from scratch using the Sky130 PDK, fully compatible with the standard cell library grid and OpenLane flow.

---

## Overview

| Parameter | Value |
|---|---|
| **Function** | Y = !(A & B) |
| **Topology** | Complementary CMOS (2 PMOS parallel, 2 NMOS series) |
| **Standard Height** | 2.72 µm |
| **Cell Width** | 1.38 µm (3 tracks) |
| **Transistor Count** | 4 (2 PMOS, 2 NMOS) |
| **Transistor Sizing ($W_p$ / $W_n$)** | 1 µm / 0.63 µm|
| **Input Capacitance_A (C_in)** | ≈ 2.51fF (Rise: 2.47 fF, Fall: 2.55 fF) |
| **Input Capacitance_B (C_in)** | ≈ 2.40fF (Rise: 2.40 fF, Fall: 2.41 fF) |
| **Switching Threshold ($V_M$)** | ≈ 0.86V |
| **Peak DC Gain** | ≈ -18.3 |
| **Max Transient Current** | ≈ 195 µA (peak during switching) |

---

## Circuit Schematic & Operation

The cell consists of two parallel pull-up PMOS transistors and two series pull-down NMOS transistors. When both inputs are high, the output pulls down to ground; otherwise, it is pulled high.

![NAND Diagram](docs/NAND_diagram.png) 

---

## Layout

![NAND Layout](docs/Nand.png)

---

## Verification & Simulation Results

The cell was verified using ngspice across DC sweep and transient analyses (`tt_025C_1v80` corner).

### 1. Transient Response & Dynamic/Static Current
* **Signal Integrity:** Output voltage and input switching waveforms demonstrate correct logic operation with minimal propagation delay.
* **Power Dissipation:** Static current is virtually zero in steady-state conditions. During input transitions, transient switching current peaks reach approximately 195 µA.

![NAND Logic](docs/Nand_voltage.png)  ![NAND Power](docs/Nand_current.png)

### 2. VTC and Voltage Gain
* **Switching Threshold:** The VTC curve shows a sharp, well-defined transition centered around the midpoint of the rail.
* **DC Gain:** Peak differential voltage gain reaches roughly -18.3, providing strong signal restoration and high noise immunity.

![NAND VTC](docs/Nand_vtc.png) ![NAND Gain](docs/Nand_voltage_gain.png)