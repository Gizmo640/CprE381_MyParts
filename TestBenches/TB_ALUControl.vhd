library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_types.all;

entity TB_ALUControl is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_ALUControl;

architecture structure of TB_ALUControl is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	constant N: INTEGER := 32;

    component ALU_ControlUnit is
        port(
            ALU_ControlUnit_In: in STD_LOGIC_VECTOR(3 downto 0);
            AddSubtract_Signal_Out: out STD_LOGIC; --bit 0
            LogicSelect_Signal_Out: out STD_LOGIC_VECTOR(1 downto 0); --bits 1-2
            InvertSelect_Signal_Out: out STD_LOGIC; --bit 3
            ArithmeticLogicSelect_Signal_Out: out STD_LOGIC; --bit 4
            Shift_RightLeft_Signal_Out: out STD_LOGIC; --bit 5
            ALUShifterSelect_Signal_Out: out STD_LOGIC; --bit 6
            Signed_Signal_Out: out STD_LOGIC); --bit 7
    end component;

        signal s_ALU_ControlUnit_In: STD_LOGIC_VECTOR(3 downto 0);
        signal s_AddSubtract_Signal_Out: STD_LOGIC; --bit 0
        signal s_LogicSelect_Signal_Out: STD_LOGIC_VECTOR(1 downto 0); --bits 1-2
        signal s_InvertSelect_Signal_Out: STD_LOGIC; --bit 3
        signal s_ArithmeticLogicSelect_Signal_Out: STD_LOGIC; --bit 4
        signal s_Shift_RightLeft_Signal_Out: STD_LOGIC; --bit 5
        signal s_ALUShifterSelect_Signal_Out: STD_LOGIC; --bit 6
        signal s_Signed_Signal_Out: STD_LOGIC;

begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;


    DUT0: ALU_ControlUnit
        port map(
            ALU_ControlUnit_In => s_ALU_ControlUnit_In,
            AddSubtract_Signal_Out => s_AddSubtract_Signal_Out,
            LogicSelect_Signal_Out => s_LogicSelect_Signal_Out,
            InvertSelect_Signal_Out => s_InvertSelect_Signal_Out,
            ArithmeticLogicSelect_Signal_Out => s_ArithmeticLogicSelect_Signal_Out,
            Shift_RightLeft_Signal_Out => s_Shift_RightLeft_Signal_Out,
            ALUShifterSelect_Signal_Out => s_ALUShifterSelect_Signal_Out,
            Signed_Signal_Out => s_Signed_Signal_Out
        );


	TEST_CASES: process begin
		wait for HalfCycle_CLK/2;

        s_ALU_ControlUnit_In <= "0000";
        --00001001
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "0001";
        --00001000
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "0010";
        --00100000
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "0011";
        --01000000
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "0100";
        --01010000
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "0101";
        --01100000
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "0110";
        --00000000
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "0111";
        --00000010
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "1000";
        --00000110
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "1001";
        --00000111
		wait for CLK_Cycle;--20ns
        
        s_ALU_ControlUnit_In <= "1010";
        --10001001
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "1011";
        --10001000
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "1100";
        --00000010
		wait for CLK_Cycle;--20ns

        s_ALU_ControlUnit_In <= "1101";
        --expected out is 11111111
		wait for CLK_Cycle;--20ns

	end process;
end structure;