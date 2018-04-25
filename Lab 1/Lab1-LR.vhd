----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:07:02 09/24/2016 
-- Design Name: 
-- Module Name:    Lab1-LR - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lab1_LR is
 PORT(a:in STD_LOGIC_VECTOR(31 DOWNTO 0);
      b:in STD_LOGIC_VECTOR(7 DOWNTO 0);
		o:out STD_LOGIC_VECTOR(31 DOWNTO 0));
end Lab1_LR;

architecture Behavioral of Lab1_LR is
signal c: STD_LOGIC_VECTOR(4 DOWNTO 0);
begin
 c(4 DOWNTO 0) <= b(4 DOWNTO 0);
 WITH c(4 DOWNTO 0) SELECT
 o <= a(30 DOWNTO 0) & a(31) WHEN "00001",--1
      a(29 DOWNTO 0) & a(31 DOWNTO 30) WHEN "00010",--2
		a(28 DOWNTO 0) & a(31 DOWNTO 29) WHEN "00011",--3
		a(27 DOWNTO 0) & a(31 DOWNTO 28) WHEN "00100",--4
		a(26 DOWNTO 0) & a(31 DOWNTO 27) WHEN "00101",--5
		a(25 DOWNTO 0) & a(31 DOWNTO 26) WHEN "00110",--6
		a(24 DOWNTO 0) & a(31 DOWNTO 25) WHEN "00111",--7
		a(23 DOWNTO 0) & a(31 DOWNTO 24) WHEN "01000",--8
		a(22 DOWNTO 0) & a(31 DOWNTO 23) WHEN "01001",--9
		a(21 DOWNTO 0) & a(31 DOWNTO 22) WHEN "01010",--10
		a(20 DOWNTO 0) & a(31 DOWNTO 21) WHEN "01011",--11
		a(19 DOWNTO 0) & a(31 DOWNTO 20) WHEN "01100",--12
		a(18 DOWNTO 0) & a(31 DOWNTO 19) WHEN "01101",--13
		a(17 DOWNTO 0) & a(31 DOWNTO 18) WHEN "01110",--14
		a(16 DOWNTO 0) & a(31 DOWNTO 17) WHEN "01111",--15
		a(15 DOWNTO 0) & a(31 DOWNTO 16) WHEN "10000",--16
		a(14 DOWNTO 0) & a(31 DOWNTO 15) WHEN "10001",--17
		a(13 DOWNTO 0) & a(31 DOWNTO 14) WHEN "10010",--18
		a(12 DOWNTO 0) & a(31 DOWNTO 13) WHEN "10011",--19
		a(11 DOWNTO 0) & a(31 DOWNTO 12) WHEN "10100",--20
		a(10 DOWNTO 0) & a(31 DOWNTO 11) WHEN "10101",--21
		a(9 DOWNTO 0) & a(31 DOWNTO 10) WHEN "10110",--22
		a(8 DOWNTO 0) & a(31 DOWNTO 9) WHEN "10111",--23
		a(7 DOWNTO 0) & a(31 DOWNTO 8) WHEN "11000",--24
		a(6 DOWNTO 0) & a(31 DOWNTO 7) WHEN "11001",--25
		a(5 DOWNTO 0) & a(31 DOWNTO 6) WHEN "11010",--26
		a(4 DOWNTO 0) & a(31 DOWNTO 5) WHEN "11011",--27
		a(3 DOWNTO 0) & a(31 DOWNTO 4) WHEN "11100",--28
		a(2 DOWNTO 0) & a(31 DOWNTO 3) WHEN "11101",--29
		a(1 DOWNTO 0) & a(31 DOWNTO 2) WHEN "11110",--30
		a(0) & a(31 DOWNTO 1) WHEN "11111",--31
		a WHEN OTHERS;--0
end Behavioral;

