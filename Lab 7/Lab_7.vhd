----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:40:46 11/24/2016 
-- Design Name: 
-- Module Name:    Lab_7 - Behavioral 
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

PACKAGE rc5_pkg IS
--   TYPE   S_ARRAY IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
   TYPE   L_ARRAY IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	TYPE 	 rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
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

entity Lab_7 is
   PORT
   (
	   x: in STD_LOGIC_VECTOR (11 downto 0);
	   a_to_g : out STD_LOGIC_VECTOR (6 downto 0);
   	an : out STD_LOGIC_VECTOR (7 downto 0);
	   led : out STD_LOGIC_VECTOR (15 downto 0);
		input : in STD_LOGIC;
		output : in STD_LOGIC;
		key_gen: in STD_LOGIC;
		if_key: out STD_LOGIC;
		if_enc: out STD_LOGIC;
		if_dec: out STD_LOGIC;
		
      clr, clk	: IN     STD_LOGIC;
      enc		: IN     STD_LOGIC;  -- Encryption or decryption?
      key_vld	: IN     STD_LOGIC;  -- Indicate the input is user key
      di_vld	: IN     STD_LOGIC;  -- Indicate the input is user data
		--ukey	: IN     STD_LOGIC_VECTOR(127 downto 0);		
      --din		: IN     STD_LOGIC_VECTOR(63 downto 0);
      --dout	: OUT    STD_LOGIC_VECTOR(63 downto 0);
		key_ready: OUT		STD_LOGIC;
      data_rdy	: OUT    STD_LOGIC   -- Indicate the output data is ready
   );
end Lab_7;

architecture Behavioral of Lab_7 is

--TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

COMPONENT  key_exp  -- Key expansion module
   PORT(
      clr, clk	: IN     STD_LOGIC;
      key_vld	: IN     STD_LOGIC;
      ukey		: IN     STD_LOGIC_VECTOR(127 DOWNTO 0);
      skey		: OUT  ROM;
		key_rdy	: OUT  STD_LOGIC);
END COMPONENT;

COMPONENT  rc5_enc  -- Encryption module
   PORT(
      clr, clk	: IN     STD_LOGIC;
      key_rdy	: IN     STD_LOGIC;
      di_vld	: IN     STD_LOGIC;
      din		: IN     STD_LOGIC_VECTOR(63 DOWNTO 0);
      skey		: IN     ROM;
      dout		: OUT  STD_LOGIC_VECTOR(63 DOWNTO 0);
      do_rdy	: OUT  STD_LOGIC);
END COMPONENT;

COMPONENT  rc5_dec  -- Decryption module
   PORT(
      clr, clk	: IN     STD_LOGIC;
      key_rdy	: IN     STD_LOGIC;
      di_vld	: IN     STD_LOGIC;
      din		: IN     STD_LOGIC_VECTOR(63 DOWNTO 0);
      skey		: IN     ROM;
      dout		: OUT  STD_LOGIC_VECTOR(63 DOWNTO 0);
      do_rdy	: OUT  STD_LOGIC);
END COMPONENT;

signal s: STD_LOGIC_VECTOR (2 downto 0);
signal digit: STD_LOGIC_VECTOR (3 downto 0);
signal aen: STD_LOGIC_VECTOR (7 downto 0);
signal clkdiv: STD_LOGIC_VECTOR (20 downto 0);
signal o: STD_LOGIC_VECTOR (31 downto 0);

SIGNAL ukey  : STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL din   : STD_LOGIC_VECTOR(63 DOWNTO 0); 
SIGNAL dout  : STD_LOGIC_VECTOR(63 DOWNTO 0);
	  
signal skey: rom;
signal key_rdy: std_logic;
signal dout_enc: std_logic_vector(63 downto 0);
signal dout_dec: std_logic_vector(63 downto 0);
signal dec_rdy: std_logic;
signal enc_rdy: std_logic;
	
begin	
   U1: key_exp PORT MAP(clr=>clr, clk=>clk, key_vld=>key_vld, ukey=>ukey, skey=>skey, key_rdy=>key_rdy);
   U2: rc5_enc PORT MAP(clr=>clr, clk=>clk, di_vld=>di_vld, key_rdy=> key_rdy, din=>din, skey=>skey, dout=>dout_enc, do_rdy=>enc_rdy);
   U3: rc5_dec PORT MAP(clr=>clr, clk=>clk, di_vld=>di_vld, key_rdy=> key_rdy, din=>din, skey=>skey, dout=>dout_dec, do_rdy=>dec_rdy);

WITH enc SELECT
   dout<=dout_enc WHEN '1',
         dout_dec WHEN OTHERS;
				  
WITH enc SELECT
   data_rdy<=enc_rdy WHEN '1',
             dec_rdy WHEN OTHERS;
				 
key_ready<=key_rdy;
				
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

