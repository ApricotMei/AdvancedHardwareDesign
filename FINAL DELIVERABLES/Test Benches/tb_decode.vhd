----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2017 11:14:36 AM
-- Design Name: 
-- Module Name: tb_decode - Behavioral
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

entity tb_decode is
--  Port ( );
end tb_decode;

architecture Behavioral of tb_decode is
component Decoder
port (
    opcode, funct: in std_logic_vector(5 downto 0);
    MemtoReg,MemWrite,ALUSrc,RegDst,RegWrite,JMP: out std_logic;
	branch : out std_logic_vector(1 downto 0);
	ALUop: out std_logic_vector(2 downto 0)
);
end component;

signal instr: std_logic_vector (31 downto 0);
signal MemtoReg: std_logic;
signal MemWrite: std_logic;
signal ALUSrc: std_logic;
signal RegDst: std_logic;
signal RegWrite: std_logic;
signal JMP: std_logic;
signal branch: std_logic_vector(1 downto 0);
signal ALUop: std_logic_vector(2 downto 0);
begin
DUT: Decoder port map(opcode=>instr(31 downto 26), funct => instr(5 downto 0), MemtoReg => MemtoReg, MemWrite => MemWrite, branch => branch, ALUop => ALUop, ALUSrc => ALUSrc, RegDst => RegDst, RegWrite => RegWrite, JMP=>JMP);
process
begin
instr <= "00000100000000010000000000000111";
wait for 300ns;
instr <= "00000100000000100000000000001000";
wait for 300ns;
instr <= "00000000010000010001100000010000";
wait for 300ns ;
instr <= "11111100000000000000000000000000";
wait;
end process;

end Behavioral;
