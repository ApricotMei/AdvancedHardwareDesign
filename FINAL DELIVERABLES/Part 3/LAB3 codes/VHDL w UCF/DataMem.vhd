------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Cem Sahin - 08/04/2009
-- modified 07/21/2015
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.final.all;
entity DataMem is
	port (
		address, WriteData: in STD_LOGIC_VECTOR (31 downto 0);
		WriteMem, ReadMem,Clk: in STD_LOGIC;
		ReadData: out STD_LOGIC_VECTOR (31 downto 0);
		key_in: in std_logic;
		memdata: out mem_array;
		ukey: in std_logic_vector(127 downto 0)
	);
end DataMem;


architecture behavioral of DataMem is	  
signal data_mem: mem_array := (
		x"b7e15163", 
		x"5618cb1c", 
		x"f45044d5",
		x"9287be8e",
		x"30bf3847",
		x"cef6b200",
		x"6d2e2bb9",
		x"0b65a572",
		x"a99d1f2b",
		x"47d498e4",
		x"e60c129d",
		x"84438c56",
		x"227b060f",
		x"c0b27fc8",
		x"5ee9f981",
		x"fd21733a",
		x"9b58ecf3",
		x"399066ac",
		x"d7c7e065",
		x"75ff5a1e",
		x"1436d3d7",
		x"b26e4d90",
		x"50a5c749",
		x"eedd4102",
		x"8d14babb",
		x"2b4c3474", 
		X"00000000", 
		X"00000000", 
		X"00000000", 
		X"00000000", --30
		X"00000000", 
		X"00000000");

begin
with ReadMem select
	ReadData <= data_mem(conv_integer(address)) when '1',
					X"00000000" when '0';
memdata <= data_mem;
mem_process: process(address, WriteData,clk, key_in)
begin
	if(key_in = '1') then 
		data_mem(0)<=  x"b7e15163"; 
		data_mem(1)<=  x"5618cb1c"; 
		data_mem(2)<=  x"f45044d5";
		data_mem(3)<=  x"9287be8e";
		data_mem(4)<=  x"30bf3847";
		data_mem(5)<=  x"cef6b200";
		data_mem(6)<=  x"6d2e2bb9";
		data_mem(7)<=  x"0b65a572";
		data_mem(8)<=  x"a99d1f2b";
		data_mem(9)<=  x"47d498e4";
		data_mem(10)<=  x"e60c129d";
		data_mem(11)<=  x"84438c56";
		data_mem(12)<=  x"227b060f";
		data_mem(13)<=  x"c0b27fc8";
		data_mem(14)<=  x"5ee9f981";
		data_mem(15)<=  x"fd21733a";
		data_mem(16)<=  x"9b58ecf3";
		data_mem(17)<=  x"399066ac";
		data_mem(18)<=  x"d7c7e065";
		data_mem(19)<=  x"75ff5a1e";
		data_mem(20)<=  x"1436d3d7";
		data_mem(21)<=  x"b26e4d90";
		data_mem(22)<=  x"50a5c749";
		data_mem(23)<=  x"eedd4102";
		data_mem(24)<=  x"8d14babb";
		data_mem(25)<=  x"2b4c3474"; 
		data_mem(26) <= ukey(31 downto 0);
		data_mem(27) <= ukey(63 downto 32);
		data_mem(28) <= ukey(95 downto 64);
		data_mem(29) <= ukey(127 downto 96);
		data_mem(30)<=  x"00000000"; 
		data_mem(31)<=  x"00000000"; 
	
	elsif (clk'event and clk = '1') then
		if (WriteMem = '1') then
			data_mem(conv_integer(address)) <= WriteData;
		end if;
	end if;
end process mem_process;

end behavioral;