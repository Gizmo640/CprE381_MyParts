library IEEE;
use IEEE.std_logic_1164.all;

entity TB_DFF is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_DFF;

architecture TB of TB_DFF is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	component DFF is
		port(
			CLK_Signal: in STD_LOGIC;
			Reset_Signal: in STD_LOGIC;
			WriteEnable_Signal: in STD_LOGIC;
			InputD_In: in STD_LOGIC;
			OutputQ_Out: out STD_LOGIC);
	end component;

	signal Reset_Signal, WriteEnable_Signal: STD_LOGIC;
	signal InputD_In, OutputQ_Out: STD_LOGIC
begin
Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

	DFF1: DFF
		port map(
			CLK,
			Reset_Signal,
			WriteEnable_Signal,
			InputD_In,
			OutputQ_Out);

	TEST_CASES: process begin
		Reset_Signal <= '1';
		WriteEnable_Signal <= '0';
		InputD_In <= '0';
		wait for CLK_Cycle;

		Reset_Signal <= '0';
		WriteEnable_Signal <= '1';
		InputD_In <= '1';
		wait for CLK_Cycle;

		Reset_Signal <= '0';
		WriteEnable_Signal <= '0';
		InputD_In <= '0';
		wait for CLK_Cycle;

		Reset_Signal <= '0';
		WriteEnable_Signal <= '1';
		InputD_In <= '0';
		wait for CLK_Cycle;

		Reset_Signal <= '0';
		WriteEnable_Signal <= '0';
		InputD_In <= '1';
		wait for CLK_Cycle;

		wait;
  end process;
end TB;
