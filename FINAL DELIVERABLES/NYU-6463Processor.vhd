----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:30:07 12/02/2016 
-- Design Name: 
-- Module Name:    NYU-6463Processor - Behavioral 
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

PACKAGE processor_pkg IS
	type DATAMEM is array (63 downto 0) of std_logic_vector(31 downto 0);
	type REG is array (31 downto 0) of std_logic_vector(31 downto 0);
	type T_MEM is array (127 downto 0) of std_logic_vector(31 downto 0);
END processor_pkg;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.PROCESSOR_PKG.ALL;  

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NYU_6463Processor is
   PORT
   (	
		x: in STD_LOGIC_VECTOR (6 downto 0);
	   a_to_g : out STD_LOGIC_VECTOR (6 downto 0);
   	an : out STD_LOGIC_VECTOR (7 downto 0);
		is_im: in STD_LOGIC;
		is_rf: in STD_LOGIC;
		is_dm: in STD_LOGIC;
		mode: in STD_LOGIC;
		is_key:in STD_LOGIC;
		is_enc:in STD_LOGIC;
		is_dec:in STD_LOGIC;
--		led  : out STD_LOGIC_VECTOR (2 downto 0);
		if_im: out STD_LOGIC;
		if_rf: out STD_LOGIC;
		if_dm: out STD_LOGIC;
		if_mode:out STD_LOGIC;
		if_key: out STD_LOGIC;
		if_enc: out STD_LOGIC;
		if_dec: out STD_LOGIC;
		
		reset_reg:	IN	STD_LOGIC;
		reset_mem:  IN STD_LOGIC;
--		reset_im:	IN STD_LOGIC;
		man_clk:		IN STD_LOGIC;
      clr, clk_in	: IN     STD_LOGIC
   );
end NYU_6463Processor;

architecture Behavioral of NYU_6463Processor is

COMPONENT  PC  -- Program counter register module
   PORT
   (	
      clr, clk	: IN     STD_LOGIC;
		new_PC   : IN		STD_LOGIC;
		IsBranch : IN		STD_LOGIC;
		IsJump	: IN		STD_LOGIC;
		IsHal		: IN		STD_LOGIC;
		Imm		: IN		STD_LOGIC_VECTOR (15 downto 0);
		Address	: IN		STD_LOGIC_VECTOR (25 downto 0);
		PCounter	: OUT		STD_LOGIC_VECTOR (31 downto 0)
   );
END COMPONENT;

COMPONENT  IM  -- Instruction Memroy
   PORT
   (	
--      clr		: IN     STD_LOGIC;
		PCounter	: IN		STD_LOGIC_VECTOR (31 downto 0);
		IM_in		: IN		T_MEM;
		IsItype	: OUT		STD_LOGIC;
		IsRtype	: OUT		STD_LOGIC;
		IsJtype	: OUT		STD_LOGIC;
		Opcode	: OUT		STD_LOGIC_VECTOR (5 downto 0);
		Rs			: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Rt			: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Rd			: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Shamt		: OUT		STD_LOGIC_VECTOR (4 downto 0);
		Funct		: OUT		STD_LOGIC_VECTOR (5 downto 0);
		Imm		: OUT		STD_LOGIC_VECTOR (15 downto 0);
		Address	: OUT		STD_LOGIC_VECTOR (25 downto 0);
		IM_out	: OUT T_MEM		
   );
END COMPONENT;

COMPONENT  RF  -- Register File
PORT
(
		reset_reg: IN		STD_LOGIC;
		clk		: IN		STD_LOGiC;
		Rs			: IN		STD_LOGIC_VECTOR (4 downto 0);
		Rt			: IN		STD_LOGIC_VECTOR (4 downto 0);
		Rd			: IN		STD_LOGIC_VECTOR (4 downto 0);
		IsRtype	: IN		STD_LOGIC;
		IsItype	: IN		STD_LOGIC;
		wrt_enable:IN		STD_LOGIC;
		wrt_data	: IN		STD_LOGIC_VECTOR (31 downto 0);
		RD1		: OUT		STD_LOGIC_VECTOR (31 downto 0);
		RD2		: OUT		STD_LOGIC_VECTOR (31 downto 0);
		REFile_out:OUT		REG
);
END COMPONENT;