-- input control/ukey and din
process (x,input,clk,clr,key_gen,enc,di_vld,key_vld)
	begin 
		if (clr = '1' or di_vld = '1' or key_vld = '1') then
			led<="0000000000000000";
		elsif (clk'EVENT and clk='1')then 
			if (key_gen = '1' and enc = '0') then
				if_key <= '1';
				if_enc <= '0';
				if_dec <= '0';
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
			elsif (key_gen = '0' and enc = '1') then
				if_key <= '0';
				if_enc <= '1';
				if_dec <= '0';
				if (input = '1') then
					if (x(11 downto 8) = "0000") then 
						din(7 downto 0) <= x(7 downto 0);led(0)<= '1';
					elsif (x(11 downto 8) = "0001") then
						din(15 downto 8) <= x(7 downto 0);led(1)<= '1';
					elsif (x(11 downto 8) = "0010") then
						din(23 downto 16) <= x(7 downto 0);led(2)<= '1';
					elsif (x(11 downto 8) = "0011") then
						din(31 downto 24) <= x(7 downto 0);led(3)<= '1';
					elsif (x(11 downto 8) = "0100") then
						din(39 downto 32) <= x(7 downto 0);led(4)<= '1';
					elsif (x(11 downto 8) = "0101") then
						din(47 downto 40) <= x(7 downto 0);led(5)<= '1';
					elsif (x(11 downto 8) = "0110") then
						din(55 downto 48) <= x(7 downto 0);led(6)<= '1';
					elsif (x(11 downto 8) = "0111") then
						din(63 downto 56) <= x(7 downto 0);led(7)<= '1';
					end if;
				end if;
			elsif (key_gen = '0' and enc = '0') then
				if_key <= '0';
				if_enc <= '0';
				if_dec <= '1';
				if (input = '1') then
					if (x(11 downto 8) = "0000") then 
						din(7 downto 0) <= x(7 downto 0);led(0)<= '1';
					elsif (x(11 downto 8) = "0001") then
						din(15 downto 8) <= x(7 downto 0);led(1)<= '1';
					elsif (x(11 downto 8) = "0010") then
						din(23 downto 16) <= x(7 downto 0);led(2)<= '1';
					elsif (x(11 downto 8) = "0011") then
						din(31 downto 24) <= x(7 downto 0);led(3)<= '1';
					elsif (x(11 downto 8) = "0100") then
						din(39 downto 32) <= x(7 downto 0);led(4)<= '1';
					elsif (x(11 downto 8) = "0101") then
						din(47 downto 40) <= x(7 downto 0);led(5)<= '1';
					elsif (x(11 downto 8) = "0110") then
						din(55 downto 48) <= x(7 downto 0);led(6)<= '1';
					elsif (x(11 downto 8) = "0111") then
						din(63 downto 56) <= x(7 downto 0);led(7)<= '1';
					end if;
				end if;
			end if;
		end if;
end process;
-- end of input control/ukey and din

--output control
process (output,x,skey,clk)
	begin 
		if (clk'EVENT and clk='1')then
			if (key_gen = '1' and enc = '0') then
				if (output = '1') then
					if (x(4 downto 0) = "00000") then
						o<=skey(0);
					elsif (x(4 downto 0) = "00001") then
						o<=skey(1);
					elsif (x(4 downto 0) = "00010") then
						o<=skey(2);
					elsif (x(4 downto 0) = "00011") then
						o<=skey(3);
					elsif (x(4 downto 0) = "00100") then
						o<=skey(4);
					elsif (x(4 downto 0) = "00101") then
						o<=skey(5);
					elsif (x(4 downto 0) = "00110") then
						o<=skey(6);
					elsif (x(4 downto 0) = "00111") then
						o<=skey(7);
					elsif (x(4 downto 0) = "01000") then
						o<=skey(8);
					elsif (x(4 downto 0) = "01001") then
						o<=skey(9);
					elsif (x(4 downto 0) = "01010") then
						o<=skey(10);
					elsif (x(4 downto 0) = "01011") then
						o<=skey(11);
					elsif (x(4 downto 0) = "01100") then
						o<=skey(12);
					elsif (x(4 downto 0) = "01101") then
						o<=skey(13);
					elsif (x(4 downto 0) = "01110") then
						o<=skey(14);
					elsif (x(4 downto 0) = "01111") then
						o<=skey(15);
					elsif (x(4 downto 0) = "10000") then
						o<=skey(16);
					elsif (x(4 downto 0) = "10001") then
						o<=skey(17);
					elsif (x(4 downto 0) = "10010") then
						o<=skey(18);
					elsif (x(4 downto 0) = "10011") then
						o<=skey(19);
					elsif (x(4 downto 0) = "10100") then
						o<=skey(20);
					elsif (x(4 downto 0) = "10101") then
						o<=skey(21);
					elsif (x(4 downto 0) = "10110") then
						o<=skey(22);
					elsif (x(4 downto 0) = "10111") then
						o<=skey(23);
					elsif (x(4 downto 0) = "11000") then
						o<=skey(24);
					elsif (x(4 downto 0) = "11001") then
						o<=skey(25);				
					end if;
				end if;
			elsif (key_gen = '0' and enc = '1') then
				if (output = '1') then
					if (x(4 downto 0) = "00000") then
						o<=dout(31 downto 0);
					elsif (x(4 downto 0) = "00001") then
						o<=dout(63 downto 32);
					end if;
				end if;
			elsif (key_gen = '0' and enc = '0') then
				if (output = '1') then
					if (x(4 downto 0) = "00000") then
						o<=dout(31 downto 0);
					elsif (x(4 downto 0) = "00001") then
						o<=dout(63 downto 32);
					end if;
				end if;			
			end if;
		end if;
end process;
--end of output control

end Behavioral;

