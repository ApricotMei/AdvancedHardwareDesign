----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2017 11:22:34 AM
-- Design Name: 
-- Module Name: tb_register - Behavioral
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

entity tb_register is
--  Port ( );
end tb_register;

architecture Behavioral of tb_register is
component registerfile
port(
    CLK: in std_logic;
    Instr: in std_logic_vector (31 downto 0);
    WD3: in std_logic_vector (31 downto 0);
    SrcA: out std_logic_vector (31 downto 0);
    SrcB: out std_logic_vector (31 downto 0);
    WriteData: out std_logic_vector (31 downto 0);
    RegWrite: in std_logic;
    RegDst: in std_logic;
    ALUSrc: in std_logic;
    PCPlus4: in std_logic_vector (31 downto 0);
    PCBranch: out std_logic_vector (31 downto 0)       
);
end component;
signal CLK: std_logic;
signal instr: std_logic_vector(31 downto 0);
signal result: std_logic_vector(31 downto 0);
signal SrcA: std_logic_vector (31 downto 0);
signal SrcB: std_logic_vector (31 downto 0);
signal ALUSrc: std_logic;
signal RegDst: std_logic;
signal RegWrite: std_logic;
signal WriteData: std_logic_vector (31 downto 0);
signal PCPlus4: std_logic_vector(31 downto 0);
signal PCBranch: std_logic_vector (31 downto 0);
begin
DUT: registerfile port map(CLK=>clk, Instr=> instr,WD3=>Result, SrcA=>SrcA, SrcB=> SrcB, WriteData=>WriteData, RegWrite=>RegWrite, RegDst=>RegDst, ALUSrc=>ALUSrc, PCPlus4=>PCPlus4, PCBranch=>PCBranch );
CLOCK: process
begin 
CLK <= '1';
wait for 50ns;
CLK <= '0';
wait for 50ns;
end process;

process
begin
result <="00000000000000000000000000000000";
PCPlus4<="00000000000000000000000000000000";
Instr <= "00000100000000010000000000000111";
ALUSrc <= '1';
RegDst <= '0';
RegWrite<='1';
wait for 300ns;
Instr <= "00000100000000100000000000001000";
ALUSrc <= '1';
RegDst <= '0';
RegWrite<='1';
wait for 300ns;
Instr <= "00000000010000010001100000010000";
ALUSrc <= '0';
RegDst <= '1';
RegWrite<='1';
wait for 300ns;
Instr <= "11111100000000000000000000000000";
ALUSrc <= '0';
RegDst <= '0';
RegWrite<='0';
wait;



end process;

end Behavioral;
