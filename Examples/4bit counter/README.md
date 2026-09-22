# Design Example: 4-bit Synchronous Counter (`counter4s`)

Integration example of the custom standard cell library within a 4-bit synchronous counter datapath, verified using OpenLane and OpenSTA signoff reports.

---

## Static Timing Analysis (STA) & Performance Summary

Extracted using OpenSTA across typical process corners (`Typical` corner, $10\text{ ns}$ clock period / $100\text{ MHz}$).

| Timing / Performance Metric | Value | Description |
|---|---|---|
| **Setup Slack (Max Delay)** | $+6.75\text{ ns}$ (MET) | Design meets target frequency with positive margin |
| **Hold Slack (Min Delay)** | $+0.16\text{ ns}$ (MET) | No hold violations; safe against clock skew |
| **Worst Negative Slack (WNS)** | $0.00\text{ ns}$ | Timing closure successfully achieved |
| **Total Negative Slack (TNS)** | $0.00\text{ ns}$ | Zero path violations across the design |
| **Violations (Slew/Cap/Fanout)** | 0 | All net and pin constraints satisfied |

---

## Power & Area Metrics

| Power Category | Value | Percentage |
|---|---|---|
| **Sequential Power** | $1.71 \times 10^{-5}\text{ W}$ | ~20.0% |
| **Combinational Power** | $6.82 \times 10^{-5}\text{ W}$ | ~80.0% |
| **Total Power** | $8.53 \times 10^{-5}\text{ W}$ | 100.0% |

---

## Verification & Architecture Notes

* **Netlist Composition:** The design integrates custom-routed standard cells including D-flip-flops, NAND, NOR, and XNOR gates.
* **Signoff Status:** Fully routed and annotated with SDF timing models (`counter4s.sdf`) and liberty outputs (`counter4s.lib`) for post-layout validation.