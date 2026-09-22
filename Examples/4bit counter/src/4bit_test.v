module counter4s(
    input  wire       clk,
input  wire       rst,     // synchronous, active-high
    input  wire       en,      // count enable
    output wire [3:0] count
);

    wire [3:0] q;              // flip-flop outputs
    wire [3:0] d;              // flip-flop inputs
    wire [3:0] xo;             // XNOR outputs ( = ~q_next )
    wire [3:1] c;              // carry chain ( c0 = en )
    wire [3:1] nc;             // NAND outputs

    //-----------------------------------------------------------------
    // BIT 0 :  c0 = en
    //-----------------------------------------------------------------
    Xnor      x0 (.A(q[0]), .B(en),   .Y(xo[0]));
    Nor_gate  r0 (.A(xo[0]), .B(rst), .Y(d[0]));
    D_FF_pe   f0 (.CLK(clk), .D(d[0]), .Q(q[0]), .QN());

    //-----------------------------------------------------------------
    // BIT 1 :  c1 = en & q0
    //-----------------------------------------------------------------
    Nand_gate n1 (.A(en),    .B(q[0]), .Y(nc[1]));
    inverter  i1 (.A(nc[1]),           .Y(c[1]));

    Xnor      x1 (.A(q[1]), .B(c[1]),  .Y(xo[1]));
    Nor_gate  r1 (.A(xo[1]), .B(rst),  .Y(d[1]));
    D_FF_pe   f1 (.CLK(clk), .D(d[1]), .Q(q[1]), .QN());

    //-----------------------------------------------------------------
    // BIT 2 :  c2 = c1 & q1
    //-----------------------------------------------------------------
    Nand_gate n2 (.A(c[1]),  .B(q[1]), .Y(nc[2]));
    inverter  i2 (.A(nc[2]),           .Y(c[2]));

    Xnor      x2 (.A(q[2]), .B(c[2]),  .Y(xo[2]));
    Nor_gate  r2 (.A(xo[2]), .B(rst),  .Y(d[2]));
    D_FF_pe   f2 (.CLK(clk), .D(d[2]), .Q(q[2]), .QN());

    //-----------------------------------------------------------------
    // BIT 3 :  c3 = c2 & q2
    //-----------------------------------------------------------------
    Nand_gate n3 (.A(c[2]),  .B(q[2]), .Y(nc[3]));
    inverter  i3 (.A(nc[3]),           .Y(c[3]));

    Xnor      x3 (.A(q[3]), .B(c[3]),  .Y(xo[3]));
    Nor_gate  r3 (.A(xo[3]), .B(rst),  .Y(d[3]));
    D_FF_pe   f3 (.CLK(clk), .D(d[3]), .Q(q[3]), .QN());

    assign count = q;

endmodule
