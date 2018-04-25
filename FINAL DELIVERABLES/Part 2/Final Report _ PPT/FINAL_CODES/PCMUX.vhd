----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2017 10:36:38 AM
-- Design Name: 
-- Module Name: PCMUX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PCMUX is
Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
       b : in  STD_LOGIC_VECTOR (31 downto 0);
       c : in  STD_LOGIC_VECTOR (31 downto 0);
       NextAddress : out  STD_LOGIC_VECTOR (31 downto 0);
       sel : in  STD_LOGIC_VECTOR (1 downto 0));
end PCMUX;

architecture Behavioral of PCMUX is

begin
with sel select
NextAddress <= a when "00",
		       b when "01",
		       c when "10",
		       "00000000000000000000000000000000" when others;
end Behavioral;