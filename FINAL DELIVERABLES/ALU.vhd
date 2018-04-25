----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:47:26 12/03/2016 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
USE WORK.PROCESSOR_PKG.ALL; 
use ieee.std_logic_textio.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
   PORT
   (	
--      clr		: IN     STD_LOGIC;
--		clk		: IN		STD_LOGiC;
		IsItype	: IN		STD_LOGIC;
		IsRtype	: IN		STD_LOGIC;
		IsJtype	: IN		STD_LOGIC;
		Opcode	: IN		STD_LOGIC_VECTOR (5 downto 0);
		RD1		: IN		STD_LOGIC_VECTOR (31 downto 0);
		RD2		: IN		STD_LOGIC_VECTOR (31 downto 0);
		Funct		: IN		STD_LOGIC_VECTOR (5 downto 0);
		Imm		: IN		STD_LOGIC_VECTOR (15 downto 0);
--		datamemory_in: IN	DATAMEM;
		new_PC   : OUT		STD_LOGIC;
		IsBranch : OUT		STD_LOGIC;
		IsJump	: OUT		STD_LOGIC;
		IsHal		: OUT		STD_LOGIC;
		wrt_enable:OUT		STD_LOGIC;
		wrt_data	: OUT		STD_LOGIC_VECTOR (31 downto 0);
--		datamemory_out: OUT	DATAMEM;
		
		
		Address_mem:			OUT	STD_LOGIC_VECTOR (31 downto 0);
		datamemory_data_out: OUT	STD_LOGIC_VECTOR (31 downto 0);
		datamemory_data_in: 	IN 	STD_LOGIC_VECTOR (31 downto 0)
   );
end ALU;

architecture Behavioral of ALU is

--		signal datamemory : DATAMEM;

begin

PROCESS(IsItype, IsRtype, IsJtype, Opcode, RD1, RD2, Funct, Imm,datamemory_data_in)

