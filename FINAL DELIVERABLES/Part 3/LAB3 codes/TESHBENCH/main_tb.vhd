-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
	use work.final.all;
  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
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

        SIGNAL clk, clk_tmp, key_in, enc, dec, key_rdy, data_rdy, changecommit: std_logic;
        SIGNAL reg,memdata:  mem_array;
		  signal ukey : std_logic_vector(127 downto 0);
		  signal AB: std_logic_vector(63 downto 0);
		  signal changeAddress, changeInstruction: std_logic_vector(31 downto 0);
		  CONSTANT   ClkPeriod	: Time:= 10 ns;


  BEGIN

  -- Component Instantiation
          uut: main PORT MAP(
				clk => clk,
				enc => enc,
				dec => dec,
				reg => reg,
				memdata => memdata,
				ukey => ukey,
				AB => AB,
				key_rdy => key_rdy,
				key_in => key_in,
				data_rdy => data_rdy,
				changeAddress => changeAddress,
				changecommit => changecommit,
				changeInstruction => changeInstruction
          );

 sti_clk: PROCESS
   BEGIN
      clk_tmp<='0';
      LOOP
         WAIT FOR (ClkPeriod/2);   clk_tmp<=NOT clk_tmp;
      END LOOP;
   END PROCESS;
   clk<=clk_tmp;

  --  Test Bench Statements
     tb : PROCESS
     BEGIN
	  -- encryption decryption keyexpansion when ukey = 0 AB = 0 
		  ukey <= x"00000000000000000000000000000000";
		  AB <= x"0000000000000000";
		  key_in <= '1';
        wait for 100 ns;
		  key_in <= '0';
		  wait for 200 us;
		  enc <= '1';
		  wait for 100 ns;
		  enc <= '0';
		  wait for 200 us;
		  dec <= '1';
		  wait for 100 ns;
		  dec <= '0';
		  wait for 200 us;
	-- encryption decryption keyexpansion when ukey = 1 AB = 1 
		  ukey <= x"00000000000000000000000000000001";
		  AB <= x"0000000000000001";
		  key_in <= '1';
		  wait for 100 ns;
		  key_in <= '0';
		  wait for 200 us;
		  enc <= '1';
		  wait for 100 ns;
		  enc <= '0';
		  wait for 200 us;
		  dec <= '1';
		  wait for 100 ns;
		  dec <= '0';
		  wait for 200 us;		  
	-- change instruction dynamically 
	-- we change instructions in key expansion to 0, so key expansion will be invalid
		  changeAddress <= x"00000001";
		  changeInstruction <= x"00000000";
		  changecommit <= '1';
		  wait for 10 ns;		  
		  changeAddress <= x"00000002";
		  wait for 10 ns;		  
		  changeAddress <= x"00000003";
		  wait for 10 ns;		  
		  changeAddress <= x"00000004";
		  wait for 10 ns;		  
		  changeAddress <= x"00000005";
		  wait for 10 ns;		  
		  changeAddress <= x"00000006";
		  wait for 10 ns;
		  changeAddress <= x"00000007";
		  wait for 10 ns;
		  changeAddress <= x"00000008";
		  wait for 10 ns;
		  changeAddress <= x"00000009";
		  wait for 10 ns;
		  changeAddress <= x"0000000a";
		  wait for 10 ns;
		  changeAddress <= x"0000000b";
		  wait for 10 ns;
		  changeAddress <= x"0000000c";
		  wait for 10 ns;
		  changeAddress <= x"0000000d";
		  wait for 10 ns;
		  changeAddress <= x"0000000e";
		  wait for 10 ns;
		  changeAddress <= x"0000000f";
		  wait for 10 ns;
		  changeAddress <= x"00000010";
		  wait for 10 ns;
		  changeAddress <= x"00000011";
		  wait for 10 ns;
		  changeAddress <= x"00000012";
		  wait for 10 ns;
		  changeAddress <= x"00000013";
		  wait for 10 ns;
		  changeAddress <= x"00000014";
		  wait for 10 ns;
		  changeAddress <= x"00000015";
		  wait for 10 ns;
		  changeAddress <= x"00000016";
		  wait for 10 ns;
		  changeAddress <= x"00000017";
		  wait for 10 ns;
		  changeAddress <= x"00000018";
		  wait for 10 ns;
		  changeAddress <= x"00000019";
		  wait for 10 ns;
		  changeAddress <= x"0000001a";
		  wait for 10 ns;
		  changeAddress <= x"0000001b";
		  wait for 10 ns;
		  changeAddress <= x"0000001c";
		  wait for 10 ns;
		  changeAddress <= x"0000001d";
		  wait for 10 ns;
		  changeAddress <= x"0000001e";
		  wait for 10 ns;
		  changeAddress <= x"0000001f";
		  wait for 10 ns;
		  changeAddress <= x"00000020";
		  wait for 10 ns;
		  changeAddress <= x"00000021";
		  wait for 10 ns;
		  changeAddress <= x"00000022";
		  wait for 10 ns;
		  changecommit <= '0';
		  ukey <= x"00000000000000000000000000000000";
		  AB <= x"0000000000000000";
		  key_in <= '1';
        wait for 100 ns;
		  key_in <= '0';
		  wait for 200 us;
		  -- register file will be all 0s!!!!!
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
