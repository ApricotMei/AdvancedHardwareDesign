----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:59:25 11/04/2016 
-- Design Name: 
-- Module Name:    Lab6_1 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lab6_1 is
PORT
(
	x: in STD_LOGIC_VECTOR (15 downto 0);
	a_to_g : out STD_LOGIC_VECTOR (6 downto 0);
	an : out STD_LOGIC_VECTOR (7 downto 0);
	led		: out STD_LOGIC_VECTOR (7 downto 0);
	
	clr		: IN	STD_LOGIC;
	clk		: IN	STD_LOGIC;
--	din		: IN	STD_LOGIC_VECTOR(63 DOWNTO 0);
	di_vld	: IN	STD_LOGIC;  -- input is valid
	f_out		: IN	STD_LOGIC;
	s_out		: IN	STD_LOGIC;
--	dout		: OUT	STD_LOGIC_VECTOR(63 DOWNTO 0);
	do_idle	: OUT	STD_LOGIC;
	do_rdy	: OUT	STD_LOGIC   -- output is ready
);
end Lab6_1;

architecture Behavioral of Lab6_1 is
	signal s: STD_LOGIC_VECTOR (2 downto 0);
	signal digit: STD_LOGIC_VECTOR (3 downto 0);
	signal aen: STD_LOGIC_VECTOR (7 downto 0);
	signal clkdiv: STD_LOGIC_VECTOR (20 downto 0);
	
	signal din: STD_LOGIC_VECTOR(63 DOWNTO 0);
	signal dout: STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	signal o: STD_LOGIC_VECTOR (31 downto 0);

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

-- define a type for round keys
	TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
--instantiate round key rom with 26 round keys
	CONSTANT skey : rom:=rom'(X"9BBBD8C8", X"1A37F7FB", X"46F8E8C5",X"460C6085", 
			   	 X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",X"3125065D", 
					 X"11A83A5D", X"D427686B", X"713AD82D", X"4B792F99",X"2799A4DD", 
					 X"A7901C49", X"DEDE871A", X"36C03196", X"A7EFC249",X"61A78BB8", 
					 X"3B0A1D2B", X"4DBFCA76", X"AE162167", X"30D76B0A",X"43192304", 
					 X"F6CC1431", X"65046380");

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
--output through ssd

--input through switches
process (x,clk,clr)
	begin 
		if (clr = '1') then
			led<="00000000";
		elsif (clk'EVENT and clk='1')then 
			if (x(8) = '1') then
				din(7 downto 0) <= x (7 downto 0);
				led(0)<= '1';
			elsif (x(9) = '1') then
				din(15 downto 8) <= x (7 downto 0);
				led(1)<= '1';
			elsif (x(10) = '1') then
				din(23 downto 16) <= x (7 downto 0);
				led(2)<= '1';
			elsif (x(11) = '1') then
				din(31 downto 24) <= x (7 downto 0);
				led(3)<= '1';
			elsif (x(12) = '1') then
				din(39 downto 32) <= x (7 downto 0);
				led(4)<= '1';
			elsif (x(13) = '1') then
				din(47 downto 40) <= x (7 downto 0);
				led(5)<= '1';
			elsif (x(14) = '1') then
				din(55 downto 48) <= x (7 downto 0);
				led(6)<= '1';
			elsif (x(15) = '1') then
				din(63 downto 56) <= x (7 downto 0);
				led(7)<= '1';
			end if;
		end if;
end process;
--input through switches

--output control
process (f_out,s_out,dout,clk)
	begin 
		if (clk'EVENT and clk='1')then 
			if (f_out = '1') then
				o <= dout(63 downto 32);
			elsif (s_out = '1') then
				o <= dout(31 downto 0);
			end if;
		end if;
end process;
--output control

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
			WHEN ST_IDLE=>  IF(di_vld='1') THEN state<=ST_PRE_ROUND;  END IF;
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
					
	WITH state SELECT
		do_idle<='1' WHEN ST_IDLE,
					'0' WHEN OTHERS;
end Behavioral;

