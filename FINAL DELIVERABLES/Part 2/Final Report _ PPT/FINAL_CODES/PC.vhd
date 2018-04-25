----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2017 10:36:38 AM
-- Design Name: 
-- Module Name: PC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
 Port (clk: in std_logic;
		enc, dec: in std_logic;
		key_in: in std_logic;
		NextAddress: in std_logic_vector(31 downto 0);
		CurrentAddress: out std_logic_vector(31 downto 0);
		data_rdy: out std_logic;
		key_rdy: out std_logic );
end PC;

architecture Behavioral of PC is
type state is (IDLE, RUNNING);
signal s1: state;
signal address: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal nextadd: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
begin
process(clk)
	begin
	CurrentAddress <= address;
	if (clk'event and clk = '1' and s1 = RUNNING) then
		address <= nextadd;
	end if;
end process;

nextadd <= "00000000000000000000000000000000" WHEN(key_in = '1')else
			  "00000000000000000000000110001100" when(enc = '1') else
			  "00000000000000000000001100011100" when(dec = '1') else
			  nextaddress;
			  
process(clk)
begin
	if(clk'event and clk = '1') then
		case s1 is
			when IDLE => 
				-- if key_in = '1' go running set nextaddress to 0
				if(key_in = '1') then
					s1 <= RUNNING;
					key_rdy <= '0';
					data_rdy <= '0';
				elsif(enc = '1') then
					s1 <= RUNNING;
				elsif(dec ='1') then
					s1 <= RUNNING;
				end if;
			when RUNNING => 
				if(nextaddress = "00000000000000000000000101000000") then
					s1 <= IDLE;	
					key_rdy <= '1';
				ELSIF(nextaddress = "00000000000000000000001011010000") then
					s1 <= IDLE;
					data_rdy <= '1';
				ELSIF(nextaddress = "00000000000000000000010001100000") then
					s1 <= IDLE;
					data_rdy <= '1';
				END IF;
		end case;
	end if;
end process;

end Behavioral;