begin
		if (IsRtype = '1') THEN
		wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
			if (Funct="010000") THEN wrt_data<=RD1 + RD2;
			elsif (Funct="010001") THEN wrt_data<=RD1 - RD2;
			elsif (Funct="010010") THEN wrt_data<=RD1 and RD2;
			elsif (Funct="010011") THEN wrt_data<=RD1 or RD2;
			elsif (Funct="010100") THEN wrt_data<=not (RD1 or RD2);
			END IF;
		elsif (IsItype = '1') THEN
			if (Opcode = "000001") THEN 
			wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
			wrt_data<=RD1 + (Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm);
			elsif (Opcode = "000010") THEN 
			wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
			wrt_data<=RD1 - (Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm);
			elsif (Opcode = "000011") THEN 
			wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
			wrt_data<=RD1 and (Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm);
			elsif (Opcode = "000100") THEN 
			wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
			wrt_data<=RD1 or (Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm);
			elsif (Opcode = "000101") THEN 
			wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
			case Imm(4 DOWNTO 0) is
			WHEN "00001" => wrt_data <= RD1(30 DOWNTO 0) & RD1(31);--1
			WHEN "00010" => wrt_data <= RD1(29 DOWNTO 0) & RD1(31 DOWNTO 30) ;--2
			WHEN "00011" => wrt_data <= RD1(28 DOWNTO 0) & RD1(31 DOWNTO 29) ;--3
			WHEN "00100" => wrt_data <= RD1(27 DOWNTO 0) & RD1(31 DOWNTO 28) ;--4
			WHEN "00101" => wrt_data <= RD1(26 DOWNTO 0) & RD1(31 DOWNTO 27) ;--5
			WHEN "00110" => wrt_data <= RD1(25 DOWNTO 0) & RD1(31 DOWNTO 26) ;--6
			WHEN "00111" => wrt_data <= RD1(24 DOWNTO 0) & RD1(31 DOWNTO 25) ;--7
			WHEN "01000" => wrt_data <= RD1(23 DOWNTO 0) & RD1(31 DOWNTO 24) ;--8
			WHEN "01001" => wrt_data <= RD1(22 DOWNTO 0) & RD1(31 DOWNTO 23) ;--9
			WHEN "01010" => wrt_data <= RD1(21 DOWNTO 0) & RD1(31 DOWNTO 22) ;--10
			WHEN "01011" => wrt_data <= RD1(20 DOWNTO 0) & RD1(31 DOWNTO 21) ;--11
			WHEN "01100" => wrt_data <= RD1(19 DOWNTO 0) & RD1(31 DOWNTO 20) ;--12
			WHEN "01101" => wrt_data <= RD1(18 DOWNTO 0) & RD1(31 DOWNTO 19) ;--13
			WHEN "01110" => wrt_data <= RD1(17 DOWNTO 0) & RD1(31 DOWNTO 18) ;--14
			WHEN "01111" => wrt_data <= RD1(16 DOWNTO 0) & RD1(31 DOWNTO 17) ;--15
			WHEN "10000" => wrt_data <= RD1(15 DOWNTO 0) & RD1(31 DOWNTO 16) ;--16
			WHEN "10001" => wrt_data <= RD1(14 DOWNTO 0) & RD1(31 DOWNTO 15) ;--17
			WHEN "10010" => wrt_data <= RD1(13 DOWNTO 0) & RD1(31 DOWNTO 14) ;--18
			WHEN "10011" => wrt_data <= RD1(12 DOWNTO 0) & RD1(31 DOWNTO 13) ;--19
			WHEN "10100" => wrt_data <= RD1(11 DOWNTO 0) & RD1(31 DOWNTO 12) ;--20
			WHEN "10101" => wrt_data <= RD1(10 DOWNTO 0) & RD1(31 DOWNTO 11) ;--21
			WHEN "10110" => wrt_data <= RD1(9 DOWNTO 0) & RD1(31 DOWNTO 10) ;--22
			WHEN "10111" => wrt_data <= RD1(8 DOWNTO 0) & RD1(31 DOWNTO 9) ;--23
			WHEN "11000" => wrt_data <= RD1(7 DOWNTO 0) & RD1(31 DOWNTO 8) ;--24
			WHEN "11001" => wrt_data <= RD1(6 DOWNTO 0) & RD1(31 DOWNTO 7) ;--25
			WHEN "11010" => wrt_data <= RD1(5 DOWNTO 0) & RD1(31 DOWNTO 6) ;--26
			WHEN "11011" => wrt_data <= RD1(4 DOWNTO 0) & RD1(31 DOWNTO 5) ;--27
			WHEN "11100" => wrt_data <= RD1(3 DOWNTO 0) & RD1(31 DOWNTO 4) ;--28
			WHEN "11101" => wrt_data <= RD1(2 DOWNTO 0) & RD1(31 DOWNTO 3) ;--29
			WHEN "11110" => wrt_data <= RD1(1 DOWNTO 0) & RD1(31 DOWNTO 2) ;--30
			WHEN "11111" => wrt_data <= RD1(0) & RD1(31 DOWNTO 1) ;--31
			WHEN OTHERS => wrt_data <= RD1 ;--0
			end case;
			elsif (Opcode = "000110") THEN
			wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
			case Imm(4 DOWNTO 0) is
			WHEN "00001" => wrt_data <= RD1(0) & RD1(31 DOWNTO 1);--1
			WHEN "00010" => wrt_data <= RD1(1 DOWNTO 0) & RD1(31 DOWNTO 2) ;--2
			WHEN "00011" => wrt_data <= RD1(2 DOWNTO 0) & RD1(31 DOWNTO 3) ;--3
			WHEN "00100" => wrt_data <= RD1(3 DOWNTO 0) & RD1(31 DOWNTO 4) ;--4
			WHEN "00101" => wrt_data <= RD1(4 DOWNTO 0) & RD1(31 DOWNTO 5) ;--5
			WHEN "00110" => wrt_data <= RD1(5 DOWNTO 0) & RD1(31 DOWNTO 6) ;--6
			WHEN "00111" => wrt_data <= RD1(6 DOWNTO 0) & RD1(31 DOWNTO 7) ;--7
			WHEN "01000" => wrt_data <= RD1(7 DOWNTO 0) & RD1(31 DOWNTO 8) ;--8
			WHEN "01001" => wrt_data <= RD1(8 DOWNTO 0) & RD1(31 DOWNTO 9) ;--9
			WHEN "01010" => wrt_data <= RD1(9 DOWNTO 0) & RD1(31 DOWNTO 10) ;--10
			WHEN "01011" => wrt_data <= RD1(10 DOWNTO 0) & RD1(31 DOWNTO 11) ;--11
			WHEN "01100" => wrt_data <= RD1(11 DOWNTO 0) & RD1(31 DOWNTO 12) ;--12
			WHEN "01101" => wrt_data <= RD1(12 DOWNTO 0) & RD1(31 DOWNTO 13) ;--13
			WHEN "01110" => wrt_data <= RD1(13 DOWNTO 0) & RD1(31 DOWNTO 14) ;--14
			WHEN "01111" => wrt_data <= RD1(14 DOWNTO 0) & RD1(31 DOWNTO 15) ;--15
			WHEN "10000" => wrt_data <= RD1(15 DOWNTO 0) & RD1(31 DOWNTO 16) ;--16
			WHEN "10001" => wrt_data <= RD1(16 DOWNTO 0) & RD1(31 DOWNTO 17) ;--17
			WHEN "10010" => wrt_data <= RD1(17 DOWNTO 0) & RD1(31 DOWNTO 18) ;--18
			WHEN "10011" => wrt_data <= RD1(18 DOWNTO 0) & RD1(31 DOWNTO 19) ;--19
			WHEN "10100" => wrt_data <= RD1(19 DOWNTO 0) & RD1(31 DOWNTO 20) ;--20
			WHEN "10101" => wrt_data <= RD1(20 DOWNTO 0) & RD1(31 DOWNTO 21) ;--21
			WHEN "10110" => wrt_data <= RD1(21 DOWNTO 0) & RD1(31 DOWNTO 22) ;--22
			WHEN "10111" => wrt_data <= RD1(22 DOWNTO 0) & RD1(31 DOWNTO 23) ;--23
			WHEN "11000" => wrt_data <= RD1(23 DOWNTO 0) & RD1(31 DOWNTO 24) ;--24
			WHEN "11001" => wrt_data <= RD1(24 DOWNTO 0) & RD1(31 DOWNTO 25) ;--25
			WHEN "11010" => wrt_data <= RD1(25 DOWNTO 0) & RD1(31 DOWNTO 26) ;--26
			WHEN "11011" => wrt_data <= RD1(26 DOWNTO 0) & RD1(31 DOWNTO 27) ;--27
			WHEN "11100" => wrt_data <= RD1(27 DOWNTO 0) & RD1(31 DOWNTO 28) ;--28
			WHEN "11101" => wrt_data <= RD1(28 DOWNTO 0) & RD1(31 DOWNTO 29) ;--29
			WHEN "11110" => wrt_data <= RD1(29 DOWNTO 0) & RD1(31 DOWNTO 30) ;--30
			WHEN "11111" => wrt_data <= RD1(30 DOWNTO 0) & RD1(31) ;--31
			WHEN OTHERS => wrt_data <= RD1 ;
			end case;
			elsif (Opcode = "000111") THEN
				wrt_enable<='1'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';
				Address_mem<=RD1 + (Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm);
				wrt_data<= datamemory_data_in;
			elsif (Opcode = "001000") THEN
				wrt_enable<='0'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';wrt_data<=(OTHERS=>'0');
				address_mem<=RD1 + (Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm(15)&Imm);
				datamemory_data_out<=RD2;			
			elsif (Opcode = "001001") THEN
				wrt_enable<='0';IsJump<='0';IsHal<='0';
				if (RD1 < RD2) THEN new_PC <= '1'; IsBranch <= '1';
				else new_PC <= '0'; IsBranch <= '0';
				end if;
			elsif (Opcode = "001010") THEN
				wrt_enable<='0';IsJump<='0';IsHal<='0';
				if (RD1 = RD2) THEN new_PC <= '1'; IsBranch <= '1';
				else new_PC <= '0'; IsBranch <= '0';
				end if;				
			elsif (Opcode = "001011") THEN
				wrt_enable<='0';IsJump<='0';IsHal<='0';
				if (RD1 /= RD2) THEN new_PC <= '1'; IsBranch <= '1';
				else new_PC <= '0'; IsBranch <= '0';
				end if;
			end if;
		ELSIF (IsJtype = '1') THEN
			if (Opcode = "001100") THEN new_PC <= '1'; IsJump <= '1'; wrt_enable<='0'; IsBranch<='0';IsHal<='0';
			elsif (Opcode = "111111") THEN new_PC <= '1'; IsHal <= '1'; wrt_enable<='0'; IsBranch<='0';IsJump<='0';
			end if;
		else 
			wrt_enable<='0'; new_PC<='0';IsBranch<='0';IsJump<='0';IsHal<='0';wrt_data<=(OTHERS=>'0');
		END IF;
end process;
end Behavioral;

