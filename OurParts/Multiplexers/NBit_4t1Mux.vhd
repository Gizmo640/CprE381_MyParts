library IEEE;
use IEEE.std_logic_1164.all;

entity NBit_4t1Mux is
	generic(N: INTEGER);
	port(
		InputSelect_Signal: in STD_LOGIC_VECTOR(1 downto 0);
		InputA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		InputB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		InputC_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		InputD_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0));
end NBit_4t1Mux;

architecture Design of NBit_4t1Mux is
begin
	Output_Out <=
		InputA_In when InputSelect_Signal = "00" else
		InputB_In when InputSelect_Signal = "01" else
		InputC_In when InputSelect_Signal = "10" else
		InputD_In when InputSelect_Signal = "11" else
		(N-1 downto 0 => '0');
end Design;