----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:02:12 12/02/2016 
-- Design Name: 
-- Module Name:    RF - Behavioral 
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
USE WORK.PROCESSOR_PKG.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RF is
PORT
(
		reset_reg: IN		STD_LOGIC;
		clk		: IN		STD_LOGiC;
		Rs			: IN		STD_LOGIC_VECTOR (4 downto 0);
		Rt			: IN		STD_LOGIC_VECTOR (4 downto 0);
		Rd			: IN		STD_LOGIC_VECTOR (4 downto 0);
		IsRtype	: IN		STD_LOGIC;
		IsItype	: IN		STD_LOGIC;
		wrt_enable:IN		STD_LOGIC;
		wrt_data	: IN		STD_LOGIC_VECTOR (31 downto 0);
		RD1		: OUT		STD_LOGIC_VECTOR (31 downto 0);
		RD2		: OUT		STD_LOGIC_VECTOR (31 downto 0);
		REFile_out:OUT		REG
);
end RF;

architecture Behavioral of RF is


		signal REFile : REG;

begin

RD1<=REFile(conv_integer(Rs));
RD2<=REFile(conv_integer(Rt));

PROCESS(reset_reg,clk,IsRtype,IsItype,wrt_enable,wrt_data,Rs,Rt,Rd,REFile)
begin
	IF(reset_reg='1') THEN  REFile<=(others=>(OTHERS=>'0'));
	ELSE
		if (clk'EVENT AND clk='0') then
			if(wrt_enable = '1') then
				if(isRtype = '1') THEN
					REFile(conv_integer(Rd))<=wrt_data;
				elsif (isItype = '1') then
					REFile(conv_integer(Rt))<=wrt_data;
				end if;
			end if;			
		end if;
	END IF;
REFile_out<=REFile;
END PROCESS;


end Behavioral;

