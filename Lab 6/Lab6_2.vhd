----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:49 11/19/2016 
-- Design Name: 
-- Module Name:    Lab6_2 - Behavioral 
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

PACKAGE rc5_pkg IS
   TYPE   S_ARRAY IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
   TYPE   L_ARRAY IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
END rc5_pkg;

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

entity Lab6_2 is
PORT
	(
	   x: in STD_LOGIC_VECTOR (11 downto 0);
	   a_to_g : out STD_LOGIC_VECTOR (6 downto 0);
   	an : out STD_LOGIC_VECTOR (7 downto 0);
	   led : out STD_LOGIC_VECTOR (15 downto 0);
		input : in STD_LOGIC;
		output : in STD_LOGIC;
	
		clr,clk :IN STD_LOGIC; --by default,it is input
		key_in : IN STD_LOGIC;
--		ukey : STD_LOGIC_VECTOR(127 DOWNTO 0); 
--		skey : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); 
		key_idle :OUT STD_LOGIC;
		key_rdy :OUT STD_LOGIC
	);
end Lab6_2;

architecture Behavioral of Lab6_2 is
signal s: STD_LOGIC_VECTOR (2 downto 0);
signal digit: STD_LOGIC_VECTOR (3 downto 0);
signal aen: STD_LOGIC_VECTOR (7 downto 0);
signal clkdiv: STD_LOGIC_VECTOR (20 downto 0);

signal o: STD_LOGIC_VECTOR (31 downto 0);

SIGNAL  a_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  a_tmp1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  a_tmp2	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  ab_tmp	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_tmp1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_tmp2	: STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL  l_arr	: L_ARRAY;
SIGNAL  s_arr_tmp: S_ARRAY;

SIGNAL  i_cnt	: INTEGER RANGE 0 TO 25;  -- you can use std_logic_vector
SIGNAL  j_cnt	: INTEGER RANGE 0 TO 3;  -- you can use std_logic_vector
SIGNAL  k_cnt	: INTEGER RANGE 0 TO 77; -- any better way?

SIGNAL  ukey   : STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL  skey   : STD_LOGIC_VECTOR(31 DOWNTO 0); 

TYPE     StateType IS (ST_IDLE, ST_KEY_INIT, ST_KEY_EXP, ST_READY);
SIGNAL	state : StateType;



begin

-- output through ssd
	s <= clkdiv(20 downto 18);
	aen <= "11111111";
process(s,o)
	begin
		case s is
		when "000" => digit <= o(3 downto 0);
		when "001" => digit <= o(7 downto 4);
		when "010" => digit <= o(11 downto 8);
		when "011" => digit <= o(15 downto 12);
		when "100" => digit <= o(19 downto 16);
		when "101" => digit <= o(23 downto 20);
		when "110" => digit <= o(27 downto 24);
		when others => digit <= o(31 downto 28);
		end case;
	end process;
	process(digit)
	begin
		case digit is
			when "0000" => a_to_g <= "0000001";  --0 
			when "0001" => a_to_g <= "1001111";  --1
			when "0010" => a_to_g <= "0010010";  --2
			when "0011" => a_to_g <= "0000110";  --3
			when "0100" => a_to_g <= "1001100";  --4
			when "0101" => a_to_g <= "0100100";  --5
			when "0110" => a_to_g <= "0100000";  --6
			when "0111" => a_to_g <= "0001101";  --7
			when "1000" => a_to_g <= "0000000";  --8
			when "1001" => a_to_g <= "0000100";  --9
			when "1010" => a_to_g <= "0001000";  --A
			when "1011" => a_to_g <= "1100000";  --B
			when "1100" => a_to_g <= "0110001";  --C
			when "1101" => a_to_g <= "1000010";  --D
			when "1110" => a_to_g <= "0110000";  --E
			when others => a_to_g <= "0111000";  --F
		end case;
	end process;
	process (s,aen)
	begin
		an <= "11111111";
		if aen(conv_integer(s))='1' then
		   an(conv_integer(s))<='0';
		end if;
	end process;
	process (clk,clr)
	begin
		if clr = '1' then
			clkdiv <= (others => '0');
		elsif clk'event and clk = '1' then
			clkdiv <= clkdiv + 1;
		end if;
end process;
-- end of output through ssd

-- input control
process (x,input,clk,clr)
	begin 
		if (clr = '1') then
			led<="0000000000000000";
		elsif (clk'EVENT and clk='1')then 
			if (input = '1') then 
				if (x(11 downto 8) = "0000") then 
					ukey(7 downto 0) <= x(7 downto 0);led(0)<= '1';
				elsif (x(11 downto 8) = "0001") then
					ukey(15 downto 8) <= x(7 downto 0);led(1)<= '1';
				elsif (x(11 downto 8) = "0010") then
					ukey(23 downto 16) <= x(7 downto 0);led(2)<= '1';
				elsif (x(11 downto 8) = "0011") then
					ukey(31 downto 24) <= x(7 downto 0);led(3)<= '1';
				elsif (x(11 downto 8) = "0100") then
					ukey(39 downto 32) <= x(7 downto 0);led(4)<= '1';
				elsif (x(11 downto 8) = "0101") then
					ukey(47 downto 40) <= x(7 downto 0);led(5)<= '1';
				elsif (x(11 downto 8) = "0110") then
					ukey(55 downto 48) <= x(7 downto 0);led(6)<= '1';
				elsif (x(11 downto 8) = "0111") then
					ukey(63 downto 56) <= x(7 downto 0);led(7)<= '1';
				elsif (x(11 downto 8) = "1000") then
					ukey(71 downto 64) <= x(7 downto 0);led(8)<= '1';
				elsif (x(11 downto 8) = "1001") then
					ukey(79 downto 72) <= x(7 downto 0);led(9)<= '1';
				elsif (x(11 downto 8) = "1010") then
					ukey(87 downto 80) <= x(7 downto 0);led(10)<= '1';
				elsif (x(11 downto 8) = "1011") then
					ukey(95 downto 88) <= x(7 downto 0);led(11)<= '1';
				elsif (x(11 downto 8) = "1100") then
					ukey(103 downto 96) <= x(7 downto 0);led(12)<= '1';
				elsif (x(11 downto 8) = "1101") then
					ukey(111 downto 104) <= x(7 downto 0);led(13)<= '1';
				elsif (x(11 downto 8) = "1110") then
					ukey(119 downto 112) <= x(7 downto 0);led(14)<= '1';
				elsif (x(11 downto 8) = "1111") then
					ukey(127 downto 120) <= x(7 downto 0);led(15)<= '1';
				end if;
			end if;
		end if;
end process;
-- end of input control

--output control
process (output,x,s_arr_tmp,clk)
	begin 
		if (clk'EVENT and clk='1')then 
			if (output = '1') then
				if (x(4 downto 0) = "00000") then
					o<=s_arr_tmp(0);
				elsif (x(4 downto 0) = "00001") then
					o<=s_arr_tmp(1);
				elsif (x(4 downto 0) = "00010") then
					o<=s_arr_tmp(2);
				elsif (x(4 downto 0) = "00011") then
					o<=s_arr_tmp(3);
				elsif (x(4 downto 0) = "00100") then
					o<=s_arr_tmp(4);
				elsif (x(4 downto 0) = "00101") then
					o<=s_arr_tmp(5);
				elsif (x(4 downto 0) = "00110") then
					o<=s_arr_tmp(6);
				elsif (x(4 downto 0) = "00111") then
					o<=s_arr_tmp(7);
				elsif (x(4 downto 0) = "01000") then
					o<=s_arr_tmp(8);
				elsif (x(4 downto 0) = "01001") then
					o<=s_arr_tmp(9);
				elsif (x(4 downto 0) = "01010") then
					o<=s_arr_tmp(10);
				elsif (x(4 downto 0) = "01011") then
					o<=s_arr_tmp(11);
				elsif (x(4 downto 0) = "01100") then
					o<=s_arr_tmp(12);
				elsif (x(4 downto 0) = "01101") then
					o<=s_arr_tmp(13);
				elsif (x(4 downto 0) = "01110") then
					o<=s_arr_tmp(14);
				elsif (x(4 downto 0) = "01111") then
					o<=s_arr_tmp(15);
				elsif (x(4 downto 0) = "10000") then
					o<=s_arr_tmp(16);
				elsif (x(4 downto 0) = "10001") then
					o<=s_arr_tmp(17);
				elsif (x(4 downto 0) = "10010") then
					o<=s_arr_tmp(18);
				elsif (x(4 downto 0) = "10011") then
					o<=s_arr_tmp(19);
				elsif (x(4 downto 0) = "10100") then
					o<=s_arr_tmp(20);
				elsif (x(4 downto 0) = "10101") then
					o<=s_arr_tmp(21);
				elsif (x(4 downto 0) = "10110") then
					o<=s_arr_tmp(22);
				elsif (x(4 downto 0) = "10111") then
					o<=s_arr_tmp(23);
				elsif (x(4 downto 0) = "11000") then
					o<=s_arr_tmp(24);
				elsif (x(4 downto 0) = "11001") then
					o<=s_arr_tmp(25);				
				end if;
			end if;
		end if;
end process;
--end of output control

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
              WHEN ST_IDLE =>
                  IF(key_in='1') THEN  state<=ST_KEY_INIT;   END IF;
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
skey<=s_arr_tmp(25);
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
					
WITH state SELECT
	key_idle<='1' WHEN ST_IDLE,
				 '0' WHEN OTHERS;

end Behavioral;

