-- TestBench Template 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

PACKAGE processor_pkg IS
	type DATAMEM is array (63 downto 0) of std_logic_vector(31 downto 0);
	type REG is array (31 downto 0) of std_logic_vector(31 downto 0);
	type T_MEM is array (127 downto 0) of std_logic_vector(31 downto 0);
END processor_pkg;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.PROCESSOR_PKG.ALL; 
use ieee.std_logic_textio.all;
use std.textio.all;


-- entity declaration for your testbench.Dont declare any ports here
ENTITY test_tb IS 
END test_tb;

ARCHITECTURE behavior OF test_tb IS
   -- Component Declaration for the Unit Under Test (UUT)
COMPONENT NYU_6463Processor  --'test' is the name of the module needed to be tested.
--just copy and paste the input and output ports of your module as such. 
PORT( 
		reset_reg:	IN	STD_LOGIC;
		reset_mem:  IN STD_LOGIC;
      clr, clk_in	: IN     STD_LOGIC;
		memory_out_put: out DATAMEM
);
END COMPONENT;
   --declare inputs and initialize them

signal clk_in : std_logic := '0';
signal reset_reg : std_logic := '0';
signal reset_mem : std_logic := '0';
signal clr	     : std_logic := '0';
   --declare outputs and initialize them
signal memory_out_put: DATAMEM;
   -- Clock period definitions
constant clk_period : time := 1 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
uut: NYU_6463Processor PORT MAP (
	clk_in => clk_in,
	reset_reg => reset_reg,
	reset_mem => reset_mem,
	clr => clr,
	memory_out_put => memory_out_put
);       

   -- Clock process definitions( clock with 50% duty cycle is generated here.
   clk_process :process
   begin
        clk_in <= '0';
        wait for clk_period/2;  --for 0.5 ns signal is '0'.
        clk_in <= '1';
        wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   end process;
   -- Stimulus process
  stim_proc: process
   begin         
        wait for 3 ns;
        clr <='1';
        wait for 2 ns;
        reset_reg <='1';
        wait for 2 ns;
        reset_mem <= '1';
        wait for 2 ns;
        clr <='0';
        wait for 2 ns;
        reset_reg <='0';
        wait for 2 ns;
        reset_mem <= '0';
        wait;
  end process;
  
process(memory_out_put,clk_in)
 FILE f : TEXT;
FILE fout: TEXT;
constant filename : string :="memory.txt";
VARIABLE L : LINE;
VARIABLE LOUT: LINE;
variable i : integer:=0;
variable j : integer:=0;
variable b : std_logic_vector(31 downto 0);
begin
  
  if (clk_in'EVENT and clk_in='1') then
				j:=0;
  				File_Open (fout ,FILENAME, write_mode);	
				while ((j<=63)) loop
					write(LOUT,memory_out_put(j));
					writeline(fout,LOUT);
					j := j + 1;
				end loop;
	end if;
	end process;

END;