----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:42:49 11/24/2016 
-- Design Name: 
-- Module Name:    key_exp - Behavioral 
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.RC5_PKG.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_exp is
PORT
	(
		clr,clk :STD_LOGIC; --by default,it is input
		key_vld : STD_LOGIC;
		ukey : STD_LOGIC_VECTOR(127 DOWNTO 0); 
		skey : OUT ROM; 
		key_rdy :OUT STD_LOGIC
	);
end key_exp;

architecture Behavioral of key_exp is

SIGNAL  a_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  a_tmp1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  a_tmp2	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  ab_tmp	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_tmp1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_tmp2	: STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL  l_arr	: L_ARRAY;
SIGNAL  s_arr_tmp: ROM;

SIGNAL  i_cnt	: INTEGER RANGE 0 TO 25;  -- you can use std_logic_vector
SIGNAL  j_cnt	: INTEGER RANGE 0 TO 3;  -- you can use std_logic_vector
SIGNAL  k_cnt	: INTEGER RANGE 0 TO 77; -- any better way?

TYPE     StateType IS (ST_IDLE, ST_KEY_INIT, ST_KEY_EXP, ST_READY);
SIGNAL	state : StateType;



begin

-- A = S[i]=(S[i]+A+B)<<<3;
a_tmp1<=s_arr_tmp(i_cnt)+a_reg+b_reg; -- not a good style! 
-- <<<3
a_tmp2<=a_tmp1(28 DOWNTO 0) & a_tmp1(31 DOWNTO 29); 
-- end of A = S[i]=(S[i]+A+B)<<<3;

-- B = L[j] = (L[j] + A + B) <<< (A + B);
ab_tmp<=a_tmp2+b_reg;
b_tmp1<=l_arr(j_cnt)+ab_tmp;
WITH ab_tmp(4 DOWNTO 0) SELECT
	b_tmp2<=
			 b_tmp1(30 DOWNTO 0) & b_tmp1(31) WHEN "00001",
			 b_tmp1(29 DOWNTO 0) & b_tmp1(31 DOWNTO 30) WHEN "00010",
			 b_tmp1(28 DOWNTO 0) & b_tmp1(31 DOWNTO 29) WHEN "00011",
			 b_tmp1(27 DOWNTO 0) & b_tmp1(31 DOWNTO 28) WHEN "00100",
			 b_tmp1(26 DOWNTO 0) & b_tmp1(31 DOWNTO 27) WHEN "00101",
			 b_tmp1(25 DOWNTO 0) & b_tmp1(31 DOWNTO 26) WHEN "00110",
			 b_tmp1(24 DOWNTO 0) & b_tmp1(31 DOWNTO 25) WHEN "00111",
			 b_tmp1(23 DOWNTO 0) & b_tmp1(31 DOWNTO 24) WHEN "01000",
			 b_tmp1(22 DOWNTO 0) & b_tmp1(31 DOWNTO 23) WHEN "01001",
			 b_tmp1(21 DOWNTO 0) & b_tmp1(31 DOWNTO 22) WHEN "01010",
			 b_tmp1(20 DOWNTO 0) & b_tmp1(31 DOWNTO 21) WHEN "01011",
			 b_tmp1(19 DOWNTO 0) & b_tmp1(31 DOWNTO 20) WHEN "01100",
			 b_tmp1(18 DOWNTO 0) & b_tmp1(31 DOWNTO 19) WHEN "01101",
			 b_tmp1(17 DOWNTO 0) & b_tmp1(31 DOWNTO 18) WHEN "01110",
			 b_tmp1(16 DOWNTO 0) & b_tmp1(31 DOWNTO 17) WHEN "01111",
			 b_tmp1(15 DOWNTO 0) & b_tmp1(31 DOWNTO 16) WHEN "10000",
			 b_tmp1(14 DOWNTO 0) & b_tmp1(31 DOWNTO 15) WHEN "10001",
			 b_tmp1(13 DOWNTO 0) & b_tmp1(31 DOWNTO 14) WHEN "10010",
			 b_tmp1(12 DOWNTO 0) & b_tmp1(31 DOWNTO 13) WHEN "10011",
			 b_tmp1(11 DOWNTO 0) & b_tmp1(31 DOWNTO 12) WHEN "10100",
			 b_tmp1(10 DOWNTO 0) & b_tmp1(31 DOWNTO 11) WHEN "10101",
			 b_tmp1(9 DOWNTO 0) & b_tmp1(31 DOWNTO 10) WHEN "10110", 
			 b_tmp1(8 DOWNTO 0) & b_tmp1(31 DOWNTO 9) WHEN "10111",
			 b_tmp1(7 DOWNTO 0) & b_tmp1(31 DOWNTO 8) WHEN "11000",
			 b_tmp1(6 DOWNTO 0) & b_tmp1(31 DOWNTO 7) WHEN "11001",
			 b_tmp1(5 DOWNTO 0) & b_tmp1(31 DOWNTO 6) WHEN "11010",
			 b_tmp1(4 DOWNTO 0) & b_tmp1(31 DOWNTO 5) WHEN "11011",
			 b_tmp1(3 DOWNTO 0) & b_tmp1(31 DOWNTO 4) WHEN "11100",
			 b_tmp1(2 DOWNTO 0) & b_tmp1(31 DOWNTO 3) WHEN "11101",
			 b_tmp1(1 DOWNTO 0) & b_tmp1(31 DOWNTO 2) WHEN "11110",
			 b_tmp1(0) & b_tmp1(31 DOWNTO 1) WHEN "11111",
			 b_tmp1 WHEN OTHERS;
-- end of B = L[j] = (L[j] + A + B) <<< (A + B);


-- state
  PROCESS(clr, clk)	
     BEGIN
       IF(clr='1') THEN
           state<=ST_IDLE;
       ELSIF(clk'EVENT AND clk='1') THEN
           CASE state IS
              WHEN ST_IDLE=>
                  IF(key_vld='1') THEN  state<=ST_KEY_INIT;   END IF;
              WHEN ST_KEY_INIT=>
                  state<=ST_KEY_EXP;
              WHEN ST_KEY_EXP=>
                  IF(k_cnt=77) THEN   state<=ST_READY;  END IF;
				  WHEN ST_READY =>
						state<=ST_READY;
          END CASE;
        END IF;
  END PROCESS;
-- end of state

-- A register
PROCESS(clr, clk)  BEGIN
    IF(clr='1') THEN
       a_reg<=(OTHERS=>'0');
    ELSIF(clk'EVENT AND clk='1') THEN
       IF(state=ST_KEY_EXP) THEN   a_reg<=a_tmp2;
       END IF;
    END IF;
END PROCESS;
-- B register
PROCESS(clr, clk)  BEGIN
    IF(clr='1') THEN
       b_reg<=(OTHERS=>'0');
    ELSIF(clk'EVENT AND clk='1') THEN
       IF(state=ST_KEY_EXP) THEN   b_reg<=b_tmp2;
       END IF;
    END IF;
END PROCESS;   
-- end of registers

-- arrays
PROCESS(clr, clk)
BEGIN
   IF(clr='1') THEN  i_cnt<=0;
   ELSIF(clk'EVENT AND clk='1') THEN
      IF(state=ST_KEY_EXP) THEN
        IF(i_cnt=25) THEN   i_cnt<=0;
        ELSE   i_cnt<=i_cnt+1;
        END IF;
      END IF;
   END IF;
END PROCESS;

PROCESS(clr, clk)
BEGIN
   IF(clr='1') THEN  j_cnt<=0;
   ELSIF(clk'EVENT AND clk='1') THEN
      IF(state=ST_KEY_EXP) THEN
        IF(j_cnt=3) THEN   j_cnt<=0;
        ELSE   j_cnt<=j_cnt+1;
        END IF;
      END IF;
   END IF;
END PROCESS;

PROCESS(clr, clk)
BEGIN
   IF(clr='1') THEN  k_cnt<=0;
   ELSIF(clk'EVENT AND clk='1') THEN
      IF(state=ST_KEY_EXP) THEN
        IF(k_cnt=77) THEN   k_cnt<=0;
        ELSE   k_cnt<=k_cnt+1;
        END IF;
      END IF;
   END IF;
END PROCESS;
-- end of arrays


--S[0] = 0xB7E15163 (Pw)
--for i=1 to 25 do  S[i] = S[i-1]+ 0x9E3779B9 (Qw)
-- Initialize S_ARRAY
PROCESS(clr, clk)
BEGIN
  IF(clr='1') THEN	 -- After system reset, S array is initialized with P and Q
     s_arr_tmp(0)<=  "10110111111000010101000101100011"; --Pw
     s_arr_tmp(1)<=  "01010110000110001100101100011100"; --Pw+ Qw
     s_arr_tmp(2)<=  "11110100010100000100010011010101"; --Pw+ 2Qw
     s_arr_tmp(3)<=  "10010010100001111011111010001110"; --Pw+ 3Qw  
     s_arr_tmp(4)<=  "00110000101111110011100001000111"; --Pw+ 4Qw
     s_arr_tmp(5)<=  "11001110111101101011001000000000"; --Pw+ 5Qw
     s_arr_tmp(6)<=  "01101101001011100010101110111001"; --Pw+ 6Qw
     s_arr_tmp(7)<=  "00001011011001011010010101110010"; --Pw+ 7Qw
     s_arr_tmp(8)<=  "10101001100111010001111100101011"; --Pw+ 8Qw
     s_arr_tmp(9)<=  "01000111110101001001100011100100"; --Pw+ 9Qw
     s_arr_tmp(10)<=  "11100110000011000001001010011101"; --Pw+ 10Qw
     s_arr_tmp(11)<=  "10000100010000111000110001010110"; --Pw+ 11Qw
     s_arr_tmp(12)<=  "00100010011110110000011000001111"; --Pw+ 12Qw
     s_arr_tmp(13)<=  "11000000101100100111111111001000"; --Pw+ 13Qw
     s_arr_tmp(14)<=  "01011110111010011111100110000001"; --Pw+ 14Qw
     s_arr_tmp(15)<=  "11111101001000010111001100111010"; --Pw+ 15Qw
     s_arr_tmp(16)<=  "10011011010110001110110011110011"; --Pw+ 16Qw
     s_arr_tmp(17)<=  "00111001100100000110011010101100"; --Pw+ 17Qw
     s_arr_tmp(18)<=  "11010111110001111110000001100101"; --Pw+ 18Qw
     s_arr_tmp(19)<=  "01110101111111110101101000011110"; --Pw+ 19Qw
     s_arr_tmp(20)<=  "00010100001101101101001111010111"; --Pw+ 20Qw
     s_arr_tmp(21)<=  "10110010011011100100110110010000"; --Pw+ 21Qw
     s_arr_tmp(22)<=  "01010000101001011100011101001001"; --Pw+ 22Qw
     s_arr_tmp(23)<=  "11101110110111010100000100000010"; --Pw+ 23Qw
     s_arr_tmp(24)<=  "10001101000101001011101010111011"; --Pw+ 24Qw
     s_arr_tmp(25)<=  "00101011010011000011010001110100"; --Pw+ 25Qw
  ELSIF(clk'EVENT AND clk='1') THEN
    IF(state=ST_KEY_EXP) THEN   s_arr_tmp(i_cnt)<=a_tmp2;
    END IF;
  END IF;
END PROCESS;
skey<=s_arr_tmp;
-- end of Initialize S_ARRAY

-- L_ARRAY
PROCESS(clr, clk)
BEGIN
	IF(clr='1') THEN
		FOR i IN 0 TO 3 LOOP
			l_arr(i)<=(OTHERS=>'0');
		END LOOP;
	ELSIF(clk'EVENT AND clk='1') THEN
		IF(state=ST_KEY_INIT) THEN
			l_arr(0)<=ukey(31 DOWNTO 0);
			l_arr(1)<=ukey(63 DOWNTO 32);
			l_arr(2)<=ukey(95 DOWNTO 64);
			l_arr(3)<=ukey(127 DOWNTO 96);
		ELSIF(state=ST_KEY_EXP) THEN
			l_arr(j_cnt)<=b_tmp2;
		END IF;
	END IF;
END PROCESS;
-- end of L_ARRAY

WITH state SELECT
	key_rdy<='1' WHEN ST_READY,
				'0' WHEN OTHERS;



end Behavioral;

