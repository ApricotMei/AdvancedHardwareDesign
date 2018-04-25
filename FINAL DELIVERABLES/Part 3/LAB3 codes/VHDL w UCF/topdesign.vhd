----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:15:00 12/10/2016 
-- Design Name: 
-- Module Name:    topdesign - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.final.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity topdesign is
		port(clk: in std_logic;
			  segA,segB,segC,segD,segE,segF,segG:out std_logic;
			  selectA,selectB,selectC,selectD,selectE,selectF,selectG,selectH:out std_logic;
			  single: in std_logic;
			  din_control: in std_logic;
			  ukey_control: in std_logic;
			  changecommit: in std_logic;
			  changeAdd: in std_logic;
			  switch: in std_logic_vector(15 downto 0);
			  key_rdy: out std_logic;
			  data_rdy: out std_logic
	);
end topdesign;

architecture Behavioral of topdesign is
signal ukey: std_logic_vector(127 downto 0);
signal AB: std_logic_vector(63 downto 0);
signal reg, memdata: mem_array;
signal LED_display, changeInstruction, changeAddress: std_logic_vector(31 downto 0);
type buttonstate is(IDLE, DELAY,GET);
signal s1,s2,s3,s4,s5: buttonstate;
signal c1,c2,c4,c5, timer1, timer2, timer3, timer4, timer5, count: integer:=0;
signal clock: std_logic;
signal data_clk: std_logic;
signal singlecycle: std_logic:='1';
component main is
	port(clk: in std_logic;
		  key_in: in std_logic;
		  enc: in std_logic;
		  dec: in std_logic;
		  reg: out mem_array;
		  ukey: in std_logic_vector(127 downto 0);
		  AB: in std_logic_vector(63 downto 0);
		  key_rdy: out std_logic;
		  memdata: out mem_array;
		  data_rdy: out std_logic;
		  changeInstruction: in std_logic_vector(31 downto 0);
		  changeAddress: in std_logic_vector(31 downto 0);
		  changecommit: in std_logic
	);
end component;
component rc5_segmentdriver is
    Port ( clk:in std_logic;
			  displayA,displayB,displayC,displayD,displayE,displayF,displayG,displayH : in std_logic_vector(3 downto 0);
			  segA,segB,segC,segD,segE,segF,segG:out std_logic;
			  selectA,selectB,selectC,selectD,selectE,selectF,selectG,selectH:out std_logic);
end component;

begin
	with switch(5 downto 0) select
		LED_display <= reg(0) when "000000",
							reg(1) when "000001",
							reg(2) when "000010",
							reg(3) when "000011",
							reg(4) when "000100",
							reg(5) when "000101",
							reg(6) when "000110",
							reg(7) when "000111",
							reg(8) when "001000",
							reg(9) when "001001",
							reg(10) when "001010",
							reg(11) when "001011",
							reg(12) when "001100",
							reg(13) when "001101",
							reg(14) when "001110",
							reg(15) when "001111",
							reg(16) when "010000",
							reg(17) when "010001",
							reg(18) when "010010",
							reg(19) when "010011",
							reg(20) when "010100",
							reg(21) when "010101",
							reg(22) when "010110",
							reg(23) when "010111",
							reg(24) when "011000",
							reg(25) when "011001",
							reg(26) when "011010",
							reg(27) when "011011",
							reg(28) when "011100",
							reg(29) when "011101",
							reg(30) when "011110",
							reg(31) when "011111",
							memdata(0) when "100000",
							memdata(1) when "100001",
							memdata(2) when "100010",
							memdata(3) when "100011",
							memdata(4) when "100100",
							memdata(5) when "100101",
							memdata(6) when "100110",
							memdata(7) when "100111",
							memdata(8) when "101000",
							memdata(9) when "101001",
							memdata(10) when "101010",
							memdata(11) when "101011",
							memdata(12) when "101100",
							memdata(13) when "101101",
							memdata(14) when "101110",
							memdata(15) when "101111",
							memdata(16) when "110000",
							memdata(17) when "110001",
							memdata(18) when "110010",
							memdata(19) when "110011",
							memdata(20) when "110100",
							memdata(21) when "110101",
							memdata(22) when "110110",
							memdata(23) when "110111",
							memdata(24) when "111000",
							memdata(25) when "111001",
							memdata(26) when "111010",
							memdata(27) when "111011",
							memdata(28) when "111100",
							memdata(29) when "111101",
							memdata(30) when "111110",
							memdata(31) when "111111";
							
	rc5totalDesign: main port map(
		clk => clock,
		key_in => switch(15),
		enc => switch(14),
		dec => switch(13),
		reg => reg,
		ukey => ukey,
		AB => AB,
		key_rdy => key_rdy,
		data_rdy => data_rdy,
		memdata => memdata,
		changeInstruction => changeInstruction,
		changecommit => changecommit,
		changeAddress => changeAddress
	);
	
	rc5_segment: rc5_segmentdriver port map(
		clk => clk,
		segA => segA,
		segB => segB,
		segC => segC,
		segD => segD,
		segE => segE,
		segF => segF,
		segG => segG,
		selectA => selectA,
		selectB => selectB,
		selectC => selectC,
		selectD => selectD,
		selectE => selectE,
		selectF => selectF,
		selectG => selectG,
		selectH => selectH,
		displayA => LED_display(3 downto 0),
		displayB => LED_display(7 downto 4),
		displayC => LED_display(11 downto 8),
		displayD => LED_display(15 downto 12),
		displayE => LED_display(19 downto 16),
		displayF => LED_display(23 downto 20),
		displayG => LED_display(27 downto 24),
		displayH => LED_display(31 downto 28)	
	);
	
