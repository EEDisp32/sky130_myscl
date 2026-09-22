# MySCL — A Custom Standard Cell Library for SKY130

Six standard cells drawn from scratch in Magic, characterised with lctime, and fully compitable with OpenLane flow.

---

## Cells

| Cell | Function | Transistors | Area (µm²) |
|---|---|---|---|
| inverter | Y = !A | 2 | 03.76 |
| Nand_gate | Y = !(A & B) | 4 | 03.76 |
| Nor_gate | Y = !(A \| B) | 4 | 03.76 |
| Xnor | Y = !(A ^ B) | 10 | 10.01 |
| Mux | Y = S ? B : A | 12 | 11.26 |
| D_FF_pe | positive-edge D flip-flop | 32 | 28.77 |

All cells are 2.72 µm tall and site-aligned, so they abut directly with the `sky130_fd_sc_hd` library.

---

## Flow

| Step | Tool |
|---|---|
| Layout | Magic |
| DRC / LVS | Magic, Netgen |
| Circuit verification | ngspice — VTC, transient, static & dynamic current |
| Characterisation | lctime → Liberty (`.lib`) |
| Abstract / GDS | Magic |
| Synthesis & P&R | OpenLane |

Corner: `tt_025C_1v80`.

---

## Verification

Each cell was verified at three levels: circuit (ngspice), timing (characterisation against the `sky130_fd_sc_hd` equivalent), and system (synthesised into real designs through OpenLane).

### Against the reference library

| | MySCL | `sky130_fd_sc_hd` |
|---|---|---|
| Mux — input capacitance A / B / S | 1.73 / 1.28 / 2.82 fF | 1.58 / 1.91 / 3.47 fF |
| Mux — `cell_rise` min load | 0.0845 ns | 0.0889 ns |
| Mux — `cell_rise` max load | 1.012 ns | 1.119 ns |
| Mux — area | 11.26 µm² | 11.26 µm² |

### System-level

A 32-bit RV32I ALU, synthesised entirely from these cells.

| | |
|---|---|
| Die size | 172.45 × 183.17 µm (31 588 µm²) |
| Instances | 4926 |
| Nets | 2372 |
| Setup / hold | met, no violations |

A separate comparison — the same behavioural RTL synthesised twice, once with MySCL and once with the full 400-cell `sky130_fd_sc_hd` library:

| Library | Area | Setup slack |
|---|---|---|
| MySCL (6 cells) | 488 µm² | 6.54 ns |
| `sky130_fd_sc_hd` (400+ cells) | 478 µm² | 6.48 ns |

Within 2 % of the foundry library, despite offering the mapper a fraction of the choices.

---

## Notes on two cells

**Xnor:** The initial layout had a weak pull-up network: measured from the layout, three of five PMOS fingers were only ~1.2× the width of their NMOS counterparts, against the ~2.5× needed to compensate for hole mobility. This showed up directly in the characterisation as a rise/fall delay ratio of 2.36. Widening the pull-up brought it to 1.69 and cut the rise delay by 19 %. Additionally, the cell is asymmetrical in input capacitance: pin A drives 2 transistors while pin B drives 4, resulting in differing input capacitances (A vs B), meaning the gate is functionally correct but not pin-balanced.

**Mux:** The first implementation used the inverted select signal as a virtual rail rather than purely as a gate input. In two of the eight input states this left both pull-up and pull-down networks conducting, drawing 49 µA and 23.5 µA of static current. Rebuilding the cell as a proper complementary static CMOS gate — where the pull-up network is the exact complement of the pull-down — reduced this to below 6 nA in every state.

---

## Known limitations

- **Single corner:** Cells are characterised at `tt_025C_1v80` only. The `ss` and `ff` corner files reuse the same data, so corner analysis reflects variation in the standard `sky130_fd_sc_hd` cells (clock tree, buffers) but not in these.
- **No drive-strength variants:** One version of each cell. The resizer cannot trade area for drive, which shows up as a handful of max-fanout warnings in large designs.
- **No buffer cell:** `sky130_fd_sc_hd__buf_*` is used for buffering and clock tree synthesis. ABC requires a non-inverting buffer to perform technology mapping at all.
- **Cell set is minimal:** No complex AOI/OAI gates, Limited gate variety, no reset flip-flop — a synchronous reset has to be built from logic.

---

## **Author**
**Hüsnü Onur Bücük**  
*Electrical & Electronics Engineering Student*  
**Focus:** Custom IC Design, Digital Design, Standard Cell Library Development, Computer Architecture, RTL-to-GDSII Flow


