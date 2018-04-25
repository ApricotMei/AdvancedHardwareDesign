----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2017 10:15:09 AM
-- Design Name: 
-- Module Name: tb_processor - Behavioral
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

entity tb_processor is
--  Port ( );
end tb_processor;

architecture Behavioral of tb_processor is
component top 
port (clk: in std_logic;
     PCout: out std_logic_vector (31 downto 0);
     ALURsultout : out std_logic_vector (31 downto 0);
     Resultout: out std_logic_vector (31 downto 0) );
end component;

signal clk: std_logic;
signal PCout: std_logic_vector (31 downto 0);
signal ALUResult:  std_logic_vector (31 downto 0);
signal Resultout: std_logic_vector (31 downto 0);


begin
DUT: top port map (clk, PCout, ALUResult, Resultout);


CLOCK: process
begin
    clk <= '1';
    wait for 50ns;
    clk <= '0';
    wait for 50ns;
end process;


end Behavioral;
