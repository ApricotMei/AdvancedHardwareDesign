----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nie13
-- 
-- Create Date: 12/04/2017 10:36:07 AM
-- Design Name: 
-- Module Name: tb_IM - Behavioral
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

entity tb_IM is
--  Port ( );
end tb_IM;

architecture Behavioral of tb_IM is
component IM
port(
   PCBranch: in std_logic_vector (31 downto 0);
   PCPlus4: out std_logic_vector (31 downto 0);
   Instr: out std_logic_vector (31 downto 0);
   CLK: in std_logic; 
   PCSrc: in std_logic
);
end component;

 signal  PCBranch: std_logic_vector (31 downto 0);
 signal  PCPlus4: std_logic_vector (31 downto 0);
 signal  Instr: std_logic_vector (31 downto 0);
 signal  CLK: std_logic; 
 signal  PCSrc: std_logic;

begin
DUT: IM port map(PCBranch, PCPlus4, Instr, CLK, PCSrc);


CLOCK: process
begin
    CLK <= '1';
    wait for 50ns;
    CLK <= '0';
    wait for 50ns;
end process;

process
begin
PCSrc <= '0';
PCBranch <= x"00000000";
wait;
end process;

end Behavioral;
