library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemoryModule is
		 port ( InputAddr : in STD_LOGIC_VECTOR(31 downto 0);					
				  WriteData  : in STD_LOGIC_VECTOR (31 downto 0);
				  ReadEnable : in STD_LOGIC;
				  WriteEnable : in STD_LOGIC;
				  Clk : in STD_LOGIC;
				  Reset : in STD_LOGIC;
				  OutputData : out STD_LOGIC_VECTOR (31 downto 0));
end DataMemoryModule;

architecture Behavioral of DataMemoryModule is

	type RAM is array (0 to 63) of STD_LOGIC_VECTOR (31 downto 0);
	SIGNAL data_mem: RAM:= (others => (others => '0'));

begin

	process (Clk, ReadEnable, WriteEnable, data_mem, Reset, InputAddr, WriteData) begin
--		if (rising_edge(Clk)) then
			if (Reset='1') then 
				data_mem <= (	x"00000000", x"00000000", x"00000000", x"00000000",
									x"00000000", x"00000000", x"00000000", x"00000000",
									x"00000000", x"00000000", x"9BBBD8C8", x"1A37F7FB", 
									x"46F8E8C5", x"460C6085", x"70F83B8A", x"284B8303", 
									x"513E1454", x"F621ED22", x"3125065D", x"11A83A5D", 
									x"D427686B", x"713AD82D", x"4B792F99", x"2799A4DD", 
									x"A7901C49", x"DEDE871A", x"36C03196", x"A7EFC249", 
									x"61A78BB8", x"3B0A1D2B", x"4DBFCA76", x"AE162167", 
									x"30D76B0A", x"43192304", x"F6CC1431", x"65046380", 
									x"00000000", x"00000000", x"ABCDEF01", x"FF00FF00", 
									x"97FFC053", x"0841727E", x"00000000", x"00000000",
									x"00000000", x"00000000", x"00000000", x"00000000",
									x"00000000", x"00000000", x"00000000", x"00000000",
									x"00000000", x"00000000", x"00000000", x"00000000",
									x"00000000", x"00000000", x"00000000", x"00000000",
									x"00000000", x"00000000", x"00000000", x"00000000");
			
			else
				
				if(WriteEnable = '1' and ReadEnable = '1') then
					OutputData <= WriteData;
					data_mem(CONV_INTEGER(InputAddr)) <= WriteData;
				elsif(WriteEnable='1') then		
					data_mem(CONV_INTEGER(InputAddr)) <= WriteData;
				elsif (ReadEnable='1') then
					OutputData <= data_mem(CONV_INTEGER(InputAddr));	 			
				end if;
			end if;
--		end if;	
	end process;

--	process (ReadEnable, data_mem, InputAddr) begin
--		if (ReadEnable='1') then
--			OutputData <= data_mem(CONV_INTEGER(InputAddr));	 
--		end if;
--	end process;	

end architecture;