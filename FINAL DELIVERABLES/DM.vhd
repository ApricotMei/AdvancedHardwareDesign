----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:43:04 12/11/2016 
-- Design Name: 
-- Module Name:    DM - Behavioral 
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
use ieee.std_logic_textio.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DM is
	PORT
	(
		reset_mem,clk				 :	IN 	STD_LOGIC;
		datamemory_in      : IN		DATAMEM;
		Address_mem        :	IN		STD_LOGIC_VECTOR (31 downto 0);
		datamemory_data_out: IN		STD_LOGIC_VECTOR (31 downto 0);
		Opcode				 : IN		STD_LOGIC_VECTOR (5 downto 0);
		datamemory_data_in : OUT 	STD_LOGIC_VECTOR (31 downto 0);
		datamemory_out		 : OUT	DATAMEM
	);
end DM;

architecture Behavioral of DM is

	signal datamemory : DATAMEM;

begin

datamemory_data_in<=datamemory(conv_integer(Address_mem(5 downto 0)));

process(reset_mem,clk,datamemory_in,Address_mem,datamemory_data_out,datamemory)
begin

	IF(reset_mem='1') THEN  datamemory<=datamemory_in;
	ELSE
		if (clk'EVENT AND clk='0') then
			if (Opcode = "001000") THEN
					datamemory(conv_integer(Address_mem))<=datamemory_data_out;	
			end if;
		end if;
	END IF;
datamemory_out<=datamemory;

end process;


end Behavioral;

