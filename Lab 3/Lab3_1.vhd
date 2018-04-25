----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:14:21 10/16/2016 
-- Design Name: 
-- Module Name:    Lab3_1 - Behavioral 
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Lab3_1 IS
PORT (
clr: IN STD_LOGIC; -- asynchronous reset
clk: IN STD_LOGIC; -- Clock signal
din: IN STD_LOGIC_VECTOR(63 DOWNTO 0);--64-bit input
dout: OUT STD_LOGIC_VECTOR(63 DOWNTO 0) --64-bit outp
);
END Lab3_1;

ARCHITECTURE rtl OF Lab3_1 IS
--round counter
SIGNAL i_cnt: STD_LOGIC_VECTOR(3 DOWNTO 0); 
SIGNAL ab_xor: STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL a_rot: STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL a: STD_LOGIC_VECTOR(31 DOWNTO 0); 
--register to store value A
SIGNAL a_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL ba_xor: STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL b_rot: STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL b: STD_LOGIC_VECTOR(31 DOWNTO 0); 
--register to store value B
SIGNAL b_reg: STD_LOGIC_VECTOR(31 DOWNTO 0);

TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);


CONSTANT skey: 
  rom:=rom'(X"00000000", X"00000000", X"46F8E8C5", X"460C6085", X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22", X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D", X"4B792F99", X"2799A4DD", X"A7901C49", X"DEDE871A",X"36C03196", X"A7EFC249", X"61A78BB8", X"3B0A1D2B", X"4DBFCA76", X"AE162167", X"30D76B0A", X"43192304", X"F6CC1431", X"65046380");