COMPONENT  ALU  -- ALU
   PORT
   (	
		IsItype	: IN		STD_LOGIC;
		IsRtype	: IN		STD_LOGIC;
		IsJtype	: IN		STD_LOGIC;
		Opcode	: IN		STD_LOGIC_VECTOR (5 downto 0);
		RD1		: IN		STD_LOGIC_VECTOR (31 downto 0);
		RD2		: IN		STD_LOGIC_VECTOR (31 downto 0);
		Funct		: IN		STD_LOGIC_VECTOR (5 downto 0);
		Imm		: IN		STD_LOGIC_VECTOR (15 downto 0);
		new_PC   : OUT		STD_LOGIC;
		IsBranch : OUT		STD_LOGIC;
		IsJump	: OUT		STD_LOGIC;
		IsHal		: OUT		STD_LOGIC;
		wrt_enable:OUT		STD_LOGIC;
		wrt_data	: OUT		STD_LOGIC_VECTOR (31 downto 0);		
		Address_mem:			OUT	STD_LOGIC_VECTOR (31 downto 0);
		datamemory_data_out: OUT	STD_LOGIC_VECTOR (31 downto 0);
		datamemory_data_in: 	IN 	STD_LOGIC_VECTOR (31 downto 0)
   );
END COMPONENT;

COMPONENT DM
	PORT
	(
		reset_mem,clk		 :	IN 	STD_LOGIC;
		datamemory_in      : IN		DATAMEM;
		Address_mem        :	IN		STD_LOGIC_VECTOR (31 downto 0);
		datamemory_data_out: IN		STD_LOGIC_VECTOR (31 downto 0);
		Opcode				 : IN		STD_LOGIC_VECTOR (5 downto 0);
		datamemory_data_in : OUT 	STD_LOGIC_VECTOR (31 downto 0);
		datamemory_out		 : OUT	DATAMEM
	);
END COMPONENT;

signal s: STD_LOGIC_VECTOR (2 downto 0);
signal digit: STD_LOGIC_VECTOR (3 downto 0);
signal aen: STD_LOGIC_VECTOR (7 downto 0);
signal clkdiv: STD_LOGIC_VECTOR (20 downto 0);
signal o: STD_LOGIC_VECTOR (31 downto 0);
signal count: STD_LOGIC_VECTOR (3 downto 0);
signal count_2: STD_LOGIC_VECTOR (21 downto 0);

signal	new_PC   : 		STD_LOGIC;
signal	IsBranch : 		STD_LOGIC;
signal	IsJump	: 		STD_LOGIC;
signal	IsHal		: 		STD_LOGIC;
signal	Imm		: 		STD_LOGIC_VECTOR (15 downto 0);
signal	Address	: 		STD_LOGIC_VECTOR (25 downto 0);
signal	PCounter	: 		STD_LOGIC_VECTOR (31 downto 0);
signal	IsItype	: 		STD_LOGIC;
signal	IsRtype	: 		STD_LOGIC;
signal	IsJtype	: 		STD_LOGIC;
signal	Opcode	: 		STD_LOGIC_VECTOR (5 downto 0);
signal	Rs			: 		STD_LOGIC_VECTOR (4 downto 0);
signal	Rt			: 		STD_LOGIC_VECTOR (4 downto 0);
signal	Rd			: 		STD_LOGIC_VECTOR (4 downto 0);
signal	Shamt		: 		STD_LOGIC_VECTOR (4 downto 0);
signal	Funct		: 		STD_LOGIC_VECTOR (5 downto 0);
signal	wrt_enable:		STD_LOGIC;
signal	wrt_data	: 		STD_LOGIC_VECTOR (31 downto 0);
signal	RD1		: 		STD_LOGIC_VECTOR (31 downto 0);
signal	RD2		: 		STD_LOGIC_VECTOR (31 downto 0);
signal	IM_out	: 		T_MEM;
signal   REFile_out:		REG;
signal	datamemory_out:DATAMEM;
signal   clk		:		STD_LOGIC;
signal 	clk_tmp  : 		STD_LOGIC;
signal	Address_mem:			STD_LOGIC_VECTOR (31 downto 0);
signal	datamemory_data_out: STD_LOGIC_VECTOR (31 downto 0);
signal	datamemory_data_in: 	STD_LOGIC_VECTOR (31 downto 0);
signal	IM_in		:		T_MEM;

