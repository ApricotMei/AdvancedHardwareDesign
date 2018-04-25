----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:52:37 11/23/2016 
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
		instruction: in std_logic_vector(31 downto 0);
		wrtEnable, isload, isStore, Itype, JMP: out std_logic;
		branch : out std_logic_vector(1 downto 0);
		ALUOP: out std_logic_vector(2 downto 0)
	);
end Decoder;

architecture Behavioral of Decoder is
	signal opcode: std_logic_vector(5 downto 0);
begin
	opcode <= instruction(31 downto 26);
	with opcode select
		wrtEnable <= '0' when "001000"| "001001" |"001010"|"001011"|"001100"|"111111",
						'1' when others;
	with opcode select
		isload <= '1' when "000111",
					 '0' when others;
	with opcode select
		isstore <= '1' when "001000",
						'0' when others;
	with opcode select
		Itype <= '1' when "000001"|"000010"|"000011"|"000100"|"000101"|"000110"|"000111"|"001000"|"001001"|"001010"|"001011",
					'0' when others;
	with opcode select 
		JMP <= '1' when "001100",
				  '0' WHEN others;
	with opcode select
		branch <="01" when "001001",
					"10" when "001010",
					"11" when "001011",
					"00" when others;
	ALUOP <= "001" when(opcode = "000000" and instruction(5 downto 0)="010000") else
				"001" when(opcode = "000001") else
				"001" when(opcode = "000111") else
				"001" when(opcode = "001000") else
				"010" when(opcode = "000000" and instruction(5 downto 0)="010001") else
				"010" when(opcode = "000010") else
				"011" when(opcode = "000000" and instruction(5 downto 0)="010010") else
				"011" when(opcode = "000011") else			
				"100" when(opcode = "000100") else			
				"100" when(opcode = "000000" and instruction(5 downto 0)="010011") else
				"101" when(opcode = "000000" and instruction(5 downto 0)="010100") else
				"110" when(opcode = "000101") else
				"111" when(opcode = "000110") else
				"000";
end Behavioral;

