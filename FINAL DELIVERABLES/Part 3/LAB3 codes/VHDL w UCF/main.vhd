----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:38:31 11/24/2016 
-- Design Name: 
-- Module Name:    main - Behavioral 
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
use work.final.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
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
end main;

architecture Behavioral of main is
component ALU is 
	port (
		Oprand1, Oprand2: std_logic_vector(31 downto 0);
		ALUOP: in std_logic_vector(2 downto 0);
		ALUResult: out std_logic_vector(31 downto 0)
	);
end component;

component Comparator is
	port(
		branch: in std_logic_vector(1 downto 0);
		comp1, comp2: in std_logic_vector(31 downto 0);
		Gobranch: out std_logic
	);
end component;
component PCMUX is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           c : in  STD_LOGIC_VECTOR (31 downto 0);
           NextAddress : out  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0));
end component;
component Adder is
    Port ( add1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  add2 : in  STD_LOGIC_VECTOR (31 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component DataMem is
	port (
		address, WriteData: in STD_LOGIC_VECTOR (31 downto 0);
		WriteMem, ReadMem,Clk: in STD_LOGIC;
		ReadData: out STD_LOGIC_VECTOR (31 downto 0);
		key_in: in std_logic;
		ukey: in std_logic_vector(127 downto 0);
		memdata: out mem_array
	);
end component;

component Decoder is
	port(
		instruction: in std_logic_vector(31 downto 0);
		wrtEnable, isload, isStore, Itype, JMP: out std_logic;
		branch : out std_logic_vector(1 downto 0);
		ALUOP: out std_logic_vector(2 downto 0)
	);
end component;

component InstructionMem is
	port (
		clk: in std_logic;
		ReadAddress: in STD_LOGIC_VECTOR (31 downto 0);
		instruction: out STD_LOGIC_VECTOR (31 downto 0);
		LastInsAddress: out STD_LOGIC_VECTOR (31 downto 0);
		changeInstruction: in std_logic_vector(31 downto 0);
		changeAddress: in std_logic_vector(31 downto 0);
		changecommit: in std_logic
	);
end component;

component PC is
	port(
		clk: in std_logic;
		enc, dec: in std_logic;
		key_in: in std_logic;
		NextAddress: in std_logic_vector(31 downto 0);
		CurrentAddress: out std_logic_vector(31 downto 0);
		key_rdy: out std_logic;
		data_rdy: out std_logic
	);
end component;

component SignExtend is
	port (
		x: in std_logic_vector(15 downto 0);
		y: out std_logic_vector(31 downto 0)
	);
end component;

component mux is 
	generic (n: natural:= 1); -- number of bits in the choices
	port (
		x,y: in std_logic_vector(n-1 downto 0);
		s: in std_logic;
		z: out std_logic_vector(n-1 downto 0)
	);
end component;
component RegisterFile is 
	port (
      clk: in std_logic;
		WrtEnable: in std_logic;
		reg: out mem_array;
		enc, dec, key_in: in std_logic;
		AB : in std_logic_vector(63 downto 0);		
		RdReg1, RdReg2, WrtReg: in std_logic_vector(4 downto 0);
		WrtData: in std_logic_vector(31 downto 0);
		RdData1, RdData2: out std_logic_vector(31 downto 0)
	);
end component;

signal InstructionAddress, add2, Signedimm, JumpAddress, BranchAddress, AddedPC, NextAddress, instruction, LastInsAddress, ALUResult, RdData1, RdData2, Oprand2, ReadData, WrtData: std_logic_vector(31 downto 0);
signal wrtEnable, Writemem, readmem, isload, isStore, Itype, JMP, Gobranch: std_logic;
signal WrtReg: std_logic_vector(4 downto 0);
signal branch, PCsel: std_logic_vector(1 downto 0);
signal ALUOP: std_logic_vector(2 downto 0);
type state is (loading, running, done);
signal s: state:= loading;
begin
	process(clk)
		begin

		if (clk'event and clk = '1') then
			case s is
				when loading =>
					s <= running; -- give 1 cycle to load the instructions into memory
				when running =>
					if NextAddress > LastInsAddress then
						s <= done; -- stop moving the pc after it has passed the last instruction
					end if;
				when others =>
					null;
			end case;
		end if;
	end process;
	InsMem: InstructionMem port map(
		ReadAddress => InstructionAddress,
		instruction => instruction,
		LastInsAddress => LastInsAddress,
		changecommit => changecommit,
		changeAddress => changeAddress,
		changeInstruction => changeInstruction,
		clk => clk
	);
	PCadder: adder port map(
		add1 => InstructionAddress,
		add2 =>	x"00000004",
		output => AddedPC
	);
	JumpAddress <= AddedPC(31 downto 28) & instruction(25 downto 0) &"00";
	add2 <= SignedImm(29 downto 0) & "00";
	BranchAdder: adder port map(
		add1 =>	AddedPC,
		add2 =>	add2,
		output =>	BranchAddress
	);
	
	PC1: PC port map(
		clk => clk,
		NextAddress => NextAddress,
		CurrentAddress => InstructionAddress,
		key_in => key_in,
		enc => enc,
		dec => dec,
		data_rdy => data_rdy,
		key_rdy => key_rdy
	);
	RegisterFile1: RegisterFile port map(
		clk => clk,
		WrtEnable => WrtEnable,
		RdReg1 => instruction(25 downto 21),
		RdReg2 => instruction(20 downto 16),
		WrtReg => WrtReg,
		WrtData => WrtData,
		RdData1 => RdData1,
		RdData2 => RdData2,
		reg => reg,
		enc => enc,
		dec => dec,
		key_in => key_in,
		AB =>AB
	);

	WrtRegMux: mux generic map(5) port map(
		x => instruction(20 downto 16), 
		y => instruction(15 downto 11), 
		s => Itype,
		z => WrtReg
	);
	Oprand2Mux: mux generic map(32) port map(
		x => SignedImm, 
		y => RdData2, 
		s => Itype,
		z => oprand2		
	);
	PCMUX1: PCMUX port map(
		a => AddedPC,
		b => BranchAddress,
		c => JumpAddress,
		sel => PCSel,
		NextAddress => NextAddress 
	);
	PCsel <= "01" when (gobranch = '1') else
				"10" when (JMP = '1') else
				"00" ;
	ALU_DataMem_MUX: mux generic map(32) port map(
		x => ReadData,
		y => ALUResult,
		s => isload,
		z => WrtData
	);
	SignExtend1: SignExtend port map(
		x => instruction(15 downto 0),
		y => SignedImm
	);
	
	DataMem1: DataMem port map(
		address => ALUResult,
		WriteData => RdData2,
		WriteMem => WriteMem,
		ReadMem => ReadMem,
		Clk => clk,
		ReadData	=> ReadData,	
		ukey => ukey,
		key_in => key_in,
		memdata => memdata
	);

	ALU1: ALU port map(		
		Oprand1 => RdData1,
		Oprand2 => oprand2,
		ALUOP => ALUOP,
		ALUResult => ALUResult
	);
	
	comparator1: comparator port map(
		branch => branch,
		comp1 => RdData1, 
		comp2 => RdData2,
		Gobranch => Gobranch
	);
	readMem <= isload;
	writeMem <= isstore;
	Decoder1: Decoder port map(
		instruction => instruction,
		wrtEnable => wrtEnable,
		isload => isload, 
		isStore => isStore, 
		Itype => Itype,
		JMP => JMP,
		branch => branch,
		ALUOP =>ALUOP
	);
end Behavioral;

