----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:52:37 11/23/2017 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
	port(
		opcode, funct: in std_logic_vector(5 downto 0);
		MemtoReg,MemWrite,ALUSrc,RegDst,RegWrite,JMP: out std_logic;
		branch : out std_logic_vector(1 downto 0);
		ALUop: out std_logic_vector(2 downto 0)
	);
end Decoder;

architecture Behavioral of Decoder is
begin
	with opcode select
		RegWrite <= '0' when "001000"| "001001" |"001010"|"001011"|"001100"|"111111",
						'1' when others;
	with opcode select
		MemtoReg <= '1' when "000111",
					   '0' when others;
	with opcode select
		MemWrite <= '1' when "001000",
						'0' when others;
	with opcode select
		ALUSrc <= '1' when "000001"|"000010"|"000011"|"000111"|"001000",
					 '0' when others;
	
	 with opcode select
	   RegDst <= '1' when "000000",
	       '0' when others;
	 
--	RegDst <= '1' when (opcode="000000" and funct="010000"|"010001"|"010010"|"010011"|"010100"),
--				 '0' when others ;
	with opcode select 
		JMP <= '1' when "001100",
				  '0' WHEN others;
	with opcode select
		branch <="01" when "001001",
					"10" when "001010",
					"11" when "001011",
					"00" when others;
	ALUop <= "000" when(opcode = "000000" and funct="010000") else
				"000" when(opcode = "000001") else
				"000" when(opcode = "000111") else
				"000" when(opcode = "001000") else
				"001" when(opcode = "000000" and funct="010001") else
				"001" when(opcode = "000010") else
				"010" when(opcode = "000000" and funct="010010") else
				"010" when(opcode = "000011") else			
				"011" when(opcode = "000100") else			
				"011" when(opcode = "000000" and funct="010011") else
				"100" when(opcode = "000000" and funct="010100") else
				"001" when(opcode = "001001") else
				"101" when(opcode = "001010") else
				"110" when(opcode = "001011") else
--				"110" when(opcode = "000101") else
--				"111" when(opcode = "000110") else
				"111";
end Behavioral;