process(clk)
begin
	if(clk'event and clk = '1') then
		case s1 is 
			when IDLE => 
				if(din_control = '1') then
					s1 <= GET;
					c1 <= c1 +1;
				end if;
			when GET => 
				AB((8*c1-1) downto (8*(c1-1)) ) <= switch; -- input 16 bits each time
				s1 <= DELAY;
			when DELAY =>
				timer1 <= timer1 + 1;
				if(timer1 = 100000000) then  -- delay 1 s
					timer1 <= 0;
					s1 <= IDLE;
					if(c1 = 8) then
						c1<=0;
					end if;
				end if;
			end case;
		end if;
end process;

process(clk)
begin
	if(clk'event and clk = '1') then
		case s2 is 
			when IDLE => 
				if(ukey_control = '1') then
					s2 <= GET;
					c2 <= c2 +1;
				end if;
			when GET => 
				ukey((8*c2-1) downto (8*(c2-1)) ) <= switch; -- input 16 bits each time
				s2 <= DELAY;
			when DELAY =>
				timer2 <= timer2 + 1;
				if(timer2 = 100000000) then  -- delay 1 s
					timer2 <= 0;
					s2 <= IDLE;
					if(c2 = 16) then
						c2<=0;
					end if;
				end if;
			end case;
		end if;
end process;

process(clk)
begin
	if (clk'event and clk = '1') then
		count <= count + 1;
		if(count = 200000000) then
			count <= 0;
			if(data_clk = '1') then
				data_clk <= '0';
			elsif (data_clk ='0') then
				data_clk <= '1';
			end if;
		end if;
	end if;
	
end process;

process(clk)
begin
	if(clk'event and clk = '1') then
		case s3 is 
			when IDLE => 
				if(single = '1' and singlecycle = '0') then
					s3 <= DELAY;
					singlecycle <= '1';
				elsif(single = '1' and singlecycle = '1') then
					s3 <= DELAY;
					singlecycle <= '0';
				end if;
			when DELAY =>
				timer3 <= timer3 + 1;
				if(timer3 = 100000000) then  -- delay 1 s
					timer3 <= 0;
					s3 <= IDLE;
				end if;
			when GET=> 
			    
			end case;
		end if;
end process;

with singlecycle select 
	clock <= data_clk when '0', 
				clk when '1';

process(clk)
begin
	if(clk'event and clk = '1') then
		case s4 is 
			when IDLE => 
				if(changeAdd = '1') then
					s4 <= GET;
					c4 <= c4 +1;
				end if;
			when GET => 
				changeAddress((16*c4-1) downto (16*(c4-1)) ) <= switch; -- input 16 bits each time
				s4 <= DELAY;
			when DELAY =>
				timer4 <= timer4 + 1;
				if(timer4 = 100000000) then  -- delay 1 s
					timer4 <= 0;
					s4 <= IDLE;
					if(c4 = 2) then
						c4<=0;
					end if;
				end if;
			end case;
		end if;
end process;

process(clk)
begin
	if(clk'event and clk = '1') then
		case s5 is 
			when IDLE => 
				if(changecommit = '1') then
					s5 <= GET;
					c5 <= c5 +1;
				end if;
			when GET => 
				changeInstruction((16*c5-1) downto (16*(c5-1)) ) <= switch; -- input 16 bits each time
				s5 <= DELAY;
			when DELAY =>
				timer5 <= timer5 + 1;
				if(timer5 = 100000000) then  -- delay 1 s
					timer5 <= 0;
					s5 <= IDLE;
					if(c5 = 2) then
						c5<=0;
					end if;
				end if;
			end case;
		end if;
end process;
end Behavioral;

