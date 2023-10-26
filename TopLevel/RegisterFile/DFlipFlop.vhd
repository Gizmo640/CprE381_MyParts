library IEEE;
use IEEE.std_logic_1164.all;

entity DFF is
	port(
		CLK_Signal: in STD_LOGIC;
		Reset_Signal: in STD_LOGIC;
		WriteEnable_Signal: in STD_LOGIC;
		InputD_In: in STD_LOGIC;
		OutputQ_Out: out STD_LOGIC);
end DFF;

architecture Design of DFF is

	signal s_InputD: STD_LOGIC;
	signal s_OutputQ: STD_LOGIC;
begin

	with WriteEnable_Signal select
		s_InputD <=
			InputD_In when '1',
			s_OutputQ when others;

	process (CLK_Signal, Reset_Signal) begin
		if (Reset_Signal = '1') then
			s_OutputQ <= '0'; 
		elsif (rising_edge(CLK_Signal)) then
			s_OutputQ <= s_InputD;
		end if;
	end process;

	OutputQ_Out <= s_OutputQ;
end Design;
