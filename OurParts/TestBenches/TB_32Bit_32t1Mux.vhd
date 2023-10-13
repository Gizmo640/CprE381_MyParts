library IEEE;
use IEEE.std_logic_1164.all;
use work.MyPackage.all;


entity TB_Bit32_32t1Mux is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_Bit32_32t1Mux;

architecture TB of TB_Bit32_32t1Mux is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	component Bit32_32t1Mux is
	port(
			Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
			Input_In: in STD_LOGIC_ARRAY(0 to 31);
			Output_Out: out STD_LOGIC_VECTOR(31 downto 0));
	end component;

	signal Input_In: STD_LOGIC_ARRAY(0 to 31);
	signal Output_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal Select_Signal: std_logic_vector(4 downto 0);

begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

	Bit32_32t1Mux1: Bit32_32t1Mux
		port map(
			Select_Signal,
			Input_In,
			Output_Out);

	TEST_CASES: process begin
		wait for HalfCycle_CLK/2;

		Input_In(0) <= x"0000_0000";
		Input_In(1) <= x"0000_0001";
		Input_In(2) <= x"0000_0002";
		Input_In(3) <= x"0000_0003";
		Input_In(4) <= x"0000_0004";
		Input_In(5) <= x"0000_0005";
		Input_In(6) <= x"0000_0006";
		Input_In(7) <= x"0000_0007";
		Input_In(8) <= x"0000_0008";
		Input_In(9) <= x"0000_0009";
		Input_In(10) <= x"0000_000a";
		Input_In(11) <= x"0000_000b";
		Input_In(12) <= x"0000_000c";
		Input_In(13) <= x"0000_000d";
		Input_In(14) <= x"0000_000e";
		Input_In(15) <= x"0000_000f";
		Input_In(16) <= x"0000_0010";
		Input_In(17) <= x"0000_0020";
		Input_In(18) <= x"0000_0030";
		Input_In(19) <= x"0000_0040";
		Input_In(20) <= x"0000_0050";
		Input_In(21) <= x"0000_0060";
		Input_In(22) <= x"0000_0070";
		Input_In(23) <= x"0000_0080";
		Input_In(24) <= x"0000_00a0";
		Input_In(25) <= x"0000_0090";
		Input_In(26) <= x"0000_00b0";
		Input_In(27) <= x"0000_00c0";
		Input_In(28) <= x"0000_00d0";
		Input_In(29) <= x"0000_00e0";
		Input_In(30) <= x"0000_00f0";
		Input_In(31) <= x"0000_0100";

		Select_Signal <= "00000";
		wait for CLK_Cycle;--20ns
		Select_Signal <= "00001";
		wait for CLK_Cycle;--20ns
		Select_Signal <= "00010";
		wait for CLK_Cycle;--20ns
		Select_Signal <= "00011";
		wait for CLK_Cycle;--20ns
		Select_Signal <= "00100";
		wait for CLK_Cycle;--20ns
		Select_Signal <= "11111";
		wait for CLK_Cycle;--20ns
	end process;
end TB;