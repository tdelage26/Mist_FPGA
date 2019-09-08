library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity swimmer_big_sprite_tile_bit2 is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(11 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of swimmer_big_sprite_tile_bit2 is
	type rom is array(0 to  4095) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"20",X"70",X"60",X"60",
		X"00",X"7D",X"FF",X"FF",X"CF",X"EF",X"EF",X"EF",X"C0",X"FE",X"FF",X"FF",X"F3",X"F7",X"F7",X"F7",
		X"00",X"00",X"00",X"00",X"00",X"38",X"38",X"39",X"00",X"00",X"00",X"10",X"08",X"44",X"E4",X"F4",
		X"30",X"33",X"3F",X"3F",X"3F",X"01",X"01",X"00",X"E6",X"EC",X"EF",X"FF",X"FF",X"FE",X"FC",X"BA",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"20",X"70",X"60",X"60",X"C0",
		X"1D",X"3F",X"3F",X"3F",X"3F",X"3F",X"3C",X"69",X"F8",X"FC",X"FC",X"FC",X"FC",X"DF",X"DF",X"BF",
		X"01",X"03",X"06",X"05",X"0D",X"0D",X"0B",X"0A",X"E0",X"30",X"D9",X"EF",X"EF",X"F7",X"37",X"D6",
		X"0A",X"0A",X"02",X"00",X"00",X"00",X"00",X"00",X"D6",X"DB",X"EB",X"EB",X"EB",X"2B",X"0B",X"03",
		X"00",X"00",X"90",X"F6",X"C0",X"FF",X"F3",X"31",X"DE",X"BE",X"7E",X"3E",X"3D",X"C3",X"FF",X"99",
		X"00",X"00",X"00",X"20",X"F2",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"08",X"0E",X"3F",X"FF",X"FF",
		X"00",X"00",X"10",X"F6",X"C0",X"FF",X"F3",X"31",X"00",X"00",X"00",X"3B",X"04",X"FF",X"DD",X"D0",
		X"00",X"00",X"90",X"F6",X"FF",X"FF",X"F3",X"31",X"00",X"00",X"00",X"00",X"C0",X"FF",X"DC",X"10",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"18",X"7C",X"FF",X"DF",X"DF",X"CC",X"00",X"00",X"00",X"00",X"C0",X"FC",X"FF",X"FF",
		X"00",X"00",X"00",X"30",X"30",X"38",X"38",X"38",X"00",X"00",X"00",X"0C",X"0C",X"1C",X"5C",X"3C",
		X"30",X"38",X"30",X"30",X"3D",X"1F",X"1F",X"0F",X"7C",X"7C",X"6C",X"CC",X"FC",X"FC",X"F8",X"F8",
		X"0D",X"04",X"09",X"0C",X"5C",X"5D",X"5A",X"78",X"F8",X"DC",X"BC",X"DC",X"DC",X"DC",X"5C",X"7C",
		X"7C",X"3C",X"1C",X"1C",X"1C",X"00",X"00",X"00",X"3C",X"3C",X"3C",X"3C",X"3C",X"7C",X"7C",X"00",
		X"1E",X"3E",X"3E",X"3A",X"3C",X"3C",X"3C",X"3C",X"1B",X"3B",X"37",X"9B",X"BA",X"33",X"7F",X"7F",
		X"7C",X"FC",X"00",X"00",X"00",X"00",X"00",X"00",X"7E",X"78",X"00",X"00",X"00",X"00",X"00",X"00",
		X"4C",X"1C",X"5D",X"5D",X"5F",X"7F",X"78",X"78",X"DF",X"DF",X"DF",X"FB",X"00",X"00",X"00",X"00",
		X"3C",X"1C",X"1C",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"10",X"08",X"0C",X"06",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"16",X"F0",X"78",X"38",X"20",X"F8",X"F9",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"E0",
		X"1C",X"3E",X"3E",X"1E",X"06",X"06",X"0E",X"0E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"60",X"C0",X"F8",X"FC",X"FF",X"81",X"81",X"81",X"81",X"81",X"81",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"04",X"0C",X"1E",X"00",X"00",X"00",X"00",X"00",X"01",X"01",X"03",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"07",X"07",X"07",X"0E",X"08",X"EF",X"FF",X"FF",X"FF",
		X"0E",X"0F",X"1F",X"7F",X"FF",X"FF",X"FF",X"FE",X"00",X"83",X"C7",X"AF",X"9F",X"DF",X"1F",X"3F",
		X"60",X"00",X"00",X"00",X"00",X"FB",X"F7",X"EF",X"3F",X"3F",X"7F",X"7F",X"FF",X"FF",X"FF",X"FF",
		X"07",X"07",X"0E",X"74",X"E6",X"E6",X"EE",X"EF",X"F8",X"F8",X"F8",X"7C",X"7C",X"5E",X"EE",X"EF",
		X"3F",X"07",X"0F",X"00",X"00",X"00",X"00",X"00",X"EF",X"0F",X"0F",X"1F",X"1E",X"1C",X"1C",X"1C",
		X"1F",X"3B",X"3D",X"3B",X"3B",X"3B",X"3A",X"3E",X"B0",X"20",X"90",X"30",X"3A",X"BA",X"5A",X"1E",
		X"3C",X"3C",X"3C",X"3C",X"3C",X"3E",X"3E",X"00",X"3E",X"3C",X"38",X"38",X"38",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"E0",X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"E0",
		X"60",X"60",X"E0",X"E0",X"E0",X"00",X"00",X"00",X"60",X"E0",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"80",X"80",X"80",X"60",X"60",X"70",X"20",X"40",X"30",X"18",X"08",
		X"80",X"80",X"C0",X"C0",X"00",X"00",X"00",X"00",X"09",X"03",X"03",X"03",X"03",X"03",X"03",X"03",
		X"1C",X"07",X"01",X"00",X"00",X"0F",X"7E",X"FE",X"3F",X"3F",X"BF",X"3F",X"7F",X"7F",X"7F",X"7F",
		X"6E",X"30",X"D8",X"CC",X"E4",X"E0",X"E0",X"C0",X"37",X"07",X"03",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FE",X"03",X"07",X"0F",X"1F",X"3C",X"00",X"00",X"00",
		X"FC",X"FC",X"F8",X"E0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"FF",X"03",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"07",X"FF",X"1F",X"00",X"00",X"03",X"0F",X"7F",X"FF",X"FF",X"C0",X"00",
		X"FE",X"FF",X"FF",X"FF",X"FF",X"7F",X"1D",X"18",X"7C",X"7E",X"3E",X"8E",X"83",X"80",X"80",X"00",
		X"F8",X"EC",X"F7",X"F0",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"20",X"70",X"F8",X"00",X"00",X"00",X"00",X"02",X"07",X"07",X"1F",
		X"00",X"00",X"00",X"01",X"03",X"03",X"07",X"07",X"3F",X"7E",X"FE",X"FC",X"D8",X"98",X"9C",X"82",
		X"01",X"03",X"07",X"0F",X"1F",X"3F",X"FF",X"FF",X"FC",X"EE",X"87",X"0F",X"0F",X"9F",X"FF",X"FF",
		X"FF",X"7C",X"1C",X"0E",X"0F",X"0F",X"0F",X"0F",X"FF",X"3F",X"7F",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"7F",X"7E",X"FC",X"FF",X"F8",X"F0",X"FF",X"E0",X"FE",X"02",X"01",X"80",X"00",X"00",X"00",X"00",
		X"C0",X"80",X"FF",X"FF",X"FC",X"FF",X"FF",X"E0",X"00",X"00",X"80",X"80",X"00",X"80",X"80",X"00",
		X"00",X"41",X"E2",X"35",X"3F",X"1F",X"1F",X"0F",X"00",X"00",X"00",X"84",X"C4",X"C6",X"C3",X"C3",
		X"0F",X"0F",X"07",X"07",X"07",X"03",X"03",X"00",X"83",X"99",X"62",X"81",X"00",X"F8",X"FE",X"7E",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"3F",X"7F",X"FF",X"3E",X"3C",X"18",X"1F",X"0F",
		X"00",X"00",X"00",X"00",X"F0",X"1C",X"3E",X"3E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",
		X"00",X"00",X"00",X"30",X"70",X"70",X"FF",X"FF",X"00",X"00",X"00",X"00",X"40",X"C0",X"D0",X"98",
		X"0F",X"0F",X"07",X"07",X"07",X"03",X"03",X"00",X"FF",X"FF",X"FF",X"FF",X"FE",X"FE",X"FC",X"F8",
		X"3F",X"3F",X"1F",X"07",X"00",X"00",X"FF",X"FF",X"E4",X"E0",X"C0",X"00",X"00",X"00",X"F8",X"FC",
		X"98",X"9C",X"0E",X"0E",X"0E",X"0F",X"0F",X"0E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",
		X"03",X"01",X"00",X"80",X"00",X"60",X"38",X"1F",X"FF",X"FF",X"03",X"00",X"00",X"00",X"00",X"F0",
		X"0F",X"0E",X"0E",X"1F",X"1F",X"1F",X"1F",X"17",X"01",X"00",X"00",X"00",X"E0",X"F0",X"F8",X"F8",
		X"08",X"0C",X"0A",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"FC",X"00",X"0F",X"7E",X"FE",
		X"0F",X"0F",X"0F",X"1F",X"0F",X"1F",X"3F",X"3F",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"3F",X"3F",X"FF",X"1F",X"7F",X"7F",X"7F",X"7F",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FE",
		X"F0",X"F0",X"FE",X"FE",X"FE",X"FE",X"FE",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FC",
		X"FF",X"FF",X"FF",X"FF",X"E0",X"C0",X"7F",X"60",X"FF",X"FF",X"FF",X"FF",X"07",X"03",X"FE",X"06",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7F",X"7C",X"71",X"7E",X"3D",X"39",X"3D",X"3D",
		X"07",X"9F",X"BF",X"FF",X"FF",X"FF",X"FF",X"7F",X"1D",X"DE",X"FD",X"FC",X"FE",X"FE",X"FE",X"FE",
		X"7C",X"FE",X"FC",X"FC",X"FC",X"E0",X"E0",X"80",X"60",X"60",X"60",X"F0",X"E0",X"F0",X"F0",X"20",
		X"80",X"00",X"80",X"00",X"F0",X"FE",X"3E",X"1F",X"18",X"18",X"0E",X"04",X"10",X"10",X"20",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"E0",X"E0",X"E0",X"E0",X"20",X"20",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"60",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"60",X"20",X"20",X"20",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"60",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"60",X"60",X"20",X"20",X"20",X"00",X"00",X"00",X"80",X"40",X"60",X"60",X"3F",X"3F",X"1F",X"0E",
		X"01",X"03",X"03",X"03",X"03",X"03",X"03",X"03",X"6E",X"30",X"D8",X"CC",X"E4",X"E0",X"E0",X"C0",
		X"01",X"01",X"01",X"01",X"00",X"00",X"00",X"00",X"81",X"8F",X"1F",X"3F",X"7F",X"7F",X"FF",X"BF",
		X"37",X"07",X"03",X"00",X"00",X"00",X"00",X"00",X"FC",X"FC",X"F8",X"E0",X"00",X"00",X"00",X"00",
		X"F8",X"FC",X"FF",X"FF",X"FF",X"FF",X"FF",X"80",X"00",X"00",X"80",X"E0",X"FC",X"FF",X"FF",X"0F",
		X"78",X"3F",X"3F",X"3F",X"1F",X"06",X"00",X"00",X"1E",X"FC",X"FC",X"FC",X"F8",X"60",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"83",X"00",X"07",X"1F",X"3F",X"7F",X"FF",X"FF",X"F8",
		X"3F",X"3F",X"1F",X"07",X"00",X"00",X"00",X"00",X"E0",X"E0",X"C0",X"00",X"00",X"00",X"00",X"3C",
		X"03",X"FF",X"FF",X"FF",X"FF",X"FF",X"C0",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"F8",X"38",X"18",
		X"3E",X"3E",X"3E",X"3E",X"3E",X"3F",X"3E",X"3E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"3C",X"B8",X"BC",X"EE",X"E6",X"40",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"00",X"00",X"00",X"00",
		X"20",X"40",X"C0",X"C0",X"80",X"80",X"00",X"00",X"80",X"C0",X"E0",X"E0",X"FF",X"FF",X"FE",X"7C",
		X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"F0",X"E0",
		X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"FF",X"C0",X"C0",X"00",X"00",X"00",X"00",X"00",X"F0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"7F",X"7F",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"C0",
		X"7F",X"7F",X"00",X"00",X"00",X"00",X"00",X"7C",X"C0",X"80",X"00",X"01",X"00",X"06",X"1C",X"18",
		X"1E",X"FC",X"FC",X"FC",X"F8",X"60",X"07",X"7F",X"9F",X"0F",X"0F",X"03",X"00",X"00",X"00",X"00",
		X"07",X"0F",X"0B",X"1D",X"19",X"39",X"30",X"70",X"FA",X"DF",X"EF",X"E7",X"E3",X"E1",X"70",X"78",
		X"C0",X"F8",X"FF",X"FF",X"7F",X"00",X"00",X"00",X"01",X"00",X"80",X"FC",X"F0",X"00",X"00",X"00",
		X"0F",X"0F",X"8F",X"9F",X"5F",X"3F",X"3F",X"3F",X"F0",X"F0",X"F0",X"F8",X"78",X"7F",X"7F",X"7F",
		X"87",X"4F",X"0E",X"0C",X"09",X"00",X"00",X"00",X"E0",X"80",X"00",X"07",X"FF",X"0F",X"00",X"00",
		X"00",X"00",X"00",X"00",X"1F",X"FF",X"FF",X"E0",X"00",X"00",X"68",X"F0",X"F8",X"F8",X"88",X"08",
		X"00",X"07",X"1F",X"FF",X"FF",X"FE",X"00",X"00",X"F0",X"FC",X"E2",X"C0",X"E0",X"00",X"00",X"00",
		X"07",X"9F",X"BF",X"FF",X"FF",X"FF",X"FF",X"7F",X"FF",X"FF",X"FF",X"FF",X"FE",X"FE",X"FE",X"FE",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"C0",X"C0",X"F0",X"FE",X"FF",X"FF",X"FF",X"5F",X"28",X"40",X"60",X"C0",X"80",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"20",X"40",X"C0",X"80",X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"E0",X"C0",X"C0",X"00",X"00",X"00",X"00",X"00",
		X"00",X"82",X"C6",X"EE",X"FE",X"D6",X"C6",X"C6",X"FF",X"FF",X"FE",X"FE",X"FC",X"FC",X"F8",X"00",
		X"78",X"70",X"60",X"40",X"00",X"00",X"00",X"00",X"10",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"0F",X"07",X"03",X"00",X"00",X"00",X"00",X"00",X"F8",X"F8",X"F0",X"00",X"00",X"00",X"00",X"03",
		X"FF",X"7F",X"3F",X"1F",X"0F",X"07",X"03",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",
		X"00",X"00",X"00",X"00",X"30",X"30",X"F8",X"FC",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"1F",
		X"FF",X"FF",X"FF",X"FD",X"FC",X"F0",X"C0",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"7F",X"3E",X"00",
		X"00",X"00",X"00",X"00",X"01",X"01",X"03",X"07",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"BF",X"1E",X"00",X"FF",X"FF",X"FF",X"FF",X"BF",X"3F",X"1F",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"0E",X"0E",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"80",X"80",X"C0",X"C0",X"E0",X"E0",X"E0",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7C",X"78",X"00",X"00",X"00",X"00",X"00",X"00",
		X"3F",X"3F",X"7E",X"7E",X"FC",X"FC",X"FC",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"1F",X"3F",X"3F",X"7F",X"7F",X"FF",X"FF",X"00",X"00",X"7E",X"7E",X"18",X"18",X"18",X"18",X"18",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"F8",X"C4",X"C5",X"F9",X"C5",X"C5",X"F8",X"00",X"00",X"00",X"20",X"20",X"20",X"20",X"C0",
		X"00",X"02",X"02",X"3A",X"43",X"42",X"42",X"3A",X"00",X"00",X"0C",X"02",X"8E",X"52",X"52",X"4F",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"20",X"70",X"60",X"60",
		X"00",X"7D",X"FF",X"FF",X"CF",X"EF",X"EF",X"EF",X"C0",X"FE",X"FF",X"FF",X"F3",X"F7",X"F7",X"F7",
		X"00",X"00",X"00",X"00",X"00",X"38",X"38",X"39",X"00",X"00",X"00",X"10",X"08",X"44",X"E4",X"F4",
		X"30",X"33",X"3F",X"3F",X"3F",X"01",X"01",X"00",X"E6",X"EC",X"EF",X"FF",X"FF",X"FE",X"FC",X"BA",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"20",X"70",X"60",X"60",X"C0",
		X"1D",X"3F",X"3F",X"3F",X"3F",X"3F",X"3C",X"69",X"F8",X"FC",X"FC",X"FC",X"FC",X"DF",X"DF",X"BF",
		X"01",X"03",X"06",X"05",X"0D",X"0D",X"0B",X"0A",X"E0",X"30",X"D9",X"EF",X"EF",X"F7",X"37",X"D6",
		X"0A",X"0A",X"02",X"00",X"00",X"00",X"00",X"00",X"D6",X"DB",X"EB",X"EB",X"EB",X"2B",X"0B",X"03",
		X"00",X"00",X"90",X"F6",X"C0",X"FF",X"F3",X"31",X"DE",X"BE",X"7E",X"3E",X"3D",X"C3",X"FF",X"99",
		X"00",X"00",X"00",X"20",X"F2",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"08",X"0E",X"3F",X"FF",X"FF",
		X"00",X"00",X"10",X"F6",X"C0",X"FF",X"F3",X"31",X"00",X"00",X"00",X"3B",X"04",X"FF",X"DD",X"D0",
		X"00",X"00",X"90",X"F6",X"FF",X"FF",X"F3",X"31",X"00",X"00",X"00",X"00",X"C0",X"FF",X"DC",X"10",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"18",X"7C",X"FF",X"DF",X"DF",X"CC",X"00",X"00",X"00",X"00",X"C0",X"FC",X"FF",X"FF",
		X"00",X"00",X"00",X"30",X"30",X"38",X"38",X"38",X"00",X"00",X"00",X"0C",X"0C",X"1C",X"5C",X"3C",
		X"30",X"38",X"30",X"30",X"3D",X"1F",X"1F",X"0F",X"7C",X"7C",X"6C",X"CC",X"FC",X"FC",X"F8",X"F8",
		X"0D",X"04",X"09",X"0C",X"5C",X"5D",X"5A",X"78",X"F8",X"DC",X"BC",X"DC",X"DC",X"DC",X"5C",X"7C",
		X"7C",X"3C",X"1C",X"1C",X"1C",X"00",X"00",X"00",X"3C",X"3C",X"3C",X"3C",X"3C",X"7C",X"7C",X"00",
		X"1E",X"3E",X"3E",X"3A",X"3C",X"3C",X"3C",X"3C",X"1B",X"3B",X"37",X"9B",X"BA",X"33",X"7F",X"7F",
		X"7C",X"FC",X"00",X"00",X"00",X"00",X"00",X"00",X"7E",X"78",X"00",X"00",X"00",X"00",X"00",X"00",
		X"4C",X"1C",X"5D",X"5D",X"5F",X"7F",X"78",X"78",X"DF",X"DF",X"DF",X"FB",X"00",X"00",X"00",X"00",
		X"3C",X"1C",X"1C",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"10",X"08",X"0C",X"06",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"16",X"F0",X"78",X"38",X"20",X"F8",X"F9",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"E0",
		X"1C",X"3E",X"3E",X"1E",X"06",X"06",X"0E",X"0E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"60",X"C0",X"F8",X"FC",X"FF",X"81",X"81",X"81",X"81",X"81",X"81",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"04",X"0C",X"1E",X"00",X"00",X"00",X"00",X"00",X"01",X"01",X"03",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"07",X"07",X"07",X"0E",X"08",X"EF",X"FF",X"FF",X"FF",
		X"0E",X"0F",X"1F",X"7F",X"FF",X"FF",X"FF",X"FE",X"00",X"83",X"C7",X"AF",X"9F",X"DF",X"1F",X"3F",
		X"60",X"00",X"00",X"00",X"00",X"FB",X"F7",X"EF",X"3F",X"3F",X"7F",X"7F",X"FF",X"FF",X"FF",X"FF",
		X"07",X"07",X"0E",X"74",X"E6",X"E6",X"EE",X"EF",X"F8",X"F8",X"F8",X"7C",X"7C",X"5E",X"EE",X"EF",
		X"3F",X"07",X"0F",X"00",X"00",X"00",X"00",X"00",X"EF",X"0F",X"0F",X"1F",X"1E",X"1C",X"1C",X"1C",
		X"1F",X"3B",X"3D",X"3B",X"3B",X"3B",X"3A",X"3E",X"B0",X"20",X"90",X"30",X"3A",X"BA",X"5A",X"1E",
		X"3C",X"3C",X"3C",X"3C",X"3C",X"3E",X"3E",X"00",X"3E",X"3C",X"38",X"38",X"38",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"E0",X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"E0",
		X"60",X"60",X"E0",X"E0",X"E0",X"00",X"00",X"00",X"60",X"E0",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"80",X"80",X"80",X"60",X"60",X"70",X"20",X"40",X"30",X"18",X"08",
		X"80",X"80",X"C0",X"C0",X"00",X"00",X"00",X"00",X"09",X"03",X"03",X"03",X"03",X"03",X"03",X"03",
		X"1C",X"07",X"01",X"00",X"00",X"0F",X"7E",X"FE",X"3F",X"3F",X"BF",X"3F",X"7F",X"7F",X"7F",X"7F",
		X"6E",X"30",X"D8",X"CC",X"E4",X"E0",X"E0",X"C0",X"37",X"07",X"03",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FE",X"03",X"07",X"0F",X"1F",X"3C",X"00",X"00",X"00",
		X"FC",X"FC",X"F8",X"E0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"FF",X"03",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"07",X"FF",X"1F",X"00",X"00",X"03",X"0F",X"7F",X"FF",X"FF",X"C0",X"00",
		X"FE",X"FF",X"FF",X"FF",X"FF",X"7F",X"1D",X"18",X"7C",X"7E",X"3E",X"8E",X"83",X"80",X"80",X"00",
		X"F8",X"EC",X"F7",X"F0",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"20",X"70",X"F8",X"00",X"00",X"00",X"00",X"02",X"07",X"07",X"1F",
		X"00",X"00",X"00",X"01",X"03",X"03",X"07",X"07",X"3F",X"7E",X"FE",X"FC",X"D8",X"98",X"9C",X"82",
		X"01",X"03",X"07",X"0F",X"1F",X"3F",X"FF",X"FF",X"FC",X"EE",X"87",X"0F",X"0F",X"9F",X"FF",X"FF",
		X"FF",X"7C",X"1C",X"0E",X"0F",X"0F",X"0F",X"0F",X"FF",X"3F",X"7F",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"7F",X"7E",X"FC",X"FF",X"F8",X"F0",X"FF",X"E0",X"FE",X"02",X"01",X"80",X"00",X"00",X"00",X"00",
		X"C0",X"80",X"FF",X"FF",X"FC",X"FF",X"FF",X"E0",X"00",X"00",X"80",X"80",X"00",X"80",X"80",X"00",
		X"00",X"41",X"E2",X"35",X"3F",X"1F",X"1F",X"0F",X"00",X"00",X"00",X"84",X"C4",X"C6",X"C3",X"C3",
		X"0F",X"0F",X"07",X"07",X"07",X"03",X"03",X"00",X"83",X"99",X"62",X"81",X"00",X"F8",X"FE",X"7E",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"3F",X"7F",X"FF",X"3E",X"3C",X"18",X"1F",X"0F",
		X"00",X"00",X"00",X"00",X"F0",X"1C",X"3E",X"3E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",
		X"00",X"00",X"00",X"30",X"70",X"70",X"FF",X"FF",X"00",X"00",X"00",X"00",X"40",X"C0",X"D0",X"98",
		X"0F",X"0F",X"07",X"07",X"07",X"03",X"03",X"00",X"FF",X"FF",X"FF",X"FF",X"FE",X"FE",X"FC",X"F8",
		X"3F",X"3F",X"1F",X"07",X"00",X"00",X"FF",X"FF",X"E4",X"E0",X"C0",X"00",X"00",X"00",X"F8",X"FC",
		X"98",X"9C",X"0E",X"0E",X"0E",X"0F",X"0F",X"0E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",
		X"03",X"01",X"00",X"80",X"00",X"60",X"38",X"1F",X"FF",X"FF",X"03",X"00",X"00",X"00",X"00",X"F0",
		X"0F",X"0E",X"0E",X"1F",X"1F",X"1F",X"1F",X"17",X"01",X"00",X"00",X"00",X"E0",X"F0",X"F8",X"F8",
		X"08",X"0C",X"0A",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"FC",X"00",X"0F",X"7E",X"FE",
		X"0F",X"0F",X"0F",X"1F",X"0F",X"1F",X"3F",X"3F",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"3F",X"3F",X"FF",X"1F",X"7F",X"7F",X"7F",X"7F",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FE",
		X"F0",X"F0",X"FE",X"FE",X"FE",X"FE",X"FE",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FC",
		X"FF",X"FF",X"FF",X"FF",X"E0",X"C0",X"7F",X"60",X"FF",X"FF",X"FF",X"FF",X"07",X"03",X"FE",X"06",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7F",X"7C",X"71",X"7E",X"3D",X"39",X"3D",X"3D",
		X"07",X"9F",X"BF",X"FF",X"FF",X"FF",X"FF",X"7F",X"1D",X"DE",X"FD",X"FC",X"FE",X"FE",X"FE",X"FE",
		X"7C",X"FE",X"FC",X"FC",X"FC",X"E0",X"E0",X"80",X"60",X"60",X"60",X"F0",X"E0",X"F0",X"F0",X"20",
		X"80",X"00",X"80",X"00",X"F0",X"FE",X"3E",X"1F",X"18",X"18",X"0E",X"04",X"10",X"10",X"20",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"E0",X"E0",X"E0",X"E0",X"20",X"20",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"60",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"60",X"20",X"20",X"20",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"60",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"60",X"60",X"20",X"20",X"20",X"00",X"00",X"00",X"80",X"40",X"60",X"60",X"3F",X"3F",X"1F",X"0E",
		X"01",X"03",X"03",X"03",X"03",X"03",X"03",X"03",X"6E",X"30",X"D8",X"CC",X"E4",X"E0",X"E0",X"C0",
		X"01",X"01",X"01",X"01",X"00",X"00",X"00",X"00",X"81",X"8F",X"1F",X"3F",X"7F",X"7F",X"FF",X"BF",
		X"37",X"07",X"03",X"00",X"00",X"00",X"00",X"00",X"FC",X"FC",X"F8",X"E0",X"00",X"00",X"00",X"00",
		X"F8",X"FC",X"FF",X"FF",X"FF",X"FF",X"FF",X"80",X"00",X"00",X"80",X"E0",X"FC",X"FF",X"FF",X"0F",
		X"78",X"3F",X"3F",X"3F",X"1F",X"06",X"00",X"00",X"1E",X"FC",X"FC",X"FC",X"F8",X"60",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"83",X"00",X"07",X"1F",X"3F",X"7F",X"FF",X"FF",X"F8",
		X"3F",X"3F",X"1F",X"07",X"00",X"00",X"00",X"00",X"E0",X"E0",X"C0",X"00",X"00",X"00",X"00",X"3C",
		X"03",X"FF",X"FF",X"FF",X"FF",X"FF",X"C0",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"F8",X"38",X"18",
		X"3E",X"3E",X"3E",X"3E",X"3E",X"3F",X"3E",X"3E",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"3C",X"B8",X"BC",X"EE",X"E6",X"40",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"00",X"00",X"00",X"00",
		X"20",X"40",X"C0",X"C0",X"80",X"80",X"00",X"00",X"80",X"C0",X"E0",X"E0",X"FF",X"FF",X"FE",X"7C",
		X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"F0",X"E0",
		X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"FF",X"C0",X"C0",X"00",X"00",X"00",X"00",X"00",X"F0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"7F",X"7F",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"C0",
		X"7F",X"7F",X"00",X"00",X"00",X"00",X"00",X"7C",X"C0",X"80",X"00",X"01",X"00",X"06",X"1C",X"18",
		X"1E",X"FC",X"FC",X"FC",X"F8",X"60",X"07",X"7F",X"9F",X"0F",X"0F",X"03",X"00",X"00",X"00",X"00",
		X"07",X"0F",X"0B",X"1D",X"19",X"39",X"30",X"70",X"FA",X"DF",X"EF",X"E7",X"E3",X"E1",X"70",X"78",
		X"C0",X"F8",X"FF",X"FF",X"7F",X"00",X"00",X"00",X"01",X"00",X"80",X"FC",X"F0",X"00",X"00",X"00",
		X"0F",X"0F",X"8F",X"9F",X"5F",X"3F",X"3F",X"3F",X"F0",X"F0",X"F0",X"F8",X"78",X"7F",X"7F",X"7F",
		X"87",X"4F",X"0E",X"0C",X"09",X"00",X"00",X"00",X"E0",X"80",X"00",X"07",X"FF",X"0F",X"00",X"00",
		X"00",X"00",X"00",X"00",X"1F",X"FF",X"FF",X"E0",X"00",X"00",X"68",X"F0",X"F8",X"F8",X"88",X"08",
		X"00",X"07",X"1F",X"FF",X"FF",X"FE",X"00",X"00",X"F0",X"FC",X"E2",X"C0",X"E0",X"00",X"00",X"00",
		X"07",X"9F",X"BF",X"FF",X"FF",X"FF",X"FF",X"7F",X"FF",X"FF",X"FF",X"FF",X"FE",X"FE",X"FE",X"FE",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"C0",X"C0",X"F0",X"FE",X"FF",X"FF",X"FF",X"5F",X"28",X"40",X"60",X"C0",X"80",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"20",X"40",X"C0",X"80",X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"E0",X"C0",X"C0",X"00",X"00",X"00",X"00",X"00",
		X"00",X"82",X"C6",X"EE",X"FE",X"D6",X"C6",X"C6",X"FF",X"FF",X"FE",X"FE",X"FC",X"FC",X"F8",X"00",
		X"78",X"70",X"60",X"40",X"00",X"00",X"00",X"00",X"10",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"0F",X"07",X"03",X"00",X"00",X"00",X"00",X"00",X"F8",X"F8",X"F0",X"00",X"00",X"00",X"00",X"03",
		X"FF",X"7F",X"3F",X"1F",X"0F",X"07",X"03",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",
		X"00",X"00",X"00",X"00",X"30",X"30",X"F8",X"FC",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"1F",
		X"FF",X"FF",X"FF",X"FD",X"FC",X"F0",X"C0",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"7F",X"3E",X"00",
		X"00",X"00",X"00",X"00",X"01",X"01",X"03",X"07",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"BF",X"1E",X"00",X"FF",X"FF",X"FF",X"FF",X"BF",X"3F",X"1F",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"0E",X"0E",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"80",X"80",X"C0",X"C0",X"E0",X"E0",X"E0",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7C",X"78",X"00",X"00",X"00",X"00",X"00",X"00",
		X"3F",X"3F",X"7E",X"7E",X"FC",X"FC",X"FC",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"1F",X"3F",X"3F",X"7F",X"7F",X"FF",X"FF",X"00",X"00",X"7E",X"7E",X"18",X"18",X"18",X"18",X"18",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"F8",X"C4",X"C5",X"F9",X"C5",X"C5",X"F8",X"00",X"00",X"00",X"20",X"20",X"20",X"20",X"C0",
		X"00",X"02",X"02",X"3A",X"43",X"42",X"42",X"3A",X"00",X"00",X"0C",X"02",X"8E",X"52",X"52",X"4F");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;
