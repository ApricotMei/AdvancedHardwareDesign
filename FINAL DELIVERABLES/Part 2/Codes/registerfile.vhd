----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nie13
-- 
-- Create Date: 11/13/2017 12:57:04 PM
-- Design Name: 
-- Module Name: registerfile - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registerfile is
  Port ( CLK: in std_logic;
        Instr: in std_logic_vector (31 downto 0);
        WD3: in std_logic_vector (31 downto 0);
        SrcA: out std_logic_vector (31 downto 0);
        SrcB: out std_logic_vector (31 downto 0);
        WriteData: out std_logic_vector (31 downto 0);
        RegWrite: in std_logic;
        RegDst: in std_logic;
        ALUSrc: in std_logic;
        PCPlus4: in std_logic_vector (31 downto 0);
        PCBranch: out std_logic_vector (31 downto 0)                
        );
end registerfile;

architecture Behavioral of registerfile is
    type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
    signal registers : registerFile := (x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000");
    signal selA1: std_logic_vector(4 downto 0);
    signal selA2: std_logic_vector(4 downto 0);
    signal selA3: std_logic_vector(4 downto 0);
    signal RD1: std_logic_vector (31 downto 0);
    signal RD2: std_logic_vector (31 downto 0);
    signal SignImm: std_logic_vector (31 downto 0);
    signal SignImm2: std_logic_vector (31 downto 0);
begin

selA1 <= Instr(25 downto 21);
selA2 <= Instr(20 downto 16);
SrcA <= RD1;
WriteData <= RD2;
SignImm <= x"0000" & Instr(15 downto 0);
SignImm2 <= SignImm(29 downto 0) & SignImm (1 downto 0);


--with RegDst select
--    selA3 <= Instr(20 downto 16) when '0',
--            Instr(15 downto 11) when others;
            
            
--with ALUSrc select
--    SrcB <= RD2 when '0',
--            SignImm when others;            

PCBranch <= SignImm2 + PCPlus4;

      
REGFILE: process(CLK)
begin
    if (CLK'event and CLK = '1') then
        RD1 <= registers(CONV_INTEGER(selA1));
        RD2 <= registers(CONV_INTEGER(selA2));
        
        if (RegWrite = '1') then
            if (RegDst = '0') then 
            registers(CONV_INTEGER(Instr(20 downto 16))) <= WD3 (31 downto 0);
            elsif(RegDst = '1') then
            registers(CONV_INTEGER(Instr(15 downto 11))) <= WD3 (31 downto 0);
            end if;    
        end if;
        
        if (ALUSrc = '0') then
            SrcB <= registers(CONV_INTEGER(selA2));
        elsif (ALUSrc = '1') then
            SrcB <= x"0000" & Instr(15 downto 0);
        end if;
        
    end if; 
end process;

--GETDST: process(RegDst, Instr)
--begin
--    case RegDst is
--        when '0'=> selA3 <= Instr(20 downto 16);
--        when '1'=> selA3 <= Instr(15 downto 11);
--    end case;
--end process;

--GETSRCB: process(RD2, SignImm, ALUSrc)
--begin
--    case ALUSrc is
--        when '0'=> SrcB <= RD2;
--        when '1'=> SrcB <= SignImm;
--    end case;    
--end process;

--GETPCBRANCH: process(SignImm2, PCPlus4)
--begin
--    PCBranch <= SignImm2 + PCPlus4;    
--end process;

end Behavioral;
