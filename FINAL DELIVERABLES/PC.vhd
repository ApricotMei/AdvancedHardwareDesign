----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:09:52 12/02/2016
-- Design Name: 
-- Module Name:    PC - Behavioral 
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
   PORT
   (	
      clr, clk	: IN     STD_LOGIC;
		new_PC   : IN		STD_LOGIC;
		IsBranch : IN		STD_LOGIC;
		IsJump	: IN		STD_LOGIC;
		IsHal		: IN		STD_LOGIC;
		Imm		: IN		STD_LOGIC_VECTOR (15 downto 0);
		Address	: IN		STD_LOGIC_VECTOR (25 downto 0);
		PCounter	: OUT		STD_LOGIC_VECTOR (31 downto 0)
   );
end PC;

architecture Behavioral of PC is
signal PCounter_tmp: STD_LOGIC_VECTOR (31 downto 0);
begin

PROCESS(clr, clk)
begin
	IF(clr='1') THEN  PCounter_tmp<=(OTHERS=>'0');
	ELSIF(clk'EVENT AND clk='1') THEN
		IF(new_PC='0') THEN
			IF(PCounter_tmp=x"FFFFFFFF") THEN   PCounter_tmp<=(OTHERS=>'0');	--back to zero when counter is maximum
			ELSE   PCounter_tmp<=PCounter_tmp + '1';										--pc=pc+1 each clk
			END IF;
		ELSIF(new_PC='1') THEN																--when there is a new PC
			IF(IsBranch='1') THEN PCounter_tmp<=PCounter_tmp+'1'+(Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm);
			ELSIF(IsJump='1') THEN PCounter_tmp<=PCounter_tmp+'1'; PCounter_tmp<=PCounter_tmp(31 downto 26) & Address;
			ELSIF(IsHal='1') THEN PCounter_tmp<=PCounter_tmp;
			END IF;
		END IF;
	END IF;
END PROCESS;

PCounter<=PCounter_tmp;

end Behavioral;

