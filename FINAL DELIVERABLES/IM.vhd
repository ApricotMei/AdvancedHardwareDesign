----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:56:33 12/02/2016 
-- Design Name: 
-- Module Name:    IM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
USE WORK.PROCESSOR_PKG.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IM is
   PORT
   (	
		PCounter	: IN		STD_LOGIC_VECTOR (31 downto 0);
		IM_in		: IN		T_MEM;
		IsItype	: OUT		STD_LOGIC;
		IsRtype	: OUT		STD_LOGIC;
		IsJtype	: OUT		STD_LOGIC;
		Opcode	: OUT		STD_LOGIC_VECTOR (5 downto 0);
		Rs			: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Rt			: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Rd			: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Shamt		: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Funct		: OUT		STD_LOGIC_VECTOR (5 downto 0);
		Imm		: OUT		STD_LOGIC_VECTOR (15 downto 0);
		Address	: OUT		STD_LOGIC_VECTOR (25 downto 0);
		IM_out	: OUT 	T_MEM
   );
end IM;

architecture Behavioral of IM is
		signal	dataout : std_logic_vector(31 downto 0);
		signal IM_rom : T_MEM;
begin

	process(PCounter,IM_rom,dataout,IM_in)
	begin
	
IM_rom<=IM_in;
dataout<=IM_rom(conv_integer(PCounter));

Opcode <= dataout(31 downto 26); 
Rs <= dataout(25 downto 21); 
Rt <= dataout(20 downto 16); 
Rd <= dataout(15 downto 11); 
Shamt <= dataout (10 downto 6); 
Funct <= dataout (5 downto 0); 
Imm <= dataout (15 downto 0);
Address <= dataout(25 downto 0);

		if (dataout(31 downto 26)="000000") THEN
			IsRtype <= '1'; 
			IsItype <= '0'; 
			IsJtype<= '0'; 
		elsif (dataout(31 downto 26) = "000001" or dataout(31 downto 26) = "000010" or dataout(31 downto 26) = "000011" or dataout(31 downto 26) = "000100" or dataout(31 downto 26) = "000101" or dataout(31 downto 26) = "000110" or dataout(31 downto 26) = "000111" or dataout(31 downto 26) = "001000" or dataout(31 downto 26) = "001001" or dataout(31 downto 26) = "001010" or dataout(31 downto 26) = "001011") THEN
			IsRtype <= '0'; 
			IsItype <= '1'; 
			IsJtype<='0'; 
		elsif (dataout(31 downto 26) = "001100" or dataout(31 downto 26) = "111111") THEN
			IsRtype <= '0'; IsItype <= '0'; IsJtype<='1';
		else
			IsRtype <= '0'; IsItype <= '0'; IsJtype<='0';
		end if;
	IM_out<=IM_rom;
	end process;
	

end Behavioral;

