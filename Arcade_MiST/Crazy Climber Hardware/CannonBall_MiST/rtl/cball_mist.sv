module cball_mist (
	output        LED,
	output  [5:0] VGA_R,
	output  [5:0] VGA_G,
	output  [5:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,
	output        AUDIO_L,
	output        AUDIO_R,
	input         SPI_SCK,
	output        SPI_DO,
	input         SPI_DI,
	input         SPI_SS2,
	input         SPI_SS3,
	input         CONF_DATA0,
	input         CLOCK_27
);

`include "rtl\build_id.v" 

localparam CONF_STR = {
	"CannonBall;;",
	"O2,Rotate Controls,Off,On;",
	"O34,Scanlines,Off,25%,50%,75%;",
	"T6,Reset;",
	"V,v1.21.",`BUILD_DATE
};

assign LED = 1;
assign AUDIO_R = AUDIO_L;

wire clock_12, clock_24;
pll pll(
	.inclk0(CLOCK_27),
	.c0(clock_12),
	.c1(clock_24)
	);


wire [31:0] status;
wire  [1:0] buttons;
wire  [1:0] switches;
wire  [9:0] kbjoy;
wire  [7:0] joystick_0;
wire  [7:0] joystick_1;
wire        scandoublerD;
wire        ypbpr;
wire [10:0] ps2_key;
wire [15:0] audio;
wire hs, vs;
wire blankn;
wire [2:0] 	r, g;
wire [1:0] 	b;

ckong ckong(
	.clock_12(clock_12),
	.reset(status[0] | status[6] | buttons[1]),
	.video_r(r),
	.video_g(g),
	.video_b(b),
	.video_hs(hs),
	.video_vs(vs),
	.blankn(blankn),
	.audio_out(audio),
	.start2(btn_two_players),//used for select
	.start1(btn_one_player),
	.coin1(btn_coin),
	.fire1(m_fire),
	.right1(m_right),
	.left1(m_left),
	.down1(m_down),
	.up1(m_up),
	.fire2(m_fire),
	.right2(m_right),
	.left2(m_left),
	.down2(m_down),
	.up2(m_up)
	);
	
mist_video #(.COLOR_DEPTH(3), .SD_HCNT_WIDTH(9)) mist_video(
	.clk_sys(clock_24),
	.SPI_SCK(SPI_SCK),
	.SPI_SS3(SPI_SS3),
	.SPI_DI(SPI_DI),
	.R(blankn ? r : 0),
	.G(blankn ? g : 0),
	.B(blankn ? {b,b[1]} : 0),
	.HSync(hs),
	.VSync(vs),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_VS(VGA_VS),
	.VGA_HS(VGA_HS),
	.ce_divider(1'b0),
	.rotate({1'b1,status[2]}),
	.scanlines(scandoublerD ? 2'b00 : status[4:3]),
	.scandoubler_disable(scandoublerD),
	.ypbpr(ypbpr)
	);

user_io #(
	.STRLEN(($size(CONF_STR)>>3)))
user_io(
	.clk_sys        (clock_24       ),
	.conf_str       (CONF_STR       ),
	.SPI_CLK        (SPI_SCK        ),
	.SPI_SS_IO      (CONF_DATA0     ),
	.SPI_MISO       (SPI_DO         ),
	.SPI_MOSI       (SPI_DI         ),
	.buttons        (buttons        ),
	.switches       (switches       ),
	.scandoubler_disable (scandoublerD	  ),
	.ypbpr          (ypbpr          ),
	.key_strobe     (key_strobe     ),
	.key_pressed    (key_pressed    ),
	.key_code       (key_code       ),
	.joystick_0     (joystick_0     ),
	.joystick_1     (joystick_1     ),
	.status         (status         )
	);

dac #(
	.C_bits(15))
dac(
	.clk_i(clock_24),
	.res_n_i(1),
	.dac_i({~audio[15],audio[14:0]}),
	.dac_o(AUDIO_L)
	);

//											Rotated														Normal
wire m_up     = ~status[2] ? btn_left | joystick_0[1] | joystick_1[1] : btn_up | joystick_0[3] | joystick_1[3];
wire m_down   = ~status[2] ? btn_right | joystick_0[0] | joystick_1[0] : btn_down | joystick_0[2] | joystick_1[2];
wire m_left   = ~status[2] ? btn_down | joystick_0[2] | joystick_1[2] : btn_left | joystick_0[1] | joystick_1[1];
wire m_right  = ~status[2] ? btn_up | joystick_0[3] | joystick_1[3] : btn_right | joystick_0[0] | joystick_1[0];

wire m_fire   = btn_fire1 | joystick_0[4] | joystick_1[4];

reg btn_one_player = 0;
reg btn_two_players = 0;
reg btn_left = 0;
reg btn_right = 0;
reg btn_down = 0;
reg btn_up = 0;
reg btn_fire1 = 0;
reg btn_coin  = 0;
wire       key_pressed;
wire [7:0] key_code;
wire       key_strobe;

always @(posedge clock_24) begin
	if(key_strobe) begin
		case(key_code)
			'h75: btn_up         	<= key_pressed; // up
			'h72: btn_down        	<= key_pressed; // down
			'h6B: btn_left      	<= key_pressed; // left
			'h74: btn_right       	<= key_pressed; // right
			'h76: btn_coin			<= key_pressed; // ESC
			'h05: btn_one_player   	<= key_pressed; // F1
			'h06: btn_two_players  	<= key_pressed; // F2
			'h29: btn_fire1   		<= key_pressed; // Space
		endcase
	end
end


endmodule 
