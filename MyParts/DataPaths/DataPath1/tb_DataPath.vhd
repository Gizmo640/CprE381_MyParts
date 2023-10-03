library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.textio.all;

entity TB_DataPate is
    generic(gCLK_HPER   : time := 10 ns);
end TB_DataPate;
--
architecture TB of TB_DataPate is
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component DataPate
        port(Immediate: in std_logic_vector(31 downto 0);
            WriteReg_Sel, Do0_Sel,Do1_Sel: in std_logic_vector(4 downto 0);
            Reset, Write_Enable, ALUSel, AddSub_Sel, CLK: in std_logic);
	end component;

    signal Immediate: std_logic_vector(31 downto 0);
    signal WriteReg_Sel, Do0_Sel,Do1_Sel: std_logic_vector (4 downto 0);
    signal Reset, Write_Enable, ALUSel, AddSub_Sel: std_logic;


	signal CLK: std_logic;

begin
    P_CLK: process
        begin
            CLK <= '0';
            wait for gCLK_HPER;
            CLK <= '1';
            wait for gCLK_HPER;
    end process;

	DataPate1: DataPate 
		port map(Immediate, WriteReg_Sel, Do0_Sel,Do1_Sel, 
                Reset, Write_Enable, ALUSel, AddSub_Sel, CLK);

	P_TEST_CASES: process begin
        wait for gCLK_HPER/2;

        Reset <= '1';
        wait for cCLK_PER; -- 20ns
        Reset <= '0';

---------------------------------------------------------------------
        Immediate <= x"0000_0001";

        WriteReg_Sel <= "00001";
        Do0_Sel <= "00000";
        Do1_Sel <= "00000";

        Write_Enable <= '1';
        ALUSel <= '1';
        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0002";
        WriteReg_Sel <= "00010";
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0003";
        WriteReg_Sel <= "00011";
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0004";
        WriteReg_Sel <= "00100";
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0005";
        WriteReg_Sel <= "00101";
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0006";
        WriteReg_Sel <= "00110";
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0007";
        WriteReg_Sel <= "00111";
		wait for cCLK_PER; -- 20ns\

        Immediate <= x"0000_0008";
        WriteReg_Sel <= "01000";
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0009";
        WriteReg_Sel <= "01001";
		wait for cCLK_PER; -- 20ns
        
        Immediate <= x"0000_000a";
        WriteReg_Sel <= "01010";
		wait for cCLK_PER; -- 20ns
---------------------------------------------------------------------

        Immediate <= x"0000_0000";

        WriteReg_Sel <= "01011";
        Do0_Sel <= "00001";
        Do1_Sel <= "00010";

        ALUSel <= '0';
        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "01100";
        Do0_Sel <= "01011";
        Do1_Sel <= "00011";

        AddSub_Sel <= '1';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "01101";
        Do0_Sel <= "01100";
        Do1_Sel <= "00100";

        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "01110";
        Do0_Sel <= "01101";
        Do1_Sel <= "00101";

        AddSub_Sel <= '1';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "01111";
        Do0_Sel <= "01110";
        Do1_Sel <= "00111";

        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "10000";
        Do0_Sel <= "01111";
        Do1_Sel <= "00111";

        AddSub_Sel <= '1';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "10001";
        Do0_Sel <= "10000";
        Do1_Sel <= "01000";

        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "10010";
        Do0_Sel <= "10001";
        Do1_Sel <= "01001";

        AddSub_Sel <= '1';
		wait for cCLK_PER; -- 20ns

        WriteReg_Sel <= "10011";
        Do0_Sel <= "10010";
        Do1_Sel <= "01010";

        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

        Immediate <= x"FFFF_FFDD";

        WriteReg_Sel <= "10100";
        Do0_Sel <= "00000";
        Do1_Sel <= "00000";

        ALUSel <= '1';
        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

        Immediate <= x"0000_0000";

        WriteReg_Sel <= "10101";
        Do0_Sel <= "10011";
        Do1_Sel <= "10100";

        ALUSel <= '0';
        AddSub_Sel <= '0';
		wait for cCLK_PER; -- 20ns

	end process;
end TB;
--