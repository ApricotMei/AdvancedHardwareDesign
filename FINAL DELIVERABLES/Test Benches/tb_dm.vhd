----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nie13
-- 
-- Create Date: 12/04/2017 01:09:01 PM
-- Design Name: 
-- Module Name: tb_dm - Behavioral
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

entity tb_dm is
--  Port ( );
end tb_dm;

architecture Behavioral of tb_dm is
component DataMemoryModule
port (
    InputAddr : in STD_LOGIC_VECTOR(31 downto 0);					
    WriteData  : in STD_LOGIC_VECTOR (31 downto 0);
    ReadEnable : in STD_LOGIC;
    WriteEnable : in STD_LOGIC;
    Clk : in STD_LOGIC;
    OutputData : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal ALUResult: std_logic_vector (31 downto 0);
signal WriteData: std_logic_vector (31 downto 0);
signal clk: std_logic;
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal Result: std_logic_vector (31 downto 0);
begin
DUT: DataMemoryModule port map(Clk => clk, WriteData => WriteData, InputAddr => ALUResult, OutputData => Result, ReadEnable=>MemtoReg,WriteEnable => MemWrite);

CLOCK: process
begin
clk <= '1';
wait for 50ns;
clk <= '0';
wait for 50ns;
end process;

process
begin
WriteData <= x"00000000";
MemWrite <= '0';
MemtoReg <= '0';
wait for 100ns;
ALUResult <= x"00000007";
wait for 300ns;
ALUResult <= x"00000008";
wait for 300ns;
ALUResult <= x"00000000";
wait;
end process;

end Behavioral;
