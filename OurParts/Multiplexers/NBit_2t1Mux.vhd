library IEEE;
use IEEE.std_logic_1164.all;

entity NBit_2t1Mux is
	generic(N: INTEGER);
	port(
		InputSelect_Signal: in STD_LOGIC;
		InputA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		InputB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0));
end NBit_2t1Mux;

architecture Design of NBit_2t1Mux is
begin
	Output_Out <=
		InputA_In when InputSelect_Signal = '0' else
		InputB_In when InputSelect_Signal = '1' else
		(N-1 downto 0 => '0');
end Design;