--initialization
	CONSTANT  IM_in_org : T_MEM:=T_MEM'(X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
			   	 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000");

	CONSTANT  IM_in_key : T_MEM:=T_MEM'(X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
			   	 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"FC000000", X"240FFFE4", X"04010000", X"0408001e", X"30000024", X"2A320001", X"3000000B",
					 X"0408001E", X"2509FFEC", X"24410003", X"06310001", X"05080001", X"21050000", X"25D0FFFD", X"05CE0001",
					 X"14A50001", X"28100003", X"0D70001F", X"014B2810", X"00855810", X"04210001", X"20240000", X"14E40003",
					 X"00C53810", X"00643010", X"1D0A0000", X"1C230000", X"040E0000", X"09EF0001", X"04120034", X"040f0003",
					 X"040E0000", X"04090022", X"0408001E", X"04050000", X"04040000", X"04020019", X"04010000", X"00000000");
					 
	CONSTANT  IM_in_enc : T_MEM:=T_MEM'(X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
			   	 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"FC000000", X"2003001D", X"2002001C", X"2D0AFFE5", X"05080001", X"00611810", X"2D20FFFD", X"09290001",
					 X"14630001", X"29200003", X"0C49001F", X"00C71814", X"00623814", X"00853014", X"00422814", X"00632014",
					 X"1D010000", X"05080001", X"00411010", X"2D20FFFD", X"09290001", X"14420001", X"29200003", X"0C69001F",
					 X"00C71014", X"00433814", X"00853014", X"00632814", X"00422014", X"1D010000", X"05080001", X"00611810",
					 X"1D010000", X"05080001", X"00411010", X"1D010000", X"054A001A", X"1C03001B", X"1C02001A", X"00000000");
					 
	CONSTANT  IM_in_dec : T_MEM:=T_MEM'(X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
			   	 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"FC000000", X"20010024",
					 X"20020023", X"00571011", X"00360811", X"1C170000", X"1C160001", X"2663FFE3", X"02321014", X"01F09014",
					 X"01818814", X"00218014", X"018C7814", X"040E0000", X"25D8FFFD", X"05CE0001", X"198C0001", X"28140003",
					 X"0C38001F", X"096B0002", X"00556011", X"012A0814", X"00E85014", X"00824814", X"00424014", X"00843814",
					 X"04060000", X"24D8FFFD", X"04C60001", X"18840001", X"28140003", X"0C58001F", X"08630002", X"00342011",
					 X"1D750000", X"1C740000", X"040B0018", X"04030019", X"04130001", X"1C02001C", X"1C01001D", X"00000000");   	 
					 
	CONSTANT  datamemory_in : DATAMEM:=DATAMEM'(X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
			   	 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"AAAAAAAA", X"AAAAAAAA", X"00000000", X"00000000", X"00000000",
					 X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"2b4c3474", X"8d14babb",
					 X"eedd4102", X"50a5c749", X"b26e4d90", X"1436d3d7", X"75ff5a1e", X"d7c7e065", X"399066ac", X"9b58ecf3",
					 X"fd21733a", X"5ee9f981", X"c0b27fc8", X"227b060f", X"84438c56", X"e60c129d", X"47d498e4", X"a99d1f2b",
					 X"0b65a572", X"6d2e2bb9", X"cef6b200", X"30bf3847", X"9287be8e", X"f45044d5", X"5618cb1c", X"b7e15163");
--end of initialization

begin

