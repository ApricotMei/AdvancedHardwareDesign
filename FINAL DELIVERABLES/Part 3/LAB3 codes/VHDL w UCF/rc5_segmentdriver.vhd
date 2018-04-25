----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:16:02 10/25/2016 
-- Design Name: 
-- Module Name:    rc5_segmentdriver - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rc5_segmentdriver is
    Port ( clk:in std_logic;
			  displayA,displayB,displayC,displayD,displayE,displayF,displayG,displayH : in std_logic_vector(3 downto 0);
			  segA,segB,segC,segD,segE,segF,segG:out std_logic;
			  selectA,selectB,selectC,selectD,selectE,selectF,selectG,selectH:out std_logic);
end rc5_segmentdriver;

architecture Behavioral of rc5_segmentdriver is
component segmentdecoder is
    Port ( Digit : in  STD_LOGIC_VECTOR (3 downto 0);
           segment_A : out  STD_LOGIC;
           segment_B : out  STD_LOGIC;
           segment_C : out  STD_LOGIC;
           segment_D : out  STD_LOGIC;
           segment_E : out  STD_LOGIC;
           segment_F : out  STD_LOGIC;
           segment_G : out  STD_LOGIC);
end component;
component clock_divider is
    Port ( clk : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_clk : out  STD_LOGIC_VECTOR (15 downto 0));
end component;
signal temporary_data : std_logic_vector(3 downto 0);
signal clock_word : std_logic_vector(15 downto 0);
signal slow_clock: std_logic;
begin
-- connect out
	uut: segmentdecoder port map(
		Digit => temporary_data,
		segment_A => segA,
		segment_B => segB,
		segment_C => segC,
		segment_D => segD,
		segment_E => segE,
		segment_F => segF,
		segment_G => segG
	);
	
	uut1: clock_divider port map(
		clk => clk,
		enable => '1',
		reset => '0',
		data_clk => clock_word
	);
slow_clock <= clock_word(15);	
process(slow_clock)
variable display_selection : std_logic_vector(2 downto 0);
begin 
		--select which segment to display
		if(slow_clock'event and slow_clock = '1') then 
			case display_selection is 
				when "000" => temporary_data <= displayA;
				
					selectA <= '0';
					selectB <= '1';
					selectC <= '1';
					selectD <= '1';
					selectE <= '1';
					selectF <= '1';
					selectG <= '1';
					selectH <= '1';
					
					display_selection := display_selection + '1';
				when "001" => temporary_data <= displayB;
				
					selectA <= '1';
					selectB <= '0';
					selectC <= '1';
					selectD <= '1';
					selectE <= '1';
					selectF <= '1';
					selectG <= '1';
					selectH <= '1';					
					display_selection := display_selection + '1';
				when "010" => temporary_data <= displayC;
				
					selectA <= '1';
					selectB <= '1';
					selectC <= '0';
					selectD <= '1';
					selectE <= '1';
					selectF <= '1';
					selectG <= '1';
					selectH <= '1';					
					display_selection := display_selection + '1';
				when "011" => temporary_data <= displayD;
				
					selectA <= '1';
					selectB <= '1';
					selectC <= '1';
					selectD <= '0';
					selectE <= '1';
					selectF <= '1';
					selectG <= '1';
					selectH <= '1';					
					display_selection := display_selection + '1';
				when "100" => temporary_data <= displayE;
				
					selectA <= '1';
					selectB <= '1';
					selectC <= '1';
					selectD <= '1';
					selectE <= '0';
					selectF <= '1';
					selectG <= '1';
					selectH <= '1';					
					display_selection := display_selection + '1';
				when "101" => temporary_data <= displayF;
				
					selectA <= '1';
					selectB <= '1';
					selectC <= '1';
					selectD <= '1';
					selectE <= '1';
					selectF <= '0';
					selectG <= '1';
					selectH <= '1';					
					display_selection := display_selection + '1';
					
				when "110" => temporary_data <= displayG;
				
					selectA <= '1';
					selectB <= '1';
					selectC <= '1';
					selectD <= '1';
					selectE <= '1';
					selectF <= '1';
					selectG <= '0';
					selectH <= '1';					
					display_selection := display_selection + '1';
					
				when others => temporary_data <= displayH;
				
					selectA <= '1';
					selectB <= '1';
					selectC <= '1';
					selectD <= '1';
					selectE <= '1';
					selectF <= '1';
					selectG <= '1';
					selectH <= '0';					
					display_selection := display_selection + '1';
				end case;															
		end if;
end process;
end Behavioral;

