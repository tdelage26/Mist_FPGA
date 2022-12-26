
module cpu_ram(
  input         reset,
  input         clk_sys,
  input  [15:0] cpu_ab,
  input  [7:0]  cpu_dout,
  output [7:0]  ram1_data,
  output [7:0]  ram2_data,
  input         cpu_wr,
  input         cpu_rd,
  input         ram1_cs,
  input         ram2_cs
);

wire [7:0] ram_din = cpu_dout;
wire ram1_ce_n = ~ram1_cs;
wire ram2_ce_n = ~ram2_cs;
wire ram1_wr_n = (ram1_ce_n | ~cpu_wr);
wire ram2_wr_n = (ram2_ce_n | ~cpu_wr);

ram #(11,8) ram1(
  .clk  ( clk_sys      ),
  .addr ( cpu_ab[10:0] ),
  .din  ( ram_din      ),
  .q    ( ram1_data    ),
  .rd_n ( ~cpu_rd      ),
  .wr_n ( ram1_wr_n    ),
  .ce_n ( ~ram1_cs     )
);

ram #(11,8) ram2(
  .clk  ( clk_sys      ),
  .addr ( cpu_ab[10:0] ),
  .din  ( ram_din      ),
  .q    ( ram2_data    ),
  .rd_n ( ~cpu_rd      ),
  .wr_n ( ram2_wr_n    ),
  .ce_n ( ~ram2_cs     )
);

endmodule
