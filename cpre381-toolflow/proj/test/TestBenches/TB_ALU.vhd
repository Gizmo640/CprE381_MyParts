library IEEE;
use IEEE.std_logic_1164.all;

entity TB_NAME is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_NAME;

architecture TB of TB_NAME is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	constant N: INTEGER := 32;
begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

	TEST_CASES: process begin
		wait for HalfCycle_CLK/2;

		wait for CLK_Cycle;--20ns
	end process;
end TB;