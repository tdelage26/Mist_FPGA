import m72_pkg::*;

module IremM72_MiST
(
	input         CLOCK_27,
`ifdef USE_CLOCK_50
	input         CLOCK_50,
`endif

	output        LED,
	output [VGA_BITS-1:0] VGA_R,
	output [VGA_BITS-1:0] VGA_G,
	output [VGA_BITS-1:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,

`ifdef USE_HDMI
	output        HDMI_RST,
	output  [7:0] HDMI_R,
	output  [7:0] HDMI_G,
	output  [7:0] HDMI_B,
	output        HDMI_HS,
	output        HDMI_VS,
	output        HDMI_PCLK,
	output        HDMI_DE,
	input         HDMI_INT,
	inout         HDMI_SDA,
	inout         HDMI_SCL,
`endif

	input         SPI_SCK,
	inout         SPI_DO,
	input         SPI_DI,
	input         SPI_SS2,    // data_io
	input         SPI_SS3,    // OSD
	input         CONF_DATA0, // SPI_SS for user_io

`ifdef USE_QSPI
	input         QSCK,
	input         QCSn,
	inout   [3:0] QDAT,
`endif
`ifndef NO_DIRECT_UPLOAD
	input         SPI_SS4,
`endif

	output [12:0] SDRAM_A,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nWE,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nCS,
	output  [1:0] SDRAM_BA,
	output        SDRAM_CLK,
	output        SDRAM_CKE,

`ifdef DUAL_SDRAM
	output [12:0] SDRAM2_A,
	inout  [15:0] SDRAM2_DQ,
	output        SDRAM2_DQML,
	output        SDRAM2_DQMH,
	output        SDRAM2_nWE,
	output        SDRAM2_nCAS,
	output        SDRAM2_nRAS,
	output        SDRAM2_nCS,
	output  [1:0] SDRAM2_BA,
	output        SDRAM2_CLK,
	output        SDRAM2_CKE,
`endif

	output        AUDIO_L,
	output        AUDIO_R,
`ifdef I2S_AUDIO
	output        I2S_BCK,
	output        I2S_LRCK,
	output        I2S_DATA,
`endif
`ifdef I2S_AUDIO_HDMI
	output        HDMI_MCLK,
	output        HDMI_BCK,
	output        HDMI_LRCK,
	output        HDMI_SDATA,
`endif
`ifdef SPDIF_AUDIO
	output        SPDIF,
`endif
`ifdef USE_AUDIO_IN
	input         AUDIO_IN,
`endif
	input         UART_RX,
	output        UART_TX

);

`ifdef NO_DIRECT_UPLOAD
localparam bit DIRECT_UPLOAD = 0;
wire SPI_SS4 = 1;
`else
localparam bit DIRECT_UPLOAD = 1;
`endif

`ifdef USE_QSPI
localparam bit QSPI = 1;
assign QDAT = 4'hZ;
`else
localparam bit QSPI = 0;
`endif

`ifdef VGA_8BIT
localparam VGA_BITS = 8;
`else
localparam VGA_BITS = 6;
`endif

`ifdef USE_HDMI
localparam bit HDMI = 1;
assign HDMI_RST = 1'b1;
`else
localparam bit HDMI = 0;
`endif

`ifdef BIG_OSD
localparam bit BIG_OSD = 1;
`define SEP "-;",
`else
localparam bit BIG_OSD = 0;
`define SEP
`endif

// remove this if the 2nd chip is actually used
`ifdef DUAL_SDRAM
assign SDRAM2_A = 13'hZZZZ;
assign SDRAM2_BA = 0;
assign SDRAM2_DQML = 0;
assign SDRAM2_DQMH = 0;
assign SDRAM2_CKE = 0;
assign SDRAM2_CLK = 0;
assign SDRAM2_nCS = 1;
assign SDRAM2_DQ = 16'hZZZZ;
assign SDRAM2_nCAS = 1;
assign SDRAM2_nRAS = 1;
assign SDRAM2_nWE = 1;
`endif

`include "build_id.v"

`define CORE_NAME "RTYPE2"
//`define CORE_NAME "HHARRYU"
//`define CORE_NAME "GALLOP"
//`define CORE_NAME "LOHTJ"
//`define CORE_NAME "MRHELI"
//`define CORE_NAME "AIRDUM72"
//`define CORE_NAME "RTYPE"
wire [6:0] core_mod;

localparam CONF_STR = {
	`CORE_NAME,";;",
	"O3,Rotate Controls,Off,On;",
	"O12,Video Timings,Original,50Hz,57Hz,60Hz;",
	"O45,Scanlines,Off,25%,50%,75%;",
	"O6,Swap Joystick,Off,On;",
	"O7,Blending,Off,On;",
	"O8,Pause,Off,On;",
`ifdef DEBUG
	"O9,Layer A,On,Off;",
	"OA,Layer B,On,Off;",
	"OB,Sprites,On,Off;",
`endif
`ifndef NO_AUDIO_FILTER
	"OC,Audio Filters,On,Off;",
`endif
	`SEP
	"DIP;",
	`SEP
	"T0,Reset;",
	"V,v1.0.",`BUILD_DATE
};

wire  [1:0] vidmode   = status[2:1];
wire        rotate    = status[3];
wire  [1:0] scanlines = status[5:4];
wire        joyswap   = status[6];
wire        blend     = status[7];
wire        system_pause = status[8];
wire        en_layer_a = ~status[9];
wire        en_layer_b = ~status[10];
wire        en_sprites = ~status[11];
wire        video_50hz = vidmode == 1;
wire        video_57hz = vidmode == 2;
wire        video_60hz = vidmode == 3;
`ifdef NO_AUDIO_FILTER
wire        filters = 0;
`else
wire        filters = ~status[12];
`endif
wire  [1:0] orientation = {1'b0, core_mod[0]};
reg         oneplayer = 0;
wire [15:0] dip_sw = status[31:16];

assign LED = ~ioctl_downl;
assign SDRAM_CLK = CLK_96M;
assign SDRAM_CKE = 1; 

wire CLK_96M, CLK_32M;
wire pll_locked;
pll_mist pll(
	.inclk0(CLOCK_27),
	.c0(CLK_96M),
	.c1(CLK_32M),
	.locked(pll_locked)
	);

wire [31:0] status;
wire  [1:0] buttons;
wire  [1:0] switches;
wire [15:0] joystick_0;
wire [15:0] joystick_1;
wire        scandoublerD;
wire        ypbpr;
wire        no_csync;
wire        key_pressed;
wire  [7:0] key_code;
wire        key_strobe;

`ifdef USE_HDMI
wire        i2c_start;
wire        i2c_read;
wire  [6:0] i2c_addr;
wire  [7:0] i2c_subaddr;
wire  [7:0] i2c_dout;
wire  [7:0] i2c_din;
wire        i2c_ack;
wire        i2c_end;
`endif

user_io #(
	.STRLEN(($size(CONF_STR)>>3)),
	.ROM_DIRECT_UPLOAD(DIRECT_UPLOAD),
	.FEATURES(32'h0 | (BIG_OSD << 13) | (HDMI << 14)))
user_io(
	.clk_sys        (CLK_32M        ),
	.conf_str       (CONF_STR       ),
	.SPI_CLK        (SPI_SCK        ),
	.SPI_SS_IO      (CONF_DATA0     ),
	.SPI_MISO       (SPI_DO         ),
	.SPI_MOSI       (SPI_DI         ),
	.buttons        (buttons        ),
	.switches       (switches       ),
	.scandoubler_disable (scandoublerD	  ),
	.ypbpr          (ypbpr          ),
	.no_csync       (no_csync       ),
`ifdef USE_HDMI
	.i2c_start      (i2c_start      ),
	.i2c_read       (i2c_read       ),
	.i2c_addr       (i2c_addr       ),
	.i2c_subaddr    (i2c_subaddr    ),
	.i2c_dout       (i2c_dout       ),
	.i2c_din        (i2c_din        ),
	.i2c_ack        (i2c_ack        ),
	.i2c_end        (i2c_end        ),
`endif
	.core_mod       (core_mod       ),
	.key_strobe     (key_strobe     ),
	.key_pressed    (key_pressed    ),
	.key_code       (key_code       ),
	.joystick_0     (joystick_0     ),
	.joystick_1     (joystick_1     ),
	.status         (status         )
	);

wire        ioctl_downl;
wire  [7:0] ioctl_index;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;

data_io #(.ROM_DIRECT_UPLOAD(DIRECT_UPLOAD)) data_io(
	.clk_sys       ( CLK_32M      ),
	.SPI_SCK       ( SPI_SCK      ),
	.SPI_SS2       ( SPI_SS2      ),
	.SPI_SS4       ( SPI_SS4      ),
	.SPI_DI        ( SPI_DI       ),
	.SPI_DO        ( SPI_DO       ),
	.clkref_n      ( 1'b0         ),
	.ioctl_download( ioctl_downl  ),
	.ioctl_index   ( ioctl_index  ),
	.ioctl_wr      ( ioctl_wr     ),
	.ioctl_addr    ( ioctl_addr   ),
	.ioctl_dout    ( ioctl_dout   )
);

// reset signal generation
reg reset = 1;
reg rom_loaded = 0;
always @(posedge CLK_32M) begin
	reg ioctl_downlD;
	reg [15:0] reset_count;
	ioctl_downlD <= ioctl_downl;

	if (status[0] | buttons[1] | ~rom_loaded) reset_count <= 16'hffff;
	else if (reset_count != 0) reset_count <= reset_count - 1'd1;

	if (ioctl_downlD & ~ioctl_downl) rom_loaded <= 1;
	reset <= reset_count != 16'h0000;

end

wire [63:0] sdr_sprite_dout;
wire [24:1] sdr_sprite_addr;
wire sdr_sprite_req, sdr_sprite_ack;
    
wire [31:0] sdr_bg_data_a;
wire [24:0] sdr_bg_addr_a;
wire sdr_bg_req_a, sdr_bg_ack_a;

wire [31:0] sdr_bg_data_b;
wire [24:0] sdr_bg_addr_b;
wire sdr_bg_req_b, sdr_bg_ack_b;

wire [15:0] sdr_cpu_dout, sdr_cpu_din;
wire [24:0] sdr_cpu_addr;
wire        sdr_cpu_req, sdr_cpu_ack;
wire  [1:0] sdr_cpu_wr_sel;
            
wire [24:0] sdr_rom_addr;
wire [15:0] sdr_rom_data;
wire  [1:0] sdr_rom_be;
wire        sdr_rom_req;
wire        sdr_rom_ack;

wire [15:0] cpu2_ram_q;
wire [24:0] sdr_z80_ram_addr;
wire  [7:0] sdr_z80_ram_data;
wire  [7:0] sdr_z80_ram_dout = sdr_z80_ram_addr[0] ? cpu2_ram_q[15:8] : cpu2_ram_q[7:0];
wire        sdr_z80_ram_we;
wire        sdr_z80_ram_cs;
wire        sdr_z80_ram_valid;

wire [24:0] sample_rom_addr;
wire [63:0] sample_rom_dout;
wire        sample_rom_req;
wire        sample_rom_ack;

wire sdr_rom_write = ioctl_downl && (ioctl_index == 0);

wire [19:0] bram_addr;
wire [7:0] bram_data;
wire [3:0] bram_cs;
wire bram_wr;

board_cfg_t board_cfg;
sdram_4w #(96) sdram
(
  .*,
  .init_n        ( pll_locked    ),
  .clk           ( CLK_96M       ),

  // Bank 0-1 ops
  .port1_a       ( sdr_rom_addr[24:1] ),
  .port1_req     ( sdr_rom_req   ),
  .port1_ack     ( sdr_rom_ack   ),
  .port1_we      ( sdr_rom_write ),
  .port1_ds      ( sdr_rom_be    ),
  .port1_d       ( sdr_rom_data  ),
  .port1_q       ( sdr_rom_ack   ),

  // Main CPU
  .cpu1_rom_addr ( ),
  .cpu1_rom_cs   ( ),
  .cpu1_rom_q    ( ),
  .cpu1_rom_valid( ),

  .cpu1_ram_req  ( sdr_cpu_req   ),
  .cpu1_ram_ack  ( sdr_cpu_ack   ),
  .cpu1_ram_addr ( sdr_cpu_addr[24:1] ),
  .cpu1_ram_we   ( |sdr_cpu_wr_sel ),
  .cpu1_ram_d    ( sdr_cpu_din   ),
  .cpu1_ram_q    ( sdr_cpu_dout  ),
  .cpu1_ram_ds   ( |sdr_cpu_wr_sel ? sdr_cpu_wr_sel : 2'b11 ),

  // Audio Z80
  .cpu2_addr     ( sdr_z80_ram_addr[24:1] ),
  .cpu2_cs       ( sdr_z80_ram_cs ),
  .cpu2_valid    ( sdr_z80_ram_valid ),
  .cpu2_d        ( {sdr_z80_ram_data, sdr_z80_ram_data} ),
  .cpu2_we       ( sdr_z80_ram_we  ),
  .cpu2_ds       ( {sdr_z80_ram_addr[0], ~sdr_z80_ram_addr[0]} ),
  .cpu2_q        ( cpu2_ram_q      ),

  //
  .cpu3_addr     (  ),
  .cpu3_req      (  ),
  .cpu3_q        (  ),
  .cpu3_ack      (  ),

  // Bank 2-3 ops
  .port2_a       ( sdr_rom_addr[24:1] ),
  .port2_req     ( sdr_rom_req     ),
  .port2_ack     ( sdr_rom_ack     ),
  .port2_we      ( sdr_rom_write   ),
  .port2_ds      ( sdr_rom_be      ),
  .port2_d       ( sdr_rom_data    ),
  .port2_q       ( sdr_rom_ack     ),

  .gfx1_req      ( sdr_bg_req_a    ),
  .gfx1_ack      ( sdr_bg_ack_a    ),
  .gfx1_addr     ( sdr_bg_addr_a[24:1] ),
  .gfx1_q        ( sdr_bg_data_a   ),
  
  .gfx2_req      ( sdr_bg_req_b    ),
  .gfx2_ack      ( sdr_bg_ack_b    ),
  .gfx2_addr     ( sdr_bg_addr_b[24:1] ),
  .gfx2_q        ( sdr_bg_data_b   ),

  .sample_addr   ( {sample_rom_addr[22:3], 2'b00} ),
  .sample_q      ( sample_rom_dout ),
  .sample_req    ( sample_rom_req  ),
  .sample_ack    ( sample_rom_ack  ),

  .sp_addr       ( sdr_sprite_addr ),
  .sp_req        ( sdr_sprite_req  ),
  .sp_ack        ( sdr_sprite_ack  ),
  .sp_q          ( sdr_sprite_dout )
);
 
rom_loader rom_loader(
    .sys_clk(CLK_32M),

    .ioctl_downl(ioctl_downl),
    .ioctl_wr(ioctl_wr && !ioctl_index),
    .ioctl_data(ioctl_dout[7:0]),

    .ioctl_wait(),

    .sdr_addr(sdr_rom_addr),
    .sdr_data(sdr_rom_data),
    .sdr_be(sdr_rom_be),
    .sdr_req(sdr_rom_req),
    .sdr_ack(sdr_rom_ack),

    .bram_addr(bram_addr),
    .bram_data(bram_data),
    .bram_cs(bram_cs),
    .bram_wr(bram_wr),

    .board_cfg(board_cfg)
);

wire [15:0] ch_left, ch_right;
wire [7:0] R, G, B;
wire HBlank, VBlank, HSync, VSync;
wire ce_pix;

ddr_debug_data_t ddr_debug_data;

m72 m72(
    .CLK_32M(CLK_32M),
    .CLK_96M(CLK_96M),
    .ce_pix(ce_pix),
    .reset_n(~reset),
    .HBlank(HBlank),
    .VBlank(VBlank),
    .HSync(HSync),
    .VSync(VSync),
    .R(R),
    .G(G),
    .B(B),
    .AUDIO_L(ch_left),
    .AUDIO_R(ch_right),

    .board_cfg(board_cfg),

    .coin({~m_coin2, ~m_coin1}),

    .start_buttons({~m_two_players, ~m_one_player}),

    .p1_joystick({~m_up, ~m_down, ~m_left, ~m_right}),
    .p2_joystick({~m_up2, ~m_down2, ~m_left2, ~m_right2}),
    .p1_buttons({~m_fireA, ~m_fireB, ~m_fireC, ~m_fireD}),
    .p2_buttons({~m_fire2A, ~m_fire2B, ~m_fire2C, ~m_fire2D}),

    .dip_sw(~dip_sw),

    .sdr_sprite_addr(sdr_sprite_addr),
    .sdr_sprite_dout(sdr_sprite_dout),
    .sdr_sprite_req(sdr_sprite_req),
    .sdr_sprite_ack(sdr_sprite_ack),

    .sdr_bg_data_a(sdr_bg_data_a),
    .sdr_bg_addr_a(sdr_bg_addr_a),
    .sdr_bg_req_a(sdr_bg_req_a),
    .sdr_bg_ack_a(sdr_bg_ack_a),

    .sdr_bg_data_b(sdr_bg_data_b),
    .sdr_bg_addr_b(sdr_bg_addr_b),
    .sdr_bg_req_b(sdr_bg_req_b),
    .sdr_bg_ack_b(sdr_bg_ack_b),

    .sdr_cpu_dout(sdr_cpu_dout),
    .sdr_cpu_din(sdr_cpu_din),
    .sdr_cpu_addr(sdr_cpu_addr),
    .sdr_cpu_req(sdr_cpu_req),
    .sdr_cpu_ack(sdr_cpu_ack),
    .sdr_cpu_wr_sel(sdr_cpu_wr_sel),

    .sdr_z80_ram_addr(sdr_z80_ram_addr),
    .sdr_z80_ram_data(sdr_z80_ram_data),
    .sdr_z80_ram_dout(sdr_z80_ram_dout),
    .sdr_z80_ram_we(sdr_z80_ram_we),
    .sdr_z80_ram_cs(sdr_z80_ram_cs),
    .sdr_z80_ram_valid(sdr_z80_ram_valid),

    .sample_rom_addr(sample_rom_addr),
    .sample_rom_dout(sample_rom_dout),
    .sample_rom_req(sample_rom_req),
    .sample_rom_ack(sample_rom_ack),

    .clk_bram(CLK_32M),
    .bram_addr(bram_addr),
    .bram_data(bram_data),
    .bram_cs(bram_cs),
    .bram_wr(bram_wr),

`ifdef M72_DEBUG
    .pause_rq(system_pause | debug_stall),
`else
    .pause_rq(system_pause),
`endif
    .en_layer_a(en_layer_a),
    .en_layer_b(en_layer_b),
    .en_sprites(en_sprites),
    .en_layer_palette(1'b1),
    .en_sprite_palette(1'b1),
    .en_audio_filters(filters),

    .sprite_freeze(dbg_sprite_freeze),

    .video_50hz(video_50hz),
    .video_57hz(video_57hz),
    .video_60hz(video_60hz)
);

mist_video #(.COLOR_DEPTH(8), .OUT_COLOR_DEPTH(VGA_BITS), .BIG_OSD(BIG_OSD), .SD_HCNT_WIDTH(10), .USE_BLANKS(1'b1)) mist_video(
	.clk_sys        ( CLK_32M          ),
	.SPI_SCK        ( SPI_SCK          ),
	.SPI_SS3        ( SPI_SS3          ),
	.SPI_DI         ( SPI_DI           ),
	.R              ( R                ),
	.G              ( G                ),
	.B              ( B                ),
	.HBlank         ( HBlank           ),
	.VBlank         ( VBlank           ),
	.HSync          ( HSync            ),
	.VSync          ( VSync            ),
	.VGA_R          ( VGA_R            ),
	.VGA_G          ( VGA_G            ),
	.VGA_B          ( VGA_B            ),
	.VGA_VS         ( VGA_VS           ),
	.VGA_HS         ( VGA_HS           ),
	.rotate         ( { orientation[1], rotate } ),
	.ce_divider     ( 3'd1             ),
	.scandoubler_disable( scandoublerD ),
	.scanlines      ( scanlines        ),
	.blend          ( blend            ),
	.ypbpr          ( ypbpr            ),
	.no_csync       ( no_csync         )
	);

`ifdef USE_HDMI

i2c_master #(32_000_000) i2c_master (
	.CLK         (CLK_32M),

	.I2C_START   (i2c_start),
	.I2C_READ    (i2c_read),
	.I2C_ADDR    (i2c_addr),
	.I2C_SUBADDR (i2c_subaddr),
	.I2C_WDATA   (i2c_dout),
	.I2C_RDATA   (i2c_din),
	.I2C_END     (i2c_end),
	.I2C_ACK     (i2c_ack),

	//I2C bus
	.I2C_SCL     (HDMI_SCL),
 	.I2C_SDA     (HDMI_SDA)
);

mist_video #(.COLOR_DEPTH(8), .OUT_COLOR_DEPTH(8), .BIG_OSD(BIG_OSD), .SD_HCNT_WIDTH(10), .USE_BLANKS(1'b1), .VIDEO_CLEANER(1'b1)) hdmi_video(
	.clk_sys        ( CLK_32M          ),
	.SPI_SCK        ( SPI_SCK          ),
	.SPI_SS3        ( SPI_SS3          ),
	.SPI_DI         ( SPI_DI           ),
	.R              ( R                ),
	.G              ( G                ),
	.B              ( B                ),
	.HBlank         ( HBlank           ),
	.VBlank         ( VBlank           ),
	.HSync          ( HSync            ),
	.VSync          ( VSync            ),
	.VGA_R          ( HDMI_R           ),
	.VGA_G          ( HDMI_G           ),
	.VGA_B          ( HDMI_B           ),
	.VGA_VS         ( HDMI_VS          ),
	.VGA_HS         ( HDMI_HS          ),
	.VGA_DE         ( HDMI_DE          ),
	.rotate         ( { orientation[1], rotate } ),
	.ce_divider     ( 3'd1             ),
	.scandoubler_disable( 1'b0         ),
	.scanlines      ( scanlines        ),
	.blend          ( blend            ),
	.ypbpr          ( 1'b0             ),
	.no_csync       ( 1'b1             )
	);

	assign HDMI_PCLK = CLK_32M;
`endif

dac #(
	.C_bits(16))
dacl(
	.clk_i(CLK_32M),
	.res_n_i(1),
	.dac_i({~ch_left[15], ch_left[14:0]}),
	.dac_o(AUDIO_L)
	);

dac #(
	.C_bits(16))
dacr(
	.clk_i(CLK_32M),
	.res_n_i(1),
	.dac_i({~ch_right[15], ch_right[14:0]}),
	.dac_o(AUDIO_R)
	);

`ifdef I2S_AUDIO
i2s i2s (
	.reset(1'b0),
	.clk(CLK_32M),
	.clk_rate(32'd32_000_000),
	.sclk(I2S_BCK),
	.lrclk(I2S_LRCK),
	.sdata(I2S_DATA),
	.left_chan({{2{ch_left[15]}}, ch_left[14:1]}),
	.right_chan({{2{ch_right[15]}}, ch_right[14:1]})
);
`ifdef I2S_AUDIO_HDMI
assign HDMI_MCLK = 0;
always @(posedge CLK_32M) begin
	HDMI_BCK <= I2S_BCK;
	HDMI_LRCK <= I2S_LRCK;
	HDMI_SDATA <= I2S_DATA;
end
`endif
`endif

`ifdef SPDIF_AUDIO
spdif spdif (
	.rst_i(1'b0),
	.clk_i(CLK_32M),
	.clk_rate_i(32'd32_000_000),
	.spdif_o(SPDIF),
	.sample_i({{2{ch_right[15]}}, ch_right[14:1], {2{ch_left[15]}}, ch_left[14:1]})
);
`endif

wire m_up, m_down, m_left, m_right, m_fireA, m_fireB, m_fireC, m_fireD, m_fireE, m_fireF;
wire m_up2, m_down2, m_left2, m_right2, m_fire2A, m_fire2B, m_fire2C, m_fire2D, m_fire2E, m_fire2F;
wire m_tilt, m_coin1, m_coin2, m_coin3, m_coin4, m_one_player, m_two_players, m_three_players, m_four_players;

arcade_inputs #(.START1(8), .START2(10), .COIN1(9)) inputs (
	.clk         ( CLK_32M     ),
	.key_strobe  ( key_strobe  ),
	.key_pressed ( key_pressed ),
	.key_code    ( key_code    ),
	.joystick_0  ( joystick_0  ),
	.joystick_1  ( joystick_1  ),
	.rotate      ( rotate      ),
	.orientation ( orientation ),
	.joyswap     ( joyswap     ),
	.oneplayer   ( oneplayer   ),
	.controls    ( {m_tilt, m_coin4, m_coin3, m_coin2, m_coin1, m_four_players, m_three_players, m_two_players, m_one_player} ),
	.player1     ( {m_fireF, m_fireE, m_fireD, m_fireC, m_fireB, m_fireA, m_up, m_down, m_left, m_right} ),
	.player2     ( {m_fire2F, m_fire2E, m_fire2D, m_fire2C, m_fire2B, m_fire2A, m_up2, m_down2, m_left2, m_right2} )
);

endmodule 
