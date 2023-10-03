library IEEE;
use IEEE.std_logic_1164.all;

entity TB_NBit_Register is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_NBit_Register;

architecture TB of TB_NBit_Register is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	constant N: INTEGER := 32;

	component NBit_Register
		generic(N: INTEGER);
		port(
			Input_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
			Reset_Signal: in STD_LOGIC;
			WriteEnable_Signal: in STD_LOGIC;
			CLK_Signal: in STD_LOGIC);
	end component;

	signal Input_In, Output_Out : std_logic_vector(31 downto 0);
	signal Reset_Signal, WriteEnable_Signal: std_logic;

begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

	NBit_Register1: NBit_Register 
		generic map (N)
		port map(
			Input_In,
			Output_Out,
			Reset_Signal,
			WriteEnable_Signal,
			CLK);

	TEST_CASES: process begin
		wait for HalfCycle_CLK/2;

		Reset_Signal <= '1';
		WriteEnable_Signal <= '0';
		Input_In <= x"0000_0000";
		wait for CLK_Cycle;--20ns

		Reset_Signal <= '0';
		WriteEnable_Signal <= '0';
		Input_In <= x"ffff_ffff";
		wait for CLK_Cycle;--20ns

		Reset_Signal <= '0';
		WriteEnable_Signal <= '1';
		Input_In <= x"ffff_ffff";
		wait for CLK_Cycle;--20ns

		Reset_Signal <= '1';
		WriteEnable_Signal <= '0';
		Input_In <= x"ffff_ffff";
		wait for CLK_Cycle;--20ns

		Reset_Signal <= '0';
		WriteEnable_Signal <= '0';
		Input_In <= x"0000_0000";
		wait for CLK_Cycle;--20ns
	end process;
end TB;
--