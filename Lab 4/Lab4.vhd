----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:32:05 10/21/2016 
-- Design Name: 
-- Module Name:    Lab4 - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lab4 is
	port(
		x: in STD_LOGIC_VECTOR (15 downto 0);
		clk: in STD_LOGIC;
		clr: in STD_LOGIC;
		lift_rot: in STD_LOGIC;
		right_rot: in STD_LOGIC;
		input_0: in STD_LOGIC;
		input_1: in STD_LOGIC;
		input_b: in STD_LOGIC;
		a_to_g : out STD_LOGIC_VECTOR (6 downto 0);
		an : out STD_LOGIC_VECTOR (7 downto 0));
end Lab4;

architecture Behavioral of Lab4 is
	signal s: STD_LOGIC_VECTOR (2 downto 0);
	signal digit: STD_LOGIC_VECTOR (3 downto 0);
	signal aen: STD_LOGIC_VECTOR (7 downto 0);
	signal clkdiv: STD_LOGIC_VECTOR (20 downto 0);
	signal a: STD_LOGIC_VECTOR (31 downto 0);
	signal o: STD_LOGIC_VECTOR (31 downto 0);
	signal b: STD_LOGIC_VECTOR (15 downto 0);
	--signal an: STD_LOGIC_VEcTOR (3 downto 0);
begin
	s <= clkdiv(20 downto 18);
--	an <= "11111111";
	aen <= "11111111";