Begin
PROCESS(clr, clk)
BEGIN
  IF(clr='0') THEN 
   a_reg<=din(63 DOWNTO 32); 
  ELSIF(clk'EVENT AND clk='1') THEN 
    a_reg<=a; 
 END IF;
END PROCESS;

PROCESS(clr, clk) 
BEGIN
  IF(clr='0') THEN 
    b_reg<=din(31 DOWNTO 0); 
  ELSIF(clk'EVENT AND clk='1') THEN 
    b_reg<=b; 
  END IF;
END PROCESS;

PROCESS(clr, clk) 
BEGIN
  IF(clr='0') THEN 
    i_cnt<="0001";
  ELSIF(clk'EVENT AND clk='1') THEN 
    IF(i_cnt="1100") THEN
      i_cnt<="0001"; 
    ELSE
      i_cnt<=i_cnt+'1'; 
    END IF;
  END IF; 
END PROCESS;

 -- A=((A XOR B)<<<B) + S[2i]; 
 ab_xor <= a_reg XOR b_reg;
 WITH b_reg(4 DOWNTO 0) SELECT
  a_rot<=ab_xor(30 DOWNTO 0) & ab_xor(31) WHEN "00001",--1
      ab_xor(29 DOWNTO 0) & ab_xor(31 DOWNTO 30) WHEN "00010",--2
		ab_xor(28 DOWNTO 0) & ab_xor(31 DOWNTO 29) WHEN "00011",--3
		ab_xor(27 DOWNTO 0) & ab_xor(31 DOWNTO 28) WHEN "00100",--4
		ab_xor(26 DOWNTO 0) & ab_xor(31 DOWNTO 27) WHEN "00101",--5
		ab_xor(25 DOWNTO 0) & ab_xor(31 DOWNTO 26) WHEN "00110",--6
		ab_xor(24 DOWNTO 0) & ab_xor(31 DOWNTO 25) WHEN "00111",--7
		ab_xor(23 DOWNTO 0) & ab_xor(31 DOWNTO 24) WHEN "01000",--8
		ab_xor(22 DOWNTO 0) & ab_xor(31 DOWNTO 23) WHEN "01001",--9
		ab_xor(21 DOWNTO 0) & ab_xor(31 DOWNTO 22) WHEN "01010",--10
		ab_xor(20 DOWNTO 0) & ab_xor(31 DOWNTO 21) WHEN "01011",--11
		ab_xor(19 DOWNTO 0) & ab_xor(31 DOWNTO 20) WHEN "01100",--12
		ab_xor(18 DOWNTO 0) & ab_xor(31 DOWNTO 19) WHEN "01101",--13
		ab_xor(17 DOWNTO 0) & ab_xor(31 DOWNTO 18) WHEN "01110",--14
		ab_xor(16 DOWNTO 0) & ab_xor(31 DOWNTO 17) WHEN "01111",--15
		ab_xor(15 DOWNTO 0) & ab_xor(31 DOWNTO 16) WHEN "10000",--16
		ab_xor(14 DOWNTO 0) & ab_xor(31 DOWNTO 15) WHEN "10001",--17
		ab_xor(13 DOWNTO 0) & ab_xor(31 DOWNTO 14) WHEN "10010",--18
		ab_xor(12 DOWNTO 0) & ab_xor(31 DOWNTO 13) WHEN "10011",--19
		ab_xor(11 DOWNTO 0) & ab_xor(31 DOWNTO 12) WHEN "10100",--20
		ab_xor(10 DOWNTO 0) & ab_xor(31 DOWNTO 11) WHEN "10101",--21
		ab_xor(9 DOWNTO 0) & ab_xor(31 DOWNTO 10) WHEN "10110",--22
		ab_xor(8 DOWNTO 0) & ab_xor(31 DOWNTO 9) WHEN "10111",--23
		ab_xor(7 DOWNTO 0) & ab_xor(31 DOWNTO 8) WHEN "11000",--24
		ab_xor(6 DOWNTO 0) & ab_xor(31 DOWNTO 7) WHEN "11001",--25
		ab_xor(5 DOWNTO 0) & ab_xor(31 DOWNTO 6) WHEN "11010",--26
		ab_xor(4 DOWNTO 0) & ab_xor(31 DOWNTO 5) WHEN "11011",--27
		ab_xor(3 DOWNTO 0) & ab_xor(31 DOWNTO 4) WHEN "11100",--28
		ab_xor(2 DOWNTO 0) & ab_xor(31 DOWNTO 3) WHEN "11101",--29
		ab_xor(1 DOWNTO 0) & ab_xor(31 DOWNTO 2) WHEN "11110",--30
		ab_xor(0) & ab_xor(31 DOWNTO 1) WHEN "11111",--31
		ab_xor WHEN OTHERS;--0
 a<=a_rot + skey(CONV_INTEGER(i_cnt & '0')); --S[2xi]
 
ba_xor <= b_reg XOR a;
 WITH a(4 DOWNTO 0) SELECT
  b_rot<=ba_xor(30 DOWNTO 0) & ba_xor(31) WHEN "00001",
      ba_xor(29 DOWNTO 0) & ba_xor(31 DOWNTO 30) WHEN "00010",--2
		ba_xor(28 DOWNTO 0) & ba_xor(31 DOWNTO 29) WHEN "00011",--3
		ba_xor(27 DOWNTO 0) & ba_xor(31 DOWNTO 28) WHEN "00100",--4
		ba_xor(26 DOWNTO 0) & ba_xor(31 DOWNTO 27) WHEN "00101",--5
		ba_xor(25 DOWNTO 0) & ba_xor(31 DOWNTO 26) WHEN "00110",--6
		ba_xor(24 DOWNTO 0) & ba_xor(31 DOWNTO 25) WHEN "00111",--7
		ba_xor(23 DOWNTO 0) & ba_xor(31 DOWNTO 24) WHEN "01000",--8
		ba_xor(22 DOWNTO 0) & ba_xor(31 DOWNTO 23) WHEN "01001",--9
		ba_xor(21 DOWNTO 0) & ba_xor(31 DOWNTO 22) WHEN "01010",--10
		ba_xor(20 DOWNTO 0) & ba_xor(31 DOWNTO 21) WHEN "01011",--11
		ba_xor(19 DOWNTO 0) & ba_xor(31 DOWNTO 20) WHEN "01100",--12
		ba_xor(18 DOWNTO 0) & ba_xor(31 DOWNTO 19) WHEN "01101",--13
		ba_xor(17 DOWNTO 0) & ba_xor(31 DOWNTO 18) WHEN "01110",--14
		ba_xor(16 DOWNTO 0) & ba_xor(31 DOWNTO 17) WHEN "01111",--15
		ba_xor(15 DOWNTO 0) & ba_xor(31 DOWNTO 16) WHEN "10000",--16
		ba_xor(14 DOWNTO 0) & ba_xor(31 DOWNTO 15) WHEN "10001",--17
		ba_xor(13 DOWNTO 0) & ba_xor(31 DOWNTO 14) WHEN "10010",--18
		ba_xor(12 DOWNTO 0) & ba_xor(31 DOWNTO 13) WHEN "10011",--19
		ba_xor(11 DOWNTO 0) & ba_xor(31 DOWNTO 12) WHEN "10100",--20
		ba_xor(10 DOWNTO 0) & ba_xor(31 DOWNTO 11) WHEN "10101",--21
		ba_xor(9 DOWNTO 0) & ba_xor(31 DOWNTO 10) WHEN "10110",--22
		ba_xor(8 DOWNTO 0) & ba_xor(31 DOWNTO 9) WHEN "10111",--23
		ba_xor(7 DOWNTO 0) & ba_xor(31 DOWNTO 8) WHEN "11000",--24
		ba_xor(6 DOWNTO 0) & ba_xor(31 DOWNTO 7) WHEN "11001",--25
		ba_xor(5 DOWNTO 0) & ba_xor(31 DOWNTO 6) WHEN "11010",--26
		ba_xor(4 DOWNTO 0) & ba_xor(31 DOWNTO 5) WHEN "11011",--27
		ba_xor(3 DOWNTO 0) & ba_xor(31 DOWNTO 4) WHEN "11100",--28
		ba_xor(2 DOWNTO 0) & ba_xor(31 DOWNTO 3) WHEN "11101",--29
		ba_xor(1 DOWNTO 0) & ba_xor(31 DOWNTO 2) WHEN "11110",--30
		ba_xor(0) & ab_xor(31 DOWNTO 1) WHEN "11111",--31
		ba_xor WHEN OTHERS;--0
 b<=b_rot+skey(CONV_INTEGER(i_cnt & '1'));--S[2xi+1]

dout<=a_reg & b_reg; 
END rtl;