process(clk_in,clr)
begin

	if (clr = '1') then
		count<=(others=>'0');
	elsif (clk_in'EVENT and clk_in='1') then
		if(count="1111")then
			count<=(others=>'0');
		else
			count<=count+'1';
		end if;
	end if;
end process;

process(clk_in,clr)
begin

	if (clr = '1') then
		count_2<=(others=>'0');
	elsif (clk_in'EVENT and clk_in='1') then
		if(count_2="1111111111111111111111")then
			count_2<=(others=>'0');
		else
			count_2<=count_2+'1';
		end if;
	end if;
end process;

process(mode,count,man_clk,count_2)
begin

	if(mode='0') then
		clk <= count(2); if_mode <= '0';
	elsif(mode='1') then
		if_mode <= '1';
		if (man_clk='1') then
			clk <= count_2(21);
		elsif (man_clk = '0') then
			clk <= '0';
		end if;
	end if;
end process;

   U1: PC  PORT MAP(clr=>clr, clk=>clk, new_pc=>new_pc, IsBranch=>IsBranch, IsJump => IsJump, IsHal => IsHal, Imm => Imm, Address => Address, PCounter=>PCounter);
   U2: IM  PORT MAP(IM_in=>IM_in, IM_out=>IM_out, PCounter=>PCounter, IsItype=>IsItype, IsRtype=>IsRtype, IsJtype=>IsJtype, Opcode=>Opcode, Rs=>Rs, Rt=>Rt, Rd=>Rd, Shamt=>Shamt, Funct=>Funct, Imm=>Imm, Address=>Address);
   U3: RF  PORT MAP(reset_reg=>reset_reg, clk=>clk, REFile_out=>REFile_out, Rs=>Rs, Rt=>Rt, Rd=>Rd, IsItype=>IsItype, IsRtype=>IsRtype, wrt_enable => wrt_enable, wrt_data=>wrt_data, RD1=>RD1, RD2=>RD2);
	U4: ALU PORT MAP(RD1=>RD1, RD2=>RD2, Funct=>Funct, Imm=>Imm, IsItype=>IsItype, IsRtype=>IsRtype, IsJtype=>IsJtype, Opcode=>Opcode, new_pc=>new_pc, IsBranch=>IsBranch, IsJump=>IsJump, IsHal=>IsHal, wrt_enable=>wrt_enable, wrt_data=>wrt_data,Address_mem=>Address_mem,datamemory_data_out=>datamemory_data_out,datamemory_data_in=>datamemory_data_in);
	U5: DM  PORT MAP(reset_mem=>reset_mem, clk=>clk, datamemory_in=>datamemory_in, Address_mem=>Address_mem, datamemory_data_out=>datamemory_data_out, Opcode=>Opcode, datamemory_data_in=>datamemory_data_in, datamemory_out=>datamemory_out);

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
	process (clk_in,clr)
	begin
		if clr = '1' then
			clkdiv <= (others => '0');
		elsif clk_in'event and clk_in = '1' then
			clkdiv <= clkdiv + 1;
		end if;
end process;
-- end of output through ssd

--output control
process (x,clk_in,clr,is_im, is_rf, is_dm, IM_out, REFILE_out, datamemory_out, mode, PCounter)
	begin 
		if (clr = '1') then
			o<= (others => '0');
		elsif (clk_in'EVENT and clk_in='1')then
			if (is_im = '1') and (is_rf = '0') and (is_dm = '0') then
				if_im <= '1'; if_rf <= '0'; if_dm <= '0';
				o<=IM_out(conv_integer(x(6 downto 0)));
			elsif (is_im = '0') and (is_rf = '1') and (is_dm = '0') then
				if_im <= '0'; if_rf <= '1'; if_dm <= '0';
				o<=REFILE_out(conv_integer(x(4 downto 0)));
			elsif (is_im = '0') and (is_rf = '0') and (is_dm = '1') then
				if_im <= '0'; if_rf <= '0'; if_dm <= '1';
				o<=datamemory_out(conv_integer(x(5 downto 0)));
			elsif (mode = '1') and (is_im = '0') and (is_rf = '0') and (is_dm = '0') then
				o<=IM_out(conv_integer(PCounter)); if_im <= '0'; if_rf <= '0'; if_dm <= '0';
			else
				if_im <= '0'; if_rf <= '0'; if_dm <= '0';
			end if;
		end if;
end process;
--end of output control

--instruction memory control
process (clk_in,clr,is_key, is_enc, is_dec)
	begin 
		if (clr = '1') then
			if_key <= '0'; if_enc <= '0'; if_dec <= '0';IM_in	<= IM_in_org;
		elsif (clk_in'EVENT and clk_in='1')then
			if (is_key = '1') and (is_enc = '0') and (is_dec = '0') then
				if_key <= '1'; if_enc <= '0'; if_dec <= '0';
				IM_in <= IM_in_key;
			elsif (is_key = '0') and (is_enc = '1') and (is_dec = '0') then
				if_key <= '0'; if_enc <= '1'; if_dec <= '0';
				IM_in <= IM_in_enc;
			elsif (is_key = '0') and (is_enc = '0') and (is_dec = '1') then
				if_key <= '0'; if_enc <= '0'; if_dec <= '1';
				IM_in <= IM_in_dec;
			else
				if_key <= '0'; if_enc <= '0'; if_dec <= '0';
			end if;
		end if;
end process;
--instruction memory control

end Behavioral;

