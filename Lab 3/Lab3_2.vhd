----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:22:12 10/16/2016 
-- Design Name: 
-- Module Name:    Lab3_2 - Behavioral 
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

ENTITY Lab3_2 IS
PORT (
clr: IN STD_LOGIC; -- asynchronous reset
clk: IN STD_LOGIC; -- Clock signal
din: IN STD_LOGIC_VECTOR(63 DOWNTO 0);--64-bit input
dout: OUT STD_LOGIC_VECTOR(63 DOWNTO 0) --64-bit outp
);
END Lab3_2;

ARCHITECTURE rtl OF Lab3_2 IS
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
    i_cnt<="1100";
  ELSIF(clk'EVENT AND clk='1') THEN 
    IF(i_cnt="0001") THEN
      i_cnt<="1100"; 
    ELSE
      i_cnt<=i_cnt-'1'; 
    END IF;
  END IF; 
END PROCESS;

--B=((B-S[2xi+1])>>>A) xor A;
b_rot<=b_reg-skey(CONV_INTEGER(i_cnt & '1'));--S[2xi+1]

 WITH a_reg(4 DOWNTO 0) SELECT
  ba_xor<=b_rot(0) & b_rot(31 DOWNTO 1) WHEN "00001",
      b_rot(1 DOWNTO 0) & b_rot(31 DOWNTO 2) WHEN "00010",--2
		b_rot(2 DOWNTO 0) & b_rot(31 DOWNTO 3) WHEN "00011",--3
		b_rot(3 DOWNTO 0) & b_rot(31 DOWNTO 4) WHEN "00100",--4
		b_rot(4 DOWNTO 0) & b_rot(31 DOWNTO 5) WHEN "00101",--5
		b_rot(5 DOWNTO 0) & b_rot(31 DOWNTO 6) WHEN "00110",--6
		b_rot(6 DOWNTO 0) & b_rot(31 DOWNTO 7) WHEN "00111",--7
		b_rot(7 DOWNTO 0) & b_rot(31 DOWNTO 8) WHEN "01000",--8
		b_rot(8 DOWNTO 0) & b_rot(31 DOWNTO 9) WHEN "01001",--9
		b_rot(9 DOWNTO 0) & b_rot(31 DOWNTO 10) WHEN "01010",--10
		b_rot(10 DOWNTO 0) & b_rot(31 DOWNTO 11) WHEN "01011",--11
		b_rot(11 DOWNTO 0) & b_rot(31 DOWNTO 12) WHEN "01100",--12
		b_rot(12 DOWNTO 0) & b_rot(31 DOWNTO 13) WHEN "01101",--13
		b_rot(13 DOWNTO 0) & b_rot(31 DOWNTO 14) WHEN "01110",--14
		b_rot(14 DOWNTO 0) & b_rot(31 DOWNTO 15) WHEN "01111",--15
		b_rot(15 DOWNTO 0) & b_rot(31 DOWNTO 16) WHEN "10000",--16
		b_rot(16 DOWNTO 0) & b_rot(31 DOWNTO 17) WHEN "10001",--17
		b_rot(17 DOWNTO 0) & b_rot(31 DOWNTO 18) WHEN "10010",--18
		b_rot(18 DOWNTO 0) & b_rot(31 DOWNTO 19) WHEN "10011",--19
		b_rot(19 DOWNTO 0) & b_rot(31 DOWNTO 20) WHEN "10100",--20
		b_rot(20 DOWNTO 0) & b_rot(31 DOWNTO 21) WHEN "10101",--21
		b_rot(21 DOWNTO 0) & b_rot(31 DOWNTO 22) WHEN "10110",--22
		b_rot(22 DOWNTO 0) & b_rot(31 DOWNTO 23) WHEN "10111",--23
		b_rot(23 DOWNTO 0) & b_rot(31 DOWNTO 24) WHEN "11000",--24
		b_rot(24 DOWNTO 0) & b_rot(31 DOWNTO 25) WHEN "11001",--25
		b_rot(25 DOWNTO 0) & b_rot(31 DOWNTO 26) WHEN "11010",--26
		b_rot(26 DOWNTO 0) & b_rot(31 DOWNTO 27) WHEN "11011",--27
		b_rot(27 DOWNTO 0) & b_rot(31 DOWNTO 28) WHEN "11100",--28
		b_rot(28 DOWNTO 0) & b_rot(31 DOWNTO 29) WHEN "11101",--29
		b_rot(29 DOWNTO 0) & b_rot(31 DOWNTO 30) WHEN "11110",--30
		b_rot(30 DOWNTO 0) & b_rot(31) WHEN "11111",--31
		b_rot WHEN OTHERS;
b <= ba_xor XOR a_reg; 

 -- A=((A-S[2i])>>>B) xor B; 
a_rot<=a_reg - skey(CONV_INTEGER(i_cnt & '0')); --S[2xi]
 WITH b(4 DOWNTO 0) SELECT
  ab_xor<=a_rot(0) & a_rot(31 DOWNTO 1) WHEN "00001",--1
      a_rot(1 DOWNTO 0) & a_rot(31 DOWNTO 2) WHEN "00010",--2
		a_rot(2 DOWNTO 0) & a_rot(31 DOWNTO 3) WHEN "00011",--3
		a_rot(3 DOWNTO 0) & a_rot(31 DOWNTO 4) WHEN "00100",--4
		a_rot(4 DOWNTO 0) & a_rot(31 DOWNTO 5) WHEN "00101",--5
		a_rot(5 DOWNTO 0) & a_rot(31 DOWNTO 6) WHEN "00110",--6
		a_rot(6 DOWNTO 0) & a_rot(31 DOWNTO 7) WHEN "00111",--7
		a_rot(7 DOWNTO 0) & a_rot(31 DOWNTO 8) WHEN "01000",--8
		a_rot(8 DOWNTO 0) & a_rot(31 DOWNTO 9) WHEN "01001",--9
		a_rot(9 DOWNTO 0) & a_rot(31 DOWNTO 10) WHEN "01010",--10
		a_rot(10 DOWNTO 0) & a_rot(31 DOWNTO 11) WHEN "01011",--11
		a_rot(11 DOWNTO 0) & a_rot(31 DOWNTO 12) WHEN "01100",--12
		a_rot(12 DOWNTO 0) & a_rot(31 DOWNTO 13) WHEN "01101",--13
		a_rot(13 DOWNTO 0) & a_rot(31 DOWNTO 14) WHEN "01110",--14
		a_rot(14 DOWNTO 0) & a_rot(31 DOWNTO 15) WHEN "01111",--15
		a_rot(15 DOWNTO 0) & a_rot(31 DOWNTO 16) WHEN "10000",--16
		a_rot(16 DOWNTO 0) & a_rot(31 DOWNTO 17) WHEN "10001",--17
		a_rot(17 DOWNTO 0) & a_rot(31 DOWNTO 18) WHEN "10010",--18
		a_rot(18 DOWNTO 0) & a_rot(31 DOWNTO 19) WHEN "10011",--19
		a_rot(19 DOWNTO 0) & a_rot(31 DOWNTO 20) WHEN "10100",--20
		a_rot(20 DOWNTO 0) & a_rot(31 DOWNTO 21) WHEN "10101",--21
		a_rot(21 DOWNTO 0) & a_rot(31 DOWNTO 22) WHEN "10110",--22
		a_rot(22 DOWNTO 0) & a_rot(31 DOWNTO 23) WHEN "10111",--23
		a_rot(23 DOWNTO 0) & a_rot(31 DOWNTO 24) WHEN "11000",--24
		a_rot(24 DOWNTO 0) & a_rot(31 DOWNTO 25) WHEN "11001",--25
		a_rot(25 DOWNTO 0) & a_rot(31 DOWNTO 26) WHEN "11010",--26
		a_rot(26 DOWNTO 0) & a_rot(31 DOWNTO 27) WHEN "11011",--27
		a_rot(27 DOWNTO 0) & a_rot(31 DOWNTO 28) WHEN "11100",--28
		a_rot(28 DOWNTO 0) & a_rot(31 DOWNTO 29) WHEN "11101",--29
		a_rot(29 DOWNTO 0) & a_rot(31 DOWNTO 30) WHEN "11110",--30
		a_rot(30 DOWNTO 0) & a_rot(31) WHEN "11111",--31
		a_rot WHEN OTHERS;
a <= ab_xor XOR b;
 
 


dout<=a_reg & b_reg; 
END rtl;