----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2017 12:34:52 PM
-- Design Name: 
-- Module Name: tb_alu - Behavioral
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

entity tb_alu is
--  Port ( );
end tb_alu;

architecture Behavioral of tb_alu is
component ALU 
port(
 srcA : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        srcB : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        ALUControl: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        ALUResult : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        ALUZero: out std_logic;
        CLK: in std_logic);
 end component;
 signal SrcA: std_logic_vector (31 downto 0);
 signal SrcB: std_logic_vector (31 downto 0);
 signal zero: std_logic;
 signal ALUResult: std_logic_vector (31 downto 0);
 signal ALUop: std_logic_vector(2 downto 0);
 signal CLK: std_logic;
begin

DUT: ALU port map (srcA => SrcA, srcB => SrcB, ALUControl=>ALUop, ALUResult=>ALUResult, ALUZero => zero, CLK=> CLK);

CLOCK: process
begin
CLK <= '1';
wait for 50ns;
CLK <= '0';
wait for 50ns;
end process;


process
begin
SrcA <= x"00000000";
SrcB <= x"00000007";
ALUop <= "000";
wait for 300ns;
SrcB <= x"00000008";
wait for 300ns;
SrcB <= x"00000000";
wait for 300ns;
ALUop <= "111";
wait;
end process;

end Behavioral;