--	a <= "00000000000000000000000000000000";
--	o <= "00000000000000000000000000000000";
--	b <= "0000000000000000";
--	dp <= '1';
	process (input_0,x,clk)
	begin 
		if (clk'EVENT and clk='1')then 
			if (input_0 = '1') then
				a(31 downto 16) <= x;
			end if;
		end if;
	end process;
	--
	process (input_1,x,clk)
	begin
		if (clk'EVENT and clk='1')then 
			if (input_1 = '1') then
				a(15 downto 0) <= x;
			end if;
		end if;
	end process;
	--
	process (input_b,x,clk)
	begin
		if (clk'EVENT and clk='1')then 
			if (input_b = '1') then
				b <= x;
			end if;
		end if;
	end process;
	--
	process (lift_rot,right_rot,b,a,clk)
	begin
	if (clk'EVENT and clk='1')then
		if (lift_rot = '1') then
			case b(4 downto 0) is
			when "00001" => o <= a(30 DOWNTO 0) & a(31); --1
         WHEN "00010" => o <= a(29 DOWNTO 0) & a(31 DOWNTO 30);--2
			WHEN "00011" => o <= a(28 DOWNTO 0) & a(31 DOWNTO 29);--3
			WHEN "00100" => o <= a(27 DOWNTO 0) & a(31 DOWNTO 28);--4
			WHEN "00101" => o <= a(26 DOWNTO 0) & a(31 DOWNTO 27);--5
			WHEN "00110" => o <= a(25 DOWNTO 0) & a(31 DOWNTO 26) ;--6
			WHEN "00111" => o <= a(24 DOWNTO 0) & a(31 DOWNTO 25) ;--7
			WHEN "01000" => o <= a(23 DOWNTO 0) & a(31 DOWNTO 24) ;--8
			WHEN "01001" => o <= a(22 DOWNTO 0) & a(31 DOWNTO 23) ;--9
			WHEN "01010" => o <= a(21 DOWNTO 0) & a(31 DOWNTO 22) ;--10
			WHEN "01011" => o <= a(20 DOWNTO 0) & a(31 DOWNTO 21) ;--11
			WHEN "01100" => o <= a(19 DOWNTO 0) & a(31 DOWNTO 20) ;--12
			WHEN "01101" => o <= a(18 DOWNTO 0) & a(31 DOWNTO 19) ;--13
			WHEN "01110" => o <= a(17 DOWNTO 0) & a(31 DOWNTO 18) ;--14
			WHEN "01111" => o <= a(16 DOWNTO 0) & a(31 DOWNTO 17) ;--15
			WHEN "10000" => o <= a(15 DOWNTO 0) & a(31 DOWNTO 16) ;--16
			WHEN "10001" => o <= a(14 DOWNTO 0) & a(31 DOWNTO 15) ;--17
			WHEN "10010" => o <= a(13 DOWNTO 0) & a(31 DOWNTO 14) ;--18
			WHEN "10011" => o <= a(12 DOWNTO 0) & a(31 DOWNTO 13) ;--19
			WHEN "10100" => o <= a(11 DOWNTO 0) & a(31 DOWNTO 12) ;--20
			WHEN "10101" => o <= a(10 DOWNTO 0) & a(31 DOWNTO 11) ;--21
			WHEN "10110" => o <= a(9 DOWNTO 0) & a(31 DOWNTO 10) ;--22
			WHEN "10111" => o <= a(8 DOWNTO 0) & a(31 DOWNTO 9) ;--23
			WHEN "11000" => o <= a(7 DOWNTO 0) & a(31 DOWNTO 8) ;--24
			WHEN "11001" => o <= a(6 DOWNTO 0) & a(31 DOWNTO 7) ;--25
			WHEN "11010" => o <= a(5 DOWNTO 0) & a(31 DOWNTO 6) ;--26
			WHEN "11011" => o <= a(4 DOWNTO 0) & a(31 DOWNTO 5) ;--27
			WHEN "11100" => o <= a(3 DOWNTO 0) & a(31 DOWNTO 4) ;--28
			WHEN "11101" => o <= a(2 DOWNTO 0) & a(31 DOWNTO 3) ;--29
			WHEN "11110" => o <= a(1 DOWNTO 0) & a(31 DOWNTO 2) ;--30
			WHEN "11111" => o <= a(0) & a(31 DOWNTO 1) ;--31
			WHEN OTHERS => o <= a ;--0	
			end case;
		elsif (right_rot = '1') then
			case b(4 downto 0) is
			when "00001" => o <= a(0) & a(31 downto 1); --1
         WHEN "00010" => o <= a(1 DOWNTO 0) & a(31 DOWNTO 2);--2
			WHEN "00011" => o <= a(2 DOWNTO 0) & a(31 DOWNTO 3);--3
			WHEN "00100" => o <= a(3 DOWNTO 0) & a(31 DOWNTO 4);--4
			WHEN "00101" => o <= a(4 DOWNTO 0) & a(31 DOWNTO 5);--5
			WHEN "00110" => o <= a(5 DOWNTO 0) & a(31 DOWNTO 6) ;--6
			WHEN "00111" => o <= a(6 DOWNTO 0) & a(31 DOWNTO 7) ;--7
			WHEN "01000" => o <= a(7 DOWNTO 0) & a(31 DOWNTO 8) ;--8
			WHEN "01001" => o <= a(8 DOWNTO 0) & a(31 DOWNTO 9) ;--9
			WHEN "01010" => o <= a(9 DOWNTO 0) & a(31 DOWNTO 10) ;--10
			WHEN "01011" => o <= a(10 DOWNTO 0) & a(31 DOWNTO 11) ;--11
			WHEN "01100" => o <= a(11 DOWNTO 0) & a(31 DOWNTO 12) ;--12
			WHEN "01101" => o <= a(12 DOWNTO 0) & a(31 DOWNTO 13) ;--13
			WHEN "01110" => o <= a(13 DOWNTO 0) & a(31 DOWNTO 14) ;--14
			WHEN "01111" => o <= a(14 DOWNTO 0) & a(31 DOWNTO 15) ;--15
			WHEN "10000" => o <= a(15 DOWNTO 0) & a(31 DOWNTO 16) ;--16
			WHEN "10001" => o <= a(16 DOWNTO 0) & a(31 DOWNTO 17) ;--17
			WHEN "10010" => o <= a(17 DOWNTO 0) & a(31 DOWNTO 18) ;--18
			WHEN "10011" => o <= a(18 DOWNTO 0) & a(31 DOWNTO 19) ;--19
			WHEN "10100" => o <= a(19 DOWNTO 0) & a(31 DOWNTO 20) ;--20
			WHEN "10101" => o <= a(20 DOWNTO 0) & a(31 DOWNTO 21) ;--21
			WHEN "10110" => o <= a(21 DOWNTO 0) & a(31 DOWNTO 22) ;--22
			WHEN "10111" => o <= a(22 DOWNTO 0) & a(31 DOWNTO 23) ;--23
			WHEN "11000" => o <= a(23 DOWNTO 0) & a(31 DOWNTO 24) ;--24
			WHEN "11001" => o <= a(24 DOWNTO 0) & a(31 DOWNTO 25) ;--25
			WHEN "11010" => o <= a(25 DOWNTO 0) & a(31 DOWNTO 26) ;--26
			WHEN "11011" => o <= a(26 DOWNTO 0) & a(31 DOWNTO 27) ;--27
			WHEN "11100" => o <= a(27 DOWNTO 0) & a(31 DOWNTO 28) ;--28
			WHEN "11101" => o <= a(28 DOWNTO 0) & a(31 DOWNTO 29) ;--29
			WHEN "11110" => o <= a(29 DOWNTO 0) & a(31 DOWNTO 30) ;--30
			WHEN "11111" => o <= a(30 DOWNTO 0) & a(31) ;--31
			WHEN OTHERS => o <= a ;--0	
			end case;
		end if;
	end if;
	end process;
--
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
		if clr = '0' then
			clkdiv <= (others => '0');
		elsif clk'event and clk = '1' then
			clkdiv <= clkdiv + 1;
		end if;
	end process;
end Behavioral;

