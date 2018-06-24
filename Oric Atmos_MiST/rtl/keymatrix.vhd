library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keymatrix is
	port(
		CLK		: in std_logic;
		wROW		: in std_logic_vector(2 downto 0);
		wCOL		: in std_logic_vector(2 downto 0);
		wVAL		: in std_logic;
		wEN		: in std_logic;
		WE			: in std_logic;
		
		rCOL		: in std_logic_vector(2 downto 0);
		rROWbit	: out std_logic_vector(7 downto 0)
	);
end keymatrix;

architecture arch of keymatrix is
signal WEi : std_logic_vector(7 downto 0);

-- inutilise
signal SPOi : std_logic_vector(7 downto 0);

begin

WEi(0) <= WE when wEN = '1' and wROW = "000" else '0';
WEi(1) <= WE when wEN = '1' and wROW = "001" else '0';
WEi(2) <= WE when wEN = '1' and wROW = "010" else '0';
WEi(3) <= WE when wEN = '1' and wROW = "011" else '0';
WEi(4) <= WE when wEN = '1' and wROW = "100" else '0';
WEi(5) <= WE when wEN = '1' and wROW = "101" else '0';
WEi(6) <= WE when wEN = '1' and wROW = "110" else '0';
WEi(7) <= WE when wEN = '1' and wROW = "111" else '0';


--ROWBit : for i in 0 to 7 generate
--   RAM16X1D_ROWBit : RAM16X1D
--   generic map (
--      INIT => X"FFFF")
--   port map (

--      D => wVAL,           -- Write 1-bit data input---------------------------data

--      SPO => SPOi(i),     	-- R/W 1-bit data output for A0-A3

--      A0 => wCOL(0),       -- R/W address[0] input bit--------------------------waddress
--      A1 => wCOL(1),       -- R/W address[1] input bit
--      A2 => wCOL(2),       -- R/W address[2] input bit
--      A3 => '0',           -- R/W ddress[3] input bit


--      DPO => rROWBit(i),   -- Read-only 1-bit data output for DPRA--------------q


--      DPRA0 => rCOL(0),    -- Read-only address[0] input bit--------------------------raddress
--      DPRA1 => rCOL(1),    -- Read-only address[1] input bit
--      DPRA2 => rCOL(2),    -- Read-only address[2] input bit
--      DPRA3 => '0',        -- Read-only address[3] input bit



--      WCLK => CLK,         -- Write clock input-----------------------------------clock
 --     WE => WEi(i)         -- Write enable input----------------------------------wren
 --  );
--end generate;

ROWBit : for i in 0 to 7 generate
   RAM16X1D_ROWBit : entity work.RAM8X1D
--   generic map (
--      INIT => X"FFFF")
   port map (

      data(0) => wVAL,           -- Write 1-bit data input---------------------------data

      enable => SPOi(i),     	-- R/W 1-bit data output for A0-A3
		wraddress => wCOL,
--      A0 => wCOL(0),       -- R/W address[0] input bit--------------------------waddress
--      A1 => wCOL(1),       -- R/W address[1] input bit
--      A2 => wCOL(2),       -- R/W address[2] input bit
--      A3 => '0',           -- R/W ddress[3] input bit


--      rden => rROWBit(i),   -- Read-only 1-bit data output for DPRA--------------q

		rdaddress => rCOL,
--      DPRA0 => rCOL(0),    -- Read-only address[0] input bit--------------------------raddress
--      DPRA1 => rCOL(1),    -- Read-only address[1] input bit
--      DPRA2 => rCOL(2),    -- Read-only address[2] input bit
--      DPRA3 => '0',        -- Read-only address[3] input bit


		clock => CLK,
--      WCLK => CLK,         -- Write clock input-----------------------------------clock
      wren => WEi(i)         -- Write enable input----------------------------------wren
   );
end generate;


end arch;

