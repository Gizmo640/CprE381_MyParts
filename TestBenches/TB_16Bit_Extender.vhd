library IEEE;
use IEEE.std_logic_1164.all;

entity TB_Extender_16Bit is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_Extender_16Bit;

architecture TB of TB_Extender_16Bit is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	component Extender_16Bit is
		port(
		Input_In: in STD_LOGIC_VECTOR(15 downto 0);
		ExtendedOutput_Out: out STD_LOGIC_VECTOR(31 downto 0);
		UnsignedSigned_Signal: in STD_LOGIC);
	end component;

	signal Immediate_In: STD_LOGIC_VECTOR(15 downto 0);
	signal ExtendedImmediate_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal Immediate_SignedUnsigned_Signal: STD_LOGIC;
begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

	Extender: Extender_16Bit
		port map(
			Immediate_In,
			ExtendedImmediate_Out,
			Immediate_SignedUnsigned_Signal);

	P_TEST_CASES: process begin
		wait for HalfCycle_CLK/2;

		Immediate_In <= x"FFFF";
		Immediate_SignedUnsigned_Signal <= '0';
		wait for CLK_Cycle; --20ns

		Immediate_In <= x"FFFF";
		Immediate_SignedUnsigned_Signal <= '1';
		wait for CLK_Cycle; --20ns
	end process;
end TB;