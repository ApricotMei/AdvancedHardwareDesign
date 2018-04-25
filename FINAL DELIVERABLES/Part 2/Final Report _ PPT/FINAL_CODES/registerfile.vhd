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
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.final.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registerfile is
  Port ( clk: in std_logic;
         WrtEnable: in std_logic;
         reg: out mem_array;
         enc, dec, key_in: in std_logic;
         AB : in std_logic_vector(63 downto 0);        
         RdReg1, RdReg2, WrtReg: in std_logic_vector(4 downto 0);
         WrtData: in std_logic_vector(31 downto 0);
         RdData1, RdData2: out std_logic_vector(31 downto 0)          
        );
end registerfile;

architecture Behavioral of registerfile is
    -- 128 byte register memory (32 rows * 4 bytes/row)
    signal reg_mem: mem_array := (
     "00000000000000000000000000000000", -- $zero
     "00000000000000000000000000000000", -- mem 1
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000", -- test add
     "00000000000000000000000000000000", -- test add
     "00000000000000000000000000000000", -- mem 10 
     "00000000000000000000000000000000", 
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",  
     "00000000000000000000000000000000", -- mem 20
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000", 
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000",
     "00000000000000000000000000000000", 
     "00000000000000000000000000000000", -- mem 30
     "00000000000000000000000000000000"
    );
begin

--selA1 <= TO_INTEGER(unsigned(Instr(25 downto 21)));
--selA1 <= 1;
--selA2 <= TO_INTEGER(unsigned(Instr(20 downto 16)));
--selA3 <= TO_INTEGER(unsigned(Instr(15 downto 11)));

reg <= reg_mem;
RdData1 <= reg_mem(conv_integer(RdReg1));
RdData2 <= reg_mem(conv_integer(RdReg2));

process(clk, enc, dec)
begin
if(enc = '1' or dec = '1') then 
reg_mem(1) <= AB(63 downto 32);
reg_mem(2) <= AB(31 downto 0); 
reg_mem(3) <= x"00000000";
reg_mem(4) <= x"00000000";
reg_mem(5) <= x"00000000";
reg_mem(6) <= x"00000000";
reg_mem(7) <= x"00000000";
reg_mem(8) <= x"00000000";
reg_mem(9) <= x"00000000";
reg_mem(10) <= x"00000000";
reg_mem(12) <= x"00000000";
reg_mem(13) <= x"00000000";
reg_mem(14) <= x"00000000";
reg_mem(15) <= x"00000000";
reg_mem(16) <= x"00000000";
reg_mem(17) <= x"00000000";
reg_mem(18) <= x"00000000";
reg_mem(19) <= x"00000000";
reg_mem(20) <= x"00000000";
reg_mem(21) <= x"00000000";
reg_mem(22) <= x"00000000";
reg_mem(23) <= x"00000000";
reg_mem(24) <= x"00000000";
reg_mem(25) <= x"00000000";
reg_mem(26) <= x"00000000";
reg_mem(27) <= x"00000000";
reg_mem(28) <= x"00000000";
reg_mem(29) <= x"00000000";
reg_mem(30) <= x"00000000";
reg_mem(31) <= x"00000000";
elsif(key_in = '1') then
reg_mem <= (others => x"00000000");
elsif (clk'event and clk = '1' ) then
if(WrtEnable = '1') then
	reg_mem(conv_integer(WrtReg)) <= WrtData;
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
