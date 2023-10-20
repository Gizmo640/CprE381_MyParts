library IEEE;
use IEEE.std_logic_1164.all;

entity TB_RegisterFile is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_RegisterFile;

architecture TB of TB_RegisterFile is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	component RegisterFile
		port(
			Data_In: in STD_LOGIC_VECTOR(31 downto 0);
			DataA_Out: out STD_LOGIC_VECTOR(31 downto 0);
			DataB_Out: out STD_LOGIC_VECTOR(31 downto 0);
			RegisterWriteSelect_Signal: in STD_LOGIC_VECTOR(4 downto 0);
			DataA_Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
			DataB_Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
			Reset_Signal: in STD_LOGIC;
			WriteEnable_Signal: in STD_LOGIC;
			CLK_Signal: in STD_LOGIC);
	end component;

	signal Data_In: std_logic_vector(31 downto 0);
	signal DataA_Out, DataB_Out: std_logic_vector(31 downto 0);
	signal RegisterWriteSelect_Signal: std_logic_vector (4 downto 0);
	signal DataA_Select_Signal, DataB_Select_Signal: std_logic_vector (4 downto 0);
	signal Reset_Signal, WriteEnable_Signal: std_logic;

begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

	RegisterFile1: RegisterFile
		port map(
			Data_In,
			DataA_Out, DataB_Out,
			RegisterWriteSelect_Signal,
			DataA_Select_Signal, DataB_Select_Signal,
			Reset_Signal, WriteEnable_Signal, CLK);

	TEST_CASES: process begin
		wait for HalfCycle_CLK/2;
		--test 1
		Reset_Signal <= '1';
		wait for CLK_Cycle;--20ns
		Reset_Signal <= '0';
		wait for CLK_Cycle;--20ns
		--test 2
		WriteEnable_Signal <= '1';
		RegisterWriteSelect_Signal <= "00001";
		Data_In <= x"FFFF_FFFF";
		DataA_Select_Signal <= "00001";
		DataB_Select_Signal <= "00001";
		wait for CLK_Cycle;--20ns
		--test 3
		WriteEnable_Signal <= '1';
		RegisterWriteSelect_Signal <= "00110";
		Data_In <= x"FFFF_0000";
		DataA_Select_Signal <= "00001";
		DataB_Select_Signal <= "00110";
		wait for CLK_Cycle;--20ns
		--test 4
		WriteEnable_Signal <= '1';
		RegisterWriteSelect_Signal <= "00010";
		Data_In <= x"0000_1111";
		DataA_Select_Signal <= "00010";
		DataB_Select_Signal <= "00110";
		wait for CLK_Cycle;--20ns
		--test 5
		WriteEnable_Signal <= '0';
		RegisterWriteSelect_Signal <= "00010";
		Data_In <= x"0000_1111";
		DataA_Select_Signal <= "00010";
		DataB_Select_Signal <= "00010";
		wait for CLK_Cycle;--20ns

		WriteEnable_Signal <= '0';
		RegisterWriteSelect_Signal <= "00010";
		Data_In <= x"AAAA_0000";
		DataA_Select_Signal <= "00010";
		DataB_Select_Signal <= "00010";
		wait for CLK_Cycle;--20ns
	end process;
end TB;