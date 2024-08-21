//============================================================================
//  Arcade: Journey by DarFPGA
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

`default_nettype none

module Journey_MiST(
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
/*
`ifdef DUAL_SDRAM
assign SDRAM2_A = 13'hZZZZ;
assign SDRAM2_BA = 0;
assign SDRAM2_DQML = 1;
assign SDRAM2_DQMH = 1;
assign SDRAM2_CKE = 0;
assign SDRAM2_CLK = 0;
assign SDRAM2_nCS = 1;
assign SDRAM2_DQ = 16'hZZZZ;
assign SDRAM2_nCAS = 1;
assign SDRAM2_nRAS = 1;
assign SDRAM2_nWE = 1;
`endif
*/
`include "build_id.v"

localparam CONF_STR = {
	"JOURNEY;;",
	"O2,Rotate Controls,Off,On;",
`ifdef DUAL_SDRAM
	"O34,Orientation,Vertical,Clockwise,Anticlockwise;",
	"O7,Rotation filter,Off,On;",
`endif
	"O5,Blend,Off,On;",
	"O6,Service,Off,On;",
	"R2048,Save NVRAM;",
//	"S0U,WAVVHD,Cas Audio:;",
	"T0,Reset;",
	"V,v1.0.",`BUILD_DATE
};

wire       rotate = status[2];
wire       blend  = status[5];
wire       service = status[6];
wire [1:0] rotate_screen = status[4:3];
wire       rotate_filter = status[7];

wire [1:0] orientation = 2'b11;

wire [7:0] input_0 = ~{ service, 1'b0, m_tilt, m_fireA, m_two_players, m_one_player, m_coin2, m_coin1 };
wire [7:0] input_1 = ~{ 4'b0000, m_down, m_up, m_right, m_left };
wire [7:0] input_2 = ~{ 3'b000, m_fire2A, m_down2, m_up2, m_right2, m_left2 };
wire [7:0] input_3 = ~{ 8'b00000010 };
wire [7:0] input_4 = 8'hFF;

assign LED = ~ioctl_downl;
assign SDRAM_CLK = clk_mem;
assign SDRAM_CKE = 1;

wire clk_sys, clk_mem;
wire pll_locked;
pll_mist pll(
	.inclk0(CLOCK_27),
	.areset(0),
	.c0(clk_mem),
	.c1(clk_sys),
	.locked(pll_locked)
	);


`ifdef DUAL_SDRAM
wire pll2_locked;
pll_mist pll2(
	.inclk0(CLOCK_27),
	.c0(SDRAM2_CLK),
	.locked(pll2_locked)
	);
assign SDRAM2_CKE = 1;
`endif

wire [31:0] status;
wire  [1:0] buttons;
wire  [1:0] switches;
wire  [31:0] joystick_0;
wire  [31:0] joystick_1;
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

wire [31:0] sd_lba;
wire sd_rd;
wire sd_ack;
wire sd_ack_conf;
wire [7:0] sd_dout;
wire sd_dout_strobe;
wire img_mounted;
wire [63:0] img_size;

user_io #(
	.STRLEN(($size(CONF_STR)>>3)),
	.FEATURES(32'h0 | (BIG_OSD << 13) | (HDMI << 14)),
	.SD_IMAGES(1)
	)
user_io(
	.clk_sys        (clk_sys        ),
	.clk_sd         (clk_sys        ),
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
	.key_strobe     (key_strobe     ),
	.key_pressed    (key_pressed    ),
	.key_code       (key_code       ),
	.joystick_0     (joystick_0     ),
	.joystick_1     (joystick_1     ),

	// SD CARD
	.sd_lba         (sd_lba        ),
	.sd_rd          (sd_rd         ),
	.sd_wr          (1'b0 ),
	.sd_ack         (sd_ack        ),
	.sd_ack_conf    (sd_ack_conf   ),
	.sd_conf        (1'b0 ),
	.sd_sdhc        (1'b1 ),
	.sd_dout        (sd_dout       ),
	.sd_dout_strobe (sd_dout_strobe),
	.sd_din         ( ),
	.sd_din_strobe  ( ),
	.sd_buff_addr   ( ),
	.img_mounted    (img_mounted   ),
	.img_size       (img_size      ),

	.status         (status         )
	);

wire [15:0] rom_addr;
wire [15:0] rom_do;
wire [13:0] snd_addr;
wire [15:0] snd_do;
wire [14:0] sp_addr;
wire [31:0] sp_do;
wire        ioctl_downl;
wire        ioctl_upl;
wire  [7:0] ioctl_index;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;
wire  [7:0] ioctl_din;

/*
ROM Structure
00000-09FFF Main CPU 40k  d2+d3+d4+d5+d6
0A000-0DFFF Snd CPU  16k  a+b+c+d
0E000-11FFF Gfx1     16k  g3+g4
12000-      Gfx2     64k  a7+a8+a5+a6+a3+a4+a1+a2
*/
data_io data_io(
	.clk_sys       ( clk_sys      ),
	.SPI_SCK       ( SPI_SCK      ),
	.SPI_SS2       ( SPI_SS2      ),
	.SPI_DI        ( SPI_DI       ),
	.SPI_DO        ( SPI_DO       ),
	.ioctl_download( ioctl_downl  ),
	.ioctl_upload  ( ioctl_upl    ),
	.ioctl_index   ( ioctl_index  ),
	.ioctl_wr      ( ioctl_wr     ),
	.ioctl_addr    ( ioctl_addr   ),
	.ioctl_dout    ( ioctl_dout   ),
	.ioctl_din     ( ioctl_din    )
);

wire [24:0] sp_ioctl_addr = ioctl_addr - 17'h12000; //SP ROM offset: 0x12000

reg port1_req, port2_req;
sdram sdram(
	.*,
	.init_n        ( pll_locked   ),
	.clk           ( clk_mem      ),

	// port1 used for main + sound CPU
	.port1_req     ( port1_req    ),
	.port1_ack     ( ),
	.port1_a       ( ioctl_addr[23:1] ),
	.port1_ds      ( {ioctl_addr[0], ~ioctl_addr[0]} ),
	.port1_we      ( ioctl_downl ),
	.port1_d       ( {ioctl_dout, ioctl_dout} ),
	.port1_q       ( ),

	.cpu1_addr     ( ioctl_downl ? 16'hffff : {1'b0, rom_addr[15:1]} ),
	.cpu1_q        ( rom_do ),
	.cpu2_addr     ( ioctl_downl ? 16'hffff : (16'h5000 + snd_addr[13:1]) ),
	.cpu2_q        ( snd_do ),

	// port2 for sprite graphics
	.port2_req     ( port2_req ),
	.port2_ack     ( ),
	.port2_a       ( {sp_ioctl_addr[23:16], sp_ioctl_addr[13:0], sp_ioctl_addr[15]} ), // merge sprite roms to 32-bit wide words
	.port2_ds      ( {sp_ioctl_addr[14], ~sp_ioctl_addr[14]} ),
	.port2_we      ( ioctl_downl ),
	.port2_d       ( {ioctl_dout, ioctl_dout} ),
	.port2_q       ( ),

	.sp_addr       ( ioctl_downl ? 15'h7fff : sp_addr ),
	.sp_q          ( sp_do )
);

// ROM download controller
always @(posedge clk_sys) begin
	reg        ioctl_wr_last = 0;

	ioctl_wr_last <= ioctl_wr;
	if (ioctl_downl) begin
		if (~ioctl_wr_last && ioctl_wr && ioctl_index == 0) begin
			port1_req <= ~port1_req;
			port2_req <= ~port2_req;
		end
	end
end

// reset signal generation
reg reset = 1;
reg rom_loaded = 0;
always @(posedge clk_sys) begin
	reg ioctl_downlD;
	reg [15:0] reset_count;
	ioctl_downlD <= ioctl_downl;

	// generate a second reset signal - needed for some reason
	if (status[0] | buttons[1] | ~rom_loaded) reset_count <= 16'hffff;
	else if (reset_count != 0) reset_count <= reset_count - 1'd1;

	if (ioctl_downlD & ~ioctl_downl) rom_loaded <= 1;
	reset <= status[0] | buttons[1] | ~rom_loaded | (reset_count == 16'h0001);

end

wire [15:0] audiol, audior;
wire        hs, vs, cs;
wire        hb, vb;
wire  [2:0] g, r, b;

wire [7:0] output_4;

journey journey(
	.clock_40(clk_sys),
	.reset(reset),
	.tv15Khz_mode(scandoublerD),
	.video_r(r),
	.video_g(g),
	.video_b(b),
	.video_hblank(hb),
	.video_vblank(vb),
	.video_hs(hs),
	.video_vs(vs),
	.video_csync(cs),
	.separate_audio(1'b1),
	.audio_out_l(audiol),
	.audio_out_r(audior),

	.input_0      ( input_0         ),
	.input_1      ( input_1         ),
	.input_2      ( input_2         ),
	.input_3      ( input_3         ),
	.input_4      ( input_4         ),
	
	.output_4     ( output_4        ),

	.cpu_rom_addr ( rom_addr        ),
	.cpu_rom_do   ( rom_addr[0] ? rom_do[15:8] : rom_do[7:0] ),
	.snd_rom_addr ( snd_addr        ),
	.snd_rom_do   ( snd_addr[0] ? snd_do[15:8] : snd_do[7:0] ),
	.sp_addr      ( sp_addr         ),
	.sp_graphx32_do ( sp_do         ),
	.dl_addr      ( ioctl_addr[16:0]),
	.dl_data      ( ioctl_dout      ),
	.dl_wr        ( ioctl_wr && ioctl_index == 0 ),
	.up_data      ( ioctl_din  ),
	.cmos_wr      ( ioctl_wr && ioctl_index == 8'hff )	
);

wire vs_out;
wire hs_out;
always @(posedge clk_sys) begin
	VGA_HS <= (~no_csync & scandoublerD & ~ypbpr)? cs : hs_out;
	VGA_VS <= (~no_csync & scandoublerD & ~ypbpr)? 1'b1 : vs_out;
end

mist_dual_video #(.SD_HCNT_WIDTH(11), .COLOR_DEPTH(3), .OUT_COLOR_DEPTH(VGA_BITS), .USE_BLANKS(1'b1), .BIG_OSD(BIG_OSD)) mist_video(
	.clk_sys        ( clk_mem          ),
	.SPI_SCK        ( SPI_SCK          ),
	.SPI_SS3        ( SPI_SS3          ),
	.SPI_DI         ( SPI_DI           ),
	.R              ( r                ),
	.G              ( g                ),
	.B              ( b                ),
	.HSync          ( hs               ),
	.VSync          ( vs               ),
	.HBlank         ( hb               ),
	.VBlank         ( vb               ),
	.VGA_R          ( VGA_R            ),
	.VGA_G          ( VGA_G            ),
	.VGA_B          ( VGA_B            ),
	.VGA_VS         ( vs_out           ),
	.VGA_HS         ( hs_out           ),
`ifdef USE_HDMI
	.HDMI_R         ( HDMI_R           ),
	.HDMI_G         ( HDMI_G           ),
	.HDMI_B         ( HDMI_B           ),
	.HDMI_VS        ( HDMI_VS          ),
	.HDMI_HS        ( HDMI_HS          ),
	.HDMI_DE        ( HDMI_DE          ),
`endif
`ifdef DUAL_SDRAM
	.clk_sdram      ( clk_mem          ),
	.sdram_init     ( ~pll2_locked     ),
	.SDRAM_A        ( SDRAM2_A         ),
	.SDRAM_DQ       ( SDRAM2_DQ        ),
	.SDRAM_DQML     ( SDRAM2_DQML      ),
	.SDRAM_DQMH     ( SDRAM2_DQMH      ),
	.SDRAM_nWE      ( SDRAM2_nWE       ),
	.SDRAM_nCAS     ( SDRAM2_nCAS      ),
	.SDRAM_nRAS     ( SDRAM2_nRAS      ),
	.SDRAM_nCS      ( SDRAM2_nCS       ),
	.SDRAM_BA       ( SDRAM2_BA        ),
`endif
	.rotate         ( { orientation[1], rotate }  ),
	.ce_divider     ( 4'd3             ),
	.blend          ( blend            ),
	.scandoubler_disable(1'b1),//scandoublerD ),
	.rotateonly     ( 1'b1),
	.rotate_screen  ( rotate_screen    ),
	.rotate_hfilter ( rotate_filter    ),
	.rotate_vfilter ( rotate_filter    ),
	.no_csync       ( 1'b1             ),
	.scanlines      ( ),
	.ypbpr          ( ypbpr            )
	);
`ifdef USE_HDMI

i2c_master #(40_000_000) i2c_master (
	.CLK         (clk_sys),

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

	assign HDMI_PCLK = clk_sys;

`endif

// Wave sound
	
wire wav_mounted;
wire [31:0] wav_addr;
wire wav_rd;
wire wav_rd_next;
wire [7:0] wav_d;
wire wav_ack;

assign wav_addr[31:28] = 4'h0;
assign sd_lba[31:23] = 8'h00;

// Bytewise interface to disk images
diskimage_by_byte waveinterface (
	.clk(clk_sys),
	.reset_n(~reset),

	.sd_lba(sd_lba),
	.sd_rd(sd_rd),
	.sd_ack(sd_ack),
	.sd_d(sd_dout),
	.sd_d_strobe(sd_dout_strobe),
	.sd_imgsize(img_size),
	.sd_imgmounted(img_mounted),

	.client_mounted(wav_mounted),
	.client_addr(wav_addr),
	.client_rd(wav_rd),
	.client_rd_next(wav_rd_next),
	.client_q(wav_d),
	.client_ack(wav_ack)
);

// Wave player

wire [15:0] wav_out_l;
wire [15:0] wav_out_r;

wire playing;

assign playing = wav_mounted && output_4[0];

wave_sound #(.SYSCLOCK(40000000)) waveplayer
(
	.I_CLK(clk_sys),
	.I_RST(reset | img_mounted),

	.I_BASE_ADDR(0),
	.I_LOOP(1'b1),
	.I_PAUSE(~playing),
	
	.O_ADDR(wav_addr),
	.O_READ(wav_rd),
	.O_READNEXT(wav_rd_next),
	.I_DATA(wav_d),
	.I_READY(wav_ack),

	.O_PCM_L(wav_out_l),
	.O_PCM_R(wav_out_r)
);


reg [16:0] audio_l_sum;
reg [16:0] audio_r_sum;

reg [16:0] dac_in_l;
reg [16:0] dac_in_r;

always @(posedge clk_sys) begin

	audio_l_sum <= {wav_out_l[15],wav_out_l} + {audiol,1'b0} - 16'h4000;
	audio_r_sum <= {wav_out_r[15],wav_out_r} + {audior,1'b0} - 16'h4000;

	dac_in_l <= {~audio_l_sum[16],audio_l_sum[15:0]}; // Convert to unsigned 17-bit
	dac_in_r <= {~audio_r_sum[16],audio_r_sum[15:0]};
end


dac #(
	.C_bits(17))
dac_l(
	.clk_i(clk_sys),
	.res_n_i(1),
	.dac_i(dac_in_l),
	.dac_o(AUDIO_L)
	);

dac #(
	.C_bits(17))
dac_r(
	.clk_i(clk_sys),
	.res_n_i(1),
	.dac_i(dac_in_r),
	.dac_o(AUDIO_R)
	);	

`ifdef I2S_AUDIO
i2s i2s (
	.reset(1'b0),
	.clk(clk_sys),
	.clk_rate(32'd40_000_000),
	.sclk(I2S_BCK),
	.lrclk(I2S_LRCK),
	.sdata(I2S_DATA),
	.left_chan(audio_l_sum[16:1]),
	.right_chan(audio_r_sum[16:1])
);
`ifdef I2S_AUDIO_HDMI
assign HDMI_MCLK = 0;
always @(posedge clk_sys) begin
	HDMI_BCK <= I2S_BCK;
	HDMI_LRCK <= I2S_LRCK;
	HDMI_SDATA <= I2S_DATA;
end
`endif
`endif

`ifdef SPDIF_AUDIO
spdif spdif (
	.rst_i(1'b0),
	.clk_i(clk_sys),
	.clk_rate_i(32'd40_000_000),
	.spdif_o(SPDIF),
	.sample_i({audio_r_sum[16:1], audio_l_sum[16:1]})
);
`endif

wire m_up, m_down, m_left, m_right, m_fireA, m_fireB, m_fireC, m_fireD, m_fireE, m_fireF;
wire m_up2, m_down2, m_left2, m_right2, m_fire2A, m_fire2B, m_fire2C, m_fire2D, m_fire2E, m_fire2F;
wire m_tilt, m_coin1, m_coin2, m_coin3, m_coin4, m_one_player, m_two_players, m_three_players, m_four_players;

arcade_inputs #(.START1(10), .START2(12), .COIN1(11)) inputs (
	.clk         ( clk_sys     ),
	.key_strobe  ( key_strobe  ),
	.key_pressed ( key_pressed ),
	.key_code    ( key_code    ),
	.joystick_0  ( joystick_0  ),
	.joystick_1  ( joystick_1  ),
	.rotate      ( rotate      ),
	.orientation ( orientation ^ {1'b0, |rotate_screen} ),
	.joyswap     ( 1'b0        ),
	.oneplayer   ( 1'b1        ),
	.controls    ( {m_tilt, m_coin4, m_coin3, m_coin2, m_coin1, m_four_players, m_three_players, m_two_players, m_one_player} ),
	.player1     ( {m_fireF, m_fireE, m_fireD, m_fireC, m_fireB, m_fireA, m_up, m_down, m_left, m_right} ),
	.player2     ( {m_fire2F, m_fire2E, m_fire2D, m_fire2C, m_fire2B, m_fire2A, m_up2, m_down2, m_left2, m_right2} )
);

endmodule 
