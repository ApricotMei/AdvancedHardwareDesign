--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:19:11 09/25/2016
-- Design Name:   
-- Module Name:   C:/lab/Lab1/Lab1_RR_test.vhd
-- Project Name:  Lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Lab1_RR
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Lab1_RR_test IS
END Lab1_RR_test;
 
ARCHITECTURE behavior OF Lab1_RR_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Lab1_RR
    PORT(
         a : IN  std_logic_vector(31 downto 0);
         b : IN  std_logic_vector(7 downto 0);
         o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(31 downto 0) := (others => '0');
   signal b : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal o : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  -- constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Lab1_RR PORT MAP (
          a => a,
          b => b,
          o => o
        );

   -- Clock process definitions
  -- <clock>_process :process
  -- begin
	--	<clock> <= '0';
		--wait for <clock>_period/2;
	--	<clock> <= '1';
	--	wait for <clock>_period/2;
   --end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	a <= "10000000000000000000000000000000";
	wait for 100 ns;
	a <= "11000000000000000000000000000000";
	wait for 100 ns;
	a <= "11100000000000000000000000000000";
	wait for 100 ns;
	a <= "11110000000000000000000000000000";
	wait for 100 ns;
	a <= "11111000000000000000000000000000";
	wait for 100 ns;
   end process;

   stim_proc1: process
   begin		
	b <= "00000001";
   wait for 20 ns;
	b <= "00100001";
   wait for 20 ns;
	b <= "01000011";
   wait for 20 ns;
	b <= "10000111";
   wait for 20 ns;
	b <= "10010000";
	wait for 20 ns;
   end process;

END;
