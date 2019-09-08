library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity swimmer_tile_bit0 is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(11 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of swimmer_tile_bit0 is
	type rom is array(0 to  4095) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"02",X"02",X"1B",X"3F",X"32",X"60",X"00",X"00",X"00",X"40",X"C8",X"78",X"38",X"0E",X"0C",X"04",
		X"06",X"07",X"8F",X"8F",X"E7",X"FF",X"FF",X"F8",X"0F",X"DC",X"FE",X"FE",X"FC",X"B8",X"20",X"00",
		X"07",X"1F",X"1F",X"0F",X"00",X"00",X"03",X"1F",X"0E",X"8E",X"BE",X"FC",X"7C",X"3E",X"1F",X"0F",
		X"66",X"70",X"70",X"00",X"06",X"07",X"07",X"00",X"0F",X"1B",X"18",X"3C",X"3E",X"76",X"66",X"00",
		X"01",X"03",X"0B",X"3F",X"1F",X"7F",X"FF",X"7F",X"00",X"80",X"28",X"78",X"78",X"F0",X"E7",X"DE",
		X"FF",X"EF",X"4B",X"03",X"03",X"07",X"03",X"00",X"FE",X"FC",X"FC",X"FC",X"F6",X"E6",X"60",X"00",
		X"00",X"0E",X"1E",X"0E",X"07",X"70",X"78",X"F0",X"70",X"F0",X"30",X"F0",X"E0",X"7C",X"37",X"13",
		X"E0",X"70",X"30",X"70",X"7E",X"31",X"18",X"01",X"13",X"18",X"1E",X"0E",X"9C",X"C8",X"20",X"E0",
		X"00",X"03",X"01",X"70",X"18",X"7C",X"38",X"3C",X"60",X"10",X"10",X"00",X"00",X"06",X"02",X"00",
		X"1C",X"3C",X"3F",X"3F",X"3F",X"1E",X"00",X"00",X"06",X"01",X"A1",X"F0",X"F8",X"E8",X"28",X"00",
		X"0B",X"13",X"13",X"27",X"23",X"21",X"21",X"10",X"C0",X"C0",X"F0",X"F0",X"F8",X"FE",X"FE",X"1F",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1F",X"1C",X"18",X"02",X"0C",X"90",X"60",X"00",
		X"00",X"00",X"38",X"38",X"3C",X"38",X"38",X"38",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"7C",X"FF",X"FF",X"FF",X"C8",X"E0",X"F8",X"F8",X"00",X"A0",X"F0",X"F0",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"01",X"03",X"0F",X"1F",X"1E",X"0C",X"78",X"78",X"80",X"80",X"80",X"80",X"00",X"00",X"7F",X"4F",
		X"30",X"00",X"01",X"03",X"03",X"01",X"00",X"00",X"0F",X"0E",X"8E",X"FC",X"F8",X"80",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"03",X"0C",X"10",X"00",X"00",X"00",X"00",X"00",X"C0",X"30",X"08",
		X"00",X"00",X"00",X"20",X"4C",X"5E",X"5E",X"4E",X"00",X"00",X"00",X"04",X"32",X"7A",X"7A",X"72",
		X"20",X"19",X"00",X"9B",X"1F",X"3F",X"1B",X"13",X"04",X"98",X"00",X"98",X"F9",X"F8",X"B0",X"30",
		X"82",X"80",X"80",X"40",X"40",X"20",X"18",X"01",X"21",X"01",X"01",X"02",X"02",X"04",X"18",X"C0",
		X"00",X"3C",X"66",X"66",X"66",X"66",X"66",X"3C",X"00",X"18",X"38",X"18",X"18",X"18",X"18",X"3C",
		X"00",X"3C",X"66",X"0E",X"1C",X"38",X"70",X"7E",X"00",X"3C",X"66",X"06",X"1C",X"06",X"66",X"3C",
		X"00",X"0C",X"1C",X"2C",X"6C",X"6C",X"7E",X"0C",X"00",X"7C",X"60",X"60",X"7C",X"06",X"66",X"3C",
		X"00",X"3C",X"66",X"60",X"7C",X"66",X"66",X"3C",X"00",X"7E",X"66",X"06",X"0C",X"18",X"18",X"18",
		X"00",X"3C",X"66",X"66",X"3C",X"66",X"66",X"3C",X"00",X"3C",X"66",X"66",X"3E",X"06",X"66",X"3C",
		X"81",X"81",X"81",X"81",X"81",X"81",X"81",X"81",X"DB",X"DB",X"DB",X"DB",X"DB",X"DB",X"DB",X"DB",
		X"00",X"00",X"00",X"00",X"01",X"01",X"41",X"21",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"08",
		X"11",X"08",X"00",X"00",X"00",X"F0",X"00",X"00",X"10",X"20",X"00",X"00",X"00",X"0F",X"00",X"00",
		X"00",X"00",X"1C",X"22",X"2E",X"22",X"1C",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"03",X"07",X"1C",X"3C",X"78",X"70",X"00",X"00",X"E0",X"E0",X"00",X"0C",X"0C",X"0C",
		X"78",X"F8",X"F0",X"FF",X"FF",X"FF",X"90",X"C0",X"0C",X"08",X"38",X"78",X"E0",X"C0",X"00",X"00",
		X"1C",X"1E",X"0E",X"0F",X"0E",X"0F",X"1F",X"1F",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"7F",X"FF",X"F6",X"F0",X"F8",X"FE",X"FE",X"00",X"80",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"0F",X"3F",X"77",X"EF",X"DF",X"FF",X"00",X"00",X"00",X"00",X"80",X"80",X"80",X"C0",
		X"FF",X"FB",X"F8",X"FC",X"FC",X"FF",X"7F",X"FF",X"C0",X"00",X"00",X"20",X"40",X"80",X"80",X"80",
		X"00",X"00",X"00",X"00",X"1C",X"1E",X"0E",X"0F",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"1F",X"3F",X"FF",X"FF",X"F6",X"F0",X"F8",X"F8",X"00",X"00",X"80",X"00",X"00",X"00",X"00",X"00",
		X"01",X"1B",X"0F",X"3A",X"38",X"18",X"7C",X"7E",X"80",X"D8",X"F0",X"BC",X"0C",X"18",X"0E",X"06",
		X"3F",X"1F",X"0F",X"0F",X"1F",X"1F",X"3F",X"3F",X"C0",X"00",X"00",X"80",X"F8",X"F8",X"B8",X"38",
		X"00",X"0D",X"1D",X"1F",X"0F",X"3F",X"7C",X"78",X"C0",X"EC",X"EE",X"FE",X"FC",X"FE",X"1F",X"0F",
		X"30",X"30",X"60",X"C0",X"80",X"F0",X"F8",X"78",X"06",X"38",X"30",X"38",X"18",X"0E",X"1E",X"1E",
		X"00",X"00",X"38",X"3C",X"1E",X"C3",X"E0",X"78",X"00",X"00",X"1C",X"3C",X"78",X"43",X"27",X"1E",
		X"10",X"D8",X"F0",X"30",X"7C",X"FE",X"7F",X"00",X"08",X"1B",X"0F",X"0C",X"3E",X"7F",X"FE",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"60",X"80",X"30",X"7C",X"7E",X"3F",X"0F",X"00",X"06",X"01",X"0C",X"3C",X"78",X"F8",X"E0",
		X"01",X"1F",X"3F",X"7F",X"7F",X"33",X"1B",X"38",X"C0",X"C0",X"C0",X"C0",X"C0",X"F0",X"FC",X"3C",
		X"31",X"03",X"07",X"06",X"00",X"00",X"00",X"00",X"7C",X"FC",X"FC",X"78",X"00",X"00",X"00",X"00",
		X"03",X"07",X"1F",X"3F",X"7E",X"E0",X"E0",X"00",X"C0",X"C0",X"C0",X"00",X"00",X"40",X"00",X"1F",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1F",X"1C",X"1C",X"18",X"18",X"38",X"38",X"30",
		X"03",X"07",X"03",X"07",X"0F",X"0F",X"1E",X"1F",X"80",X"C0",X"C0",X"F0",X"F0",X"F8",X"F8",X"FF",
		X"38",X"39",X"33",X"67",X"6E",X"78",X"38",X"00",X"FF",X"FF",X"FC",X"80",X"00",X"00",X"00",X"00",
		X"00",X"01",X"07",X"0F",X"1F",X"18",X"18",X"18",X"00",X"80",X"80",X"80",X"80",X"00",X"00",X"FF",
		X"3C",X"3C",X"18",X"00",X"00",X"01",X"01",X"00",X"0F",X"0F",X"1E",X"3C",X"FC",X"D8",X"C0",X"C0",
		X"7A",X"78",X"60",X"60",X"7C",X"38",X"1C",X"1C",X"38",X"38",X"18",X"10",X"38",X"18",X"38",X"38",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"01",X"33",X"3B",X"1D",X"6F",X"FF",X"BF",X"00",X"80",X"D8",X"D8",X"B0",X"EC",X"FE",X"FA",
		X"3F",X"7F",X"7E",X"1C",X"1C",X"00",X"00",X"00",X"F8",X"FC",X"FC",X"38",X"38",X"00",X"00",X"00",
		X"00",X"18",X"0E",X"04",X"70",X"10",X"00",X"00",X"00",X"18",X"70",X"20",X"0E",X"08",X"00",X"00",
		X"E0",X"70",X"3A",X"5F",X"47",X"27",X"13",X"00",X"07",X"3E",X"78",X"FA",X"E2",X"E4",X"C8",X"00",
		X"0F",X"0F",X"0C",X"1F",X"1F",X"3F",X"5F",X"5F",X"E0",X"C0",X"00",X"98",X"F8",X"F8",X"FA",X"FA",
		X"4F",X"26",X"20",X"30",X"18",X"00",X"00",X"00",X"F2",X"64",X"04",X"0C",X"10",X"00",X"00",X"00",
		X"00",X"01",X"0E",X"10",X"21",X"03",X"03",X"01",X"00",X"C0",X"20",X"F8",X"FF",X"FF",X"FB",X"FB",
		X"01",X"03",X"03",X"11",X"08",X"0E",X"01",X"00",X"FB",X"F3",X"F1",X"F8",X"F8",X"00",X"C0",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"01",X"1B",X"27",X"4E",X"8C",X"38",X"FC",X"F8",X"00",X"10",X"10",X"32",X"06",X"0C",X"04",X"00",
		X"F8",X"FC",X"3E",X"8E",X"4E",X"23",X"1B",X"01",X"00",X"04",X"0C",X"06",X"32",X"10",X"10",X"00",
		X"76",X"76",X"FC",X"FF",X"F2",X"F0",X"60",X"40",X"60",X"E0",X"CC",X"9C",X"9C",X"18",X"30",X"20",
		X"C0",X"60",X"70",X"F2",X"FF",X"FC",X"76",X"26",X"00",X"30",X"58",X"9C",X"9C",X"CC",X"E0",X"60",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1F",X"3F",X"F3",X"F3",X"D0",X"01",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"D3",X"FF",X"F7",X"00",X"00",X"00",
		X"01",X"05",X"C1",X"F3",X"FF",X"FF",X"FF",X"FF",X"80",X"80",X"D8",X"FA",X"FE",X"C4",X"8E",X"07",
		X"79",X"31",X"F0",X"F0",X"F0",X"00",X"05",X"01",X"0F",X"06",X"0C",X"2E",X"7A",X"D8",X"80",X"80",
		X"78",X"EC",X"E7",X"E3",X"C0",X"00",X"00",X"00",X"00",X"C0",X"E0",X"EC",X"FE",X"7E",X"38",X"3E",
		X"00",X"00",X"0E",X"DE",X"FA",X"E1",X"E1",X"00",X"3F",X"3F",X"3E",X"78",X"FE",X"FE",X"EC",X"C0",
		X"00",X"06",X"07",X"1F",X"1F",X"1F",X"07",X"03",X"C0",X"60",X"EC",X"DC",X"F8",X"F0",X"EC",X"FE",
		X"07",X"07",X"1F",X"1F",X"1F",X"06",X"00",X"00",X"FE",X"EC",X"F0",X"DC",X"EC",X"60",X"C0",X"00",
		X"00",X"00",X"04",X"0C",X"18",X"10",X"10",X"38",X"00",X"00",X"40",X"60",X"30",X"00",X"00",X"18",
		X"30",X"30",X"3C",X"3E",X"1F",X"1F",X"0F",X"0F",X"08",X"08",X"38",X"78",X"F8",X"F0",X"E0",X"C0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"C0",X"FC",X"7E",X"3F",X"0F",X"0F",X"0F",X"0C",X"05",X"3D",X"78",X"F8",X"E0",X"E0",X"C0",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1C",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"38",
		X"3E",X"7F",X"6F",X"EF",X"EF",X"CE",X"DF",X"9F",X"78",X"FC",X"EC",X"EC",X"CE",X"06",X"9E",X"FE",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"7C",X"FE",X"FF",X"EF",X"0F",X"0F",X"0F",X"00",X"3E",X"7D",X"F3",X"E7",X"E0",X"C0",X"C0",
		X"3E",X"37",X"07",X"01",X"00",X"00",X"00",X"00",X"00",X"F0",X"FC",X"7F",X"3F",X"1F",X"7F",X"3F",
		X"00",X"00",X"00",X"01",X"07",X"3F",X"16",X"00",X"1F",X"1E",X"7E",X"FF",X"FF",X"4C",X"00",X"00",
		X"03",X"07",X"0E",X"0E",X"FE",X"FE",X"7C",X"78",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"78",X"7C",X"3E",X"0E",X"0E",X"03",X"00",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"07",X"0D",X"00",X"03",X"00",X"0F",X"3F",X"FF",X"F7",X"DF",X"07",
		X"0F",X"05",X"00",X"00",X"00",X"00",X"00",X"00",X"F7",X"F7",X"DF",X"1F",X"03",X"01",X"01",X"00",
		X"F8",X"7E",X"1F",X"C3",X"FF",X"FF",X"FF",X"DE",X"00",X"00",X"00",X"80",X"80",X"80",X"00",X"00",
		X"DE",X"9F",X"8F",X"C3",X"DF",X"FE",X"F0",X"00",X"00",X"00",X"80",X"80",X"80",X"00",X"00",X"00",
		X"0C",X"1F",X"1F",X"3F",X"7F",X"7F",X"72",X"7E",X"00",X"98",X"F8",X"FC",X"FC",X"FE",X"26",X"7C",
		X"3C",X"06",X"06",X"00",X"00",X"00",X"00",X"00",X"70",X"40",X"60",X"00",X"00",X"00",X"00",X"00",
		X"1F",X"1F",X"3F",X"3F",X"7F",X"7B",X"72",X"60",X"98",X"F8",X"FC",X"FC",X"F8",X"38",X"3C",X"18",
		X"70",X"E0",X"E0",X"80",X"C0",X"C0",X"00",X"00",X"1C",X"0E",X"0E",X"04",X"06",X"04",X"00",X"00",
		X"BF",X"BF",X"3F",X"3A",X"1E",X"1C",X"0E",X"0E",X"FE",X"F8",X"F0",X"30",X"F0",X"C0",X"E0",X"E0",
		X"06",X"04",X"06",X"02",X"00",X"00",X"00",X"00",X"C0",X"80",X"C0",X"80",X"00",X"00",X"00",X"00",
		X"1F",X"1F",X"3F",X"3F",X"7F",X"7B",X"72",X"60",X"98",X"F8",X"FC",X"FC",X"FC",X"3C",X"3C",X"1C",
		X"70",X"38",X"18",X"10",X"00",X"00",X"00",X"00",X"38",X"30",X"20",X"30",X"00",X"00",X"00",X"00",
		X"00",X"00",X"01",X"01",X"01",X"07",X"06",X"00",X"00",X"F0",X"F8",X"FE",X"BF",X"BF",X"FE",X"3E",
		X"00",X"07",X"05",X"01",X"00",X"00",X"00",X"00",X"3E",X"BC",X"FC",X"BE",X"BE",X"F8",X"60",X"00",
		X"00",X"00",X"0F",X"3F",X"FC",X"FC",X"F8",X"F0",X"00",X"00",X"80",X"F0",X"98",X"0C",X"00",X"00",
		X"F0",X"F8",X"7C",X"3C",X"1F",X"00",X"00",X"00",X"00",X"0C",X"18",X"90",X"80",X"00",X"00",X"00",
		X"00",X"01",X"03",X"0F",X"06",X"00",X"00",X"00",X"00",X"F0",X"FC",X"7F",X"3F",X"1F",X"7F",X"3F",
		X"00",X"00",X"0F",X"0B",X"01",X"00",X"00",X"00",X"1F",X"1E",X"7E",X"FF",X"FF",X"FC",X"00",X"00",
		X"1C",X"1E",X"1E",X"0E",X"FE",X"FE",X"FC",X"F8",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"F8",X"FC",X"3E",X"0E",X"06",X"16",X"1A",X"1C",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"01",X"03",X"07",X"00",X"00",X"00",X"00",X"00",X"C0",X"E0",X"F0",
		X"07",X"07",X"03",X"01",X"00",X"00",X"00",X"00",X"F0",X"F0",X"E0",X"C0",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"04",X"72",X"18",X"F0",X"20",X"40",X"A0",X"20",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"40",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"44",X"C6",X"C6",X"82",X"C6",X"7C",X"7C",X"00",X"00",X"A6",X"FE",X"EE",X"6C",X"6C",X"00",
		X"00",X"00",X"00",X"81",X"87",X"CF",X"DF",X"EB",X"00",X"00",X"00",X"C0",X"C0",X"80",X"82",X"C7",
		X"C1",X"CB",X"9F",X"0F",X"07",X"01",X"00",X"00",X"FF",X"C7",X"82",X"80",X"C0",X"C0",X"00",X"00",
		X"00",X"00",X"00",X"03",X"06",X"8E",X"DB",X"C1",X"00",X"38",X"FC",X"3C",X"3E",X"1F",X"1F",X"FF",
		X"FB",X"CE",X"C6",X"83",X"80",X"00",X"00",X"00",X"1F",X"1F",X"3E",X"3C",X"FC",X"38",X"00",X"00",
		X"03",X"07",X"03",X"01",X"01",X"01",X"33",X"3F",X"80",X"C0",X"80",X"00",X"00",X"00",X"98",X"F8",
		X"3F",X"1E",X"1C",X"0E",X"04",X"02",X"0F",X"3F",X"F8",X"F0",X"70",X"E0",X"40",X"00",X"80",X"C0",
		X"07",X"0F",X"3F",X"7F",X"7F",X"79",X"21",X"21",X"C0",X"E0",X"F8",X"FC",X"FC",X"3C",X"08",X"08",
		X"13",X"1E",X"0C",X"06",X"02",X"00",X"03",X"07",X"90",X"F0",X"60",X"C0",X"80",X"80",X"E0",X"F8",
		X"00",X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"00",X"00",X"00",X"00",X"00",X"00",
		X"02",X"03",X"0B",X"0F",X"09",X"01",X"11",X"13",X"20",X"60",X"E8",X"F8",X"C8",X"C0",X"C4",X"E4",
		X"1F",X"0F",X"0E",X"07",X"03",X"01",X"07",X"1F",X"FC",X"78",X"38",X"70",X"60",X"00",X"C0",X"E0",
		X"00",X"00",X"00",X"81",X"87",X"CF",X"DF",X"FB",X"00",X"00",X"00",X"C0",X"1C",X"08",X"8F",X"FE",
		X"C1",X"DB",X"9F",X"0F",X"07",X"01",X"00",X"00",X"FC",X"FE",X"8F",X"08",X"1C",X"C0",X"00",X"00",
		X"70",X"F8",X"E0",X"F8",X"70",X"00",X"00",X"06",X"1C",X"3E",X"0E",X"3E",X"1C",X"00",X"00",X"C0",
		X"06",X"00",X"60",X"EC",X"CC",X"FC",X"FC",X"78",X"C0",X"00",X"0C",X"6E",X"66",X"7E",X"7E",X"3C",
		X"70",X"F8",X"E0",X"F8",X"70",X"00",X"00",X"0C",X"0E",X"1F",X"07",X"1F",X"0E",X"00",X"00",X"C0",
		X"0C",X"00",X"60",X"EC",X"CC",X"FC",X"FC",X"78",X"C0",X"00",X"06",X"37",X"33",X"3F",X"3F",X"1E",
		X"00",X"F8",X"F8",X"F0",X"F1",X"E3",X"E3",X"C3",X"00",X"3C",X"7E",X"FF",X"FF",X"E7",X"C3",X"C3",
		X"C3",X"E3",X"E3",X"F3",X"F3",X"FB",X"FB",X"00",X"C3",X"FF",X"FF",X"FF",X"FF",X"C3",X"C3",X"00",
		X"00",X"00",X"03",X"06",X"0F",X"1F",X"1F",X"1F",X"00",X"00",X"80",X"40",X"20",X"10",X"10",X"10",
		X"0E",X"1E",X"20",X"40",X"40",X"41",X"22",X"1C",X"20",X"30",X"08",X"04",X"04",X"04",X"88",X"70",
		X"00",X"1F",X"1F",X"1F",X"9F",X"DF",X"DF",X"DF",X"00",X"3E",X"3E",X"BE",X"BE",X"FE",X"FE",X"FE",
		X"DF",X"DF",X"DF",X"DF",X"DF",X"DF",X"DF",X"00",X"FE",X"FE",X"FE",X"7E",X"7E",X"3E",X"3E",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"03",X"00",X"00",X"00",X"00",X"31",X"E8",X"D0",X"D0",
		X"06",X"06",X"0C",X"09",X"0B",X"0F",X"0F",X"0F",X"C8",X"E0",X"70",X"38",X"BC",X"FF",X"FF",X"FF",
		X"00",X"00",X"00",X"00",X"C6",X"83",X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"80",X"C0",X"E0",
		X"01",X"03",X"07",X"0E",X"1E",X"7F",X"FF",X"FF",X"B0",X"B0",X"18",X"48",X"E8",X"F8",X"F8",X"F8",
		X"0F",X"0F",X"0F",X"09",X"0E",X"0F",X"0F",X"0F",X"FF",X"FF",X"FF",X"DF",X"AF",X"77",X"B9",X"FF",
		X"FF",X"FF",X"FF",X"FD",X"FA",X"F7",X"CE",X"FF",X"F8",X"F8",X"F8",X"C8",X"B8",X"78",X"F8",X"F8",
		X"00",X"00",X"00",X"00",X"06",X"0F",X"0F",X"04",X"00",X"00",X"00",X"00",X"30",X"78",X"78",X"20",
		X"00",X"00",X"10",X"28",X"20",X"30",X"0C",X"00",X"00",X"00",X"08",X"14",X"24",X"04",X"04",X"00",
		X"00",X"00",X"00",X"00",X"0C",X"1E",X"1E",X"08",X"00",X"00",X"00",X"00",X"60",X"F0",X"F0",X"40",
		X"00",X"00",X"1C",X"23",X"38",X"0F",X"00",X"00",X"00",X"00",X"04",X"04",X"04",X"84",X"08",X"08",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"67",X"F7",X"E3",X"60",
		X"00",X"00",X"00",X"01",X"01",X"01",X"00",X"00",X"00",X"00",X"F0",X"08",X"00",X"80",X"60",X"00",
		X"00",X"00",X"00",X"01",X"83",X"0E",X"00",X"00",X"00",X"00",X"00",X"E0",X"9C",X"02",X"00",X"00",
		X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"38",X"00",X"00",X"00",X"00",X"00",
		X"1F",X"7C",X"F1",X"E3",X"EE",X"FC",X"78",X"26",X"0C",X"06",X"47",X"67",X"37",X"3F",X"1F",X"0E",
		X"8F",X"5F",X"33",X"F3",X"26",X"4A",X"95",X"0A",X"09",X"4A",X"FC",X"7F",X"34",X"AA",X"55",X"A8",
		X"03",X"42",X"02",X"02",X"22",X"02",X"2B",X"02",X"FF",X"04",X"01",X"A4",X"01",X"28",X"04",X"42",
		X"2A",X"47",X"22",X"2B",X"14",X"44",X"29",X"0B",X"00",X"47",X"3F",X"FF",X"FD",X"EF",X"7F",X"FF",
		X"FF",X"00",X"81",X"00",X"02",X"48",X"00",X"52",X"E0",X"28",X"21",X"30",X"A5",X"28",X"04",X"20",
		X"02",X"F8",X"FE",X"DF",X"FF",X"FF",X"DB",X"FF",X"B4",X"22",X"20",X"E9",X"94",X"90",X"C8",X"E8",
		X"03",X"1F",X"3F",X"7F",X"7F",X"7F",X"3F",X"7F",X"80",X"DC",X"FE",X"FE",X"FE",X"FE",X"FF",X"FF",
		X"FF",X"FF",X"FF",X"7F",X"7F",X"7F",X"3B",X"01",X"FE",X"FC",X"FC",X"FE",X"FE",X"FE",X"FC",X"B8",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"00",X"00",X"80",X"80",X"00",X"00",X"00",X"C0",
		X"07",X"0F",X"0F",X"05",X"07",X"03",X"01",X"00",X"E0",X"F0",X"F0",X"A0",X"E0",X"C0",X"80",X"00",
		X"00",X"00",X"01",X"61",X"E0",X"F0",X"60",X"03",X"00",X"00",X"00",X"06",X"07",X"0F",X"06",X"C0",
		X"07",X"0F",X"3F",X"F5",X"F7",X"F3",X"61",X"00",X"E0",X"F0",X"FC",X"AF",X"EF",X"CF",X"86",X"00",
		X"01",X"05",X"09",X"1B",X"1F",X"1B",X"1B",X"19",X"40",X"50",X"58",X"DC",X"DC",X"DC",X"4C",X"4C",
		X"1D",X"1D",X"19",X"19",X"1D",X"1D",X"19",X"1D",X"4C",X"4C",X"5C",X"5C",X"5C",X"1C",X"5C",X"4C",
		X"3F",X"7F",X"78",X"F0",X"F0",X"F3",X"FF",X"7F",X"FF",X"FF",X"7C",X"00",X"1F",X"80",X"FD",X"FF",
		X"3F",X"1F",X"0F",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"63",X"00",X"ED",X"06",X"BF",X"FF",X"F0",X"FC",X"84",X"38",X"00",X"34",X"FF",X"FF",
		X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FA",X"DA",X"0B",X"09",X"0D",X"0D",X"0D",X"1D",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1D",X"1A",X"1A",X"1A",X"3A",X"3A",X"1A",X"30",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"10",X"28",X"78",X"74",X"F0",X"F2",
		X"AF",X"C5",X"37",X"B2",X"EF",X"D9",X"F7",X"5D",X"00",X"00",X"00",X"FF",X"A2",X"D7",X"1D",X"EF",
		X"00",X"00",X"00",X"03",X"3E",X"E9",X"DD",X"8B",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"0F",
		X"3D",X"77",X"D5",X"1C",X"A5",X"FB",X"DF",X"AD",X"00",X"00",X"00",X"03",X"0E",X"1A",X"35",X"7F",
		X"00",X"01",X"03",X"03",X"0E",X"0F",X"19",X"15",X"1F",X"3C",X"2F",X"3B",X"75",X"7D",X"6F",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"19",X"1D",X"1C",X"1D",X"1D",X"1D",X"19",X"19",X"5C",X"5C",X"5C",X"4C",X"4C",X"DC",X"DC",X"CC",
		X"19",X"19",X"18",X"19",X"1F",X"1F",X"1F",X"1F",X"4C",X"5C",X"4C",X"CC",X"FC",X"FC",X"FC",X"FC",
		X"00",X"00",X"03",X"00",X"00",X"01",X"06",X"00",X"00",X"1C",X"FE",X"BE",X"9E",X"5E",X"46",X"40",
		X"20",X"20",X"01",X"00",X"01",X"00",X"00",X"00",X"00",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"0F",X"08",X"03",X"0F",X"1F",X"3F",X"3F",X"00",X"E0",X"80",X"C0",X"F0",X"F8",X"FC",X"FC",
		X"7F",X"7F",X"7F",X"7F",X"3F",X"3F",X"1F",X"07",X"FE",X"FE",X"FE",X"FE",X"FC",X"FC",X"F8",X"E0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7F",X"1C",X"7C",X"30",X"30",X"78",X"7C",X"FC",X"FE",
		X"7F",X"7F",X"3F",X"1F",X"03",X"03",X"00",X"00",X"FE",X"FE",X"FE",X"FC",X"FC",X"F8",X"F0",X"00",
		X"00",X"00",X"03",X"01",X"07",X"01",X"02",X"00",X"00",X"00",X"00",X"D8",X"F0",X"58",X"40",X"00",
		X"0A",X"00",X"04",X"00",X"02",X"00",X"00",X"00",X"00",X"20",X"80",X"20",X"00",X"00",X"00",X"00",
		X"D7",X"35",X"1B",X"1E",X"00",X"00",X"00",X"00",X"FB",X"CE",X"05",X"07",X"02",X"02",X"03",X"01",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"97",X"DF",X"F8",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"DF",X"99",X"0C",X"0D",X"07",X"01",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"B6",X"AB",X"77",X"BE",X"6C",X"F8",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"E7",X"75",X"19",X"0E",X"03",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"BB",X"29",X"B2",X"DB",X"B7",X"FF",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"08",X"10",X"02",X"02",X"00",X"00",X"78",X"10",X"10",X"20",X"00",X"20",X"20",X"00",
		X"02",X"04",X"00",X"00",X"10",X"10",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"01",X"01",X"01",X"00",X"08",X"08",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"00",X"04",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"38",X"78",X"70",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"03",X"0F",X"1F",X"1F",X"3F",X"3F",X"00",X"00",X"C0",X"F0",X"F8",X"F8",X"FC",X"FC",
		X"3F",X"3F",X"1F",X"1F",X"0F",X"03",X"00",X"00",X"FC",X"FC",X"F8",X"F8",X"F0",X"C0",X"00",X"00",
		X"00",X"00",X"00",X"03",X"07",X"0F",X"1E",X"1D",X"00",X"00",X"80",X"E0",X"E0",X"F0",X"F0",X"F8",
		X"3D",X"3D",X"19",X"30",X"FE",X"78",X"00",X"00",X"F8",X"F0",X"C0",X"04",X"FF",X"3E",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"60",X"60",X"80",X"80",X"04",X"00",X"00",X"00",X"CC",X"CC",X"00",X"00",X"00",
		X"0C",X"18",X"10",X"00",X"01",X"FD",X"FC",X"00",X"00",X"00",X"00",X"00",X"11",X"FF",X"EE",X"00",
		X"00",X"0F",X"1F",X"3F",X"7F",X"3F",X"3F",X"3F",X"00",X"00",X"C0",X"E0",X"E0",X"F0",X"F0",X"F8",
		X"1F",X"1F",X"07",X"01",X"00",X"00",X"00",X"00",X"F8",X"F8",X"F8",X"F8",X"38",X"08",X"00",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;
