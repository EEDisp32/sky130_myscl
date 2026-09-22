# Design Example: RISC-V ALU Subsystem

Functional and timing overview of the custom ALU datapath integrated with `sky130_myscl` standard cells.

The design is from my other project : https://github.com/EEDisp32/5_Stage_Pipelined_RISCV_Core

---

## Synthesis & Timing Summary (STA)

Extracted using OpenSTA across typical process corners (`tt_025C_1v80`).

| Metric | Value | Description |
|---|---|---|
| **Design Type** | Combinational Datapath (ALU) | Arithmetic & Logic operations module |
| **Cell Count** | 2203 (2085 From MySCL) | Total standard cells used |
| **Worst Negative Slack (WNS)** | 0.00 ns (Met) | Timing closure successfully achieved |
| **Setup Time / Hold Time** | 7.20 ns / 8.44 ns |

---

## Verification & Architecture Notes

* **Functional Verification:** Verified at the RTL level using Vivado Sim and ILA testbenches, ensuring correct execution of arithmetic (ADD, SUB), logical (AND, OR, XOR), and shift operations.
* **Integration:** Utilizes custom-designed standard cells (xnor2, mux2, dfq) to evaluate area and propagation delay trade-offs within a real datapath environment.