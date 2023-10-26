library IEEE;
use IEEE.std_logic_1164.all;

entity TB_Decoder_5t32 is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_Decoder_5t32;

architecture TB of TB_Decoder_5t32 is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	component Decoder_5t32 is
		port(
			Enable_Signal: in STD_LOGIC;
			Input_In: in std_logic_vector(4 downto 0);
			Output_Out: out std_logic_vector(31 downto 0));
	end component;

	signal Input_In : std_logic_vector(4 downto 0);
	signal Output_Out : std_logic_vector(31 downto 0);
	signal Enable_Signal: std_logic;
begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

	Decoder_5t321: Decoder_5t32
		port map(
			Enable_Signal,
			Input_In,
			Output_Out);

	TEST_CASES: process begin
		wait for HalfCycle_CLK/2;

		Enable_Signal <= '1';
		Input_In <= "00000";
		wait for CLK_Cycle;--20ns

		Enable_Signal <= '1';
		Input_In <= "00001";
		wait for CLK_Cycle;--20ns

		Enable_Signal <= '1';
		Input_In <= "00010";
		wait for CLK_Cycle;--20ns

		Enable_Signal <= '1';
		Input_In <= "00011";
		wait for CLK_Cycle;--20ns

		Enable_Signal <= '0';
		Input_In <= "00000";
		wait for CLK_Cycle;--20ns

		Enable_Signal <= '0';
		Input_In <= "11111";
		wait for CLK_Cycle;--20ns

		Enable_Signal <= '1';
		Input_In <= "11111";
		wait for CLK_Cycle;--20ns

		--expect 512
		Enable_Signal <= '1';
		Input_In <= "01001";
		wait for CLK_Cycle;--20ns
		
	end process;
end TB;
