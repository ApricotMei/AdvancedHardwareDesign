----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:43:40 11/24/2016 
-- Design Name: 
-- Module Name:    rc5_dec - Behavioral 
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

entity rc5_dec is
PORT
(	
	clr		: IN	STD_LOGIC;
	clk		: IN	STD_LOGIC;
	din		: IN	STD_LOGIC_VECTOR(63 DOWNTO 0);
	di_vld	: IN	STD_LOGIC;  -- input is valid
	key_rdy	: IN 	STD_LOGIC;
	skey		: IN 	rom;
	dout		: OUT	STD_LOGIC_VECTOR(63 DOWNTO 0);
	do_rdy	: OUT	STD_LOGIC   -- output is ready
);
end rc5_dec;

architecture Behavioral of rc5_dec is
	SIGNAL i_cnt	: STD_LOGIC_VECTOR(3 DOWNTO 0); -- round counter
	SIGNAL ab_xor	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL a_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL a	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL a_pre	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL a_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register A
	SIGNAL a_aft	: STD_LOGIC_VECTOR(31 DOWNTO 0);
		 
	SIGNAL ba_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL b_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL b	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL b_pre	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL b_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register B
	SIGNAL b_aft	: STD_LOGIC_VECTOR(31 DOWNTO 0);


-- RC5 state machine has five states 
	TYPE  StateType IS (ST_IDLE, --
                       ST_PRE_ROUND, -- in this state RC5 pre-round op is performed 
                       ST_ROUND_OP, -- in this state RC5 round op is performed. The state machine remains in this state for twelve clock cycles.
                       ST_AFT_ROUND, -- in this state RC5 aft-round cop is performed -- new state
							  ST_READY -- 
                       );
-- RC5 state machine has four states: idle, pre_round, round and ready
	SIGNAL  state:   StateType;

begin

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

b_pre <= din(31 DOWNTO 0);

b_aft <= b_reg - skey(1);


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

a_pre <= din(63 DOWNTO 32);

a_aft <= a_reg - skey(0);
	
-- A register
PROCESS(clr, clk)  
BEGIN
	IF(clr='1') THEN
		a_reg<=(OTHERS=>'0');
	ELSIF(clk'EVENT AND clk='1') THEN
		IF(state=ST_PRE_ROUND) THEN   a_reg<=a_pre;
		ELSIF(state=ST_ROUND_OP) THEN   a_reg<=a;   
		ELSIF(state=ST_AFT_ROUND) THEN a_reg<=a_aft;
		END IF;
	END IF;
END PROCESS;

-- B register
PROCESS(clr, clk)  
BEGIN
	IF(clr='1') THEN
		b_reg<=(OTHERS=>'0');
	ELSIF(clk'EVENT AND clk='1') THEN
		IF(state=ST_PRE_ROUND) THEN   b_reg<=b_pre;
		ELSIF(state=ST_ROUND_OP) THEN   b_reg<=b;   
		ELSIF(state=ST_AFT_ROUND) THEN b_reg<=b_aft;
	END IF;
END IF;
END PROCESS;   

-- State machine
PROCESS(clr, clk)
BEGIN
	IF(clr='1') THEN
		state<=ST_IDLE;
	ELSIF(clk'EVENT AND clk='1') THEN
		CASE state IS
			WHEN ST_IDLE=>  IF(di_vld='1' and key_rdy='1') THEN state<=ST_PRE_ROUND;  END IF;
			WHEN ST_PRE_ROUND=>    state<=ST_ROUND_OP;
			WHEN ST_ROUND_OP=>  IF(i_cnt="0001") THEN state<=ST_AFT_ROUND;  END IF;
			WHEN ST_AFT_ROUND=> state<=ST_READY;--new state
			WHEN ST_READY=>   state<=ST_IDLE;
		END CASE;
	END IF;
END PROCESS;

-- round counter
PROCESS(clr, clk)  BEGIN
	IF(clr='1') THEN
		i_cnt<="1100";
	ELSIF(clk'EVENT AND clk='1') THEN
		IF(state=ST_ROUND_OP) THEN
			IF(i_cnt="0001") THEN   i_cnt<="1100";
			ELSE    i_cnt<=i_cnt-'1';    END IF;
		END IF;
	END IF;
END PROCESS;   

dout<=a_reg & b_reg;

	WITH state SELECT
		do_rdy<=	'1' WHEN ST_READY,
					'0' WHEN OTHERS;
					
end Behavioral;

