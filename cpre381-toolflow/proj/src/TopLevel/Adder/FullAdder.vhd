library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
	port(
		Carry_In: in STD_LOGIC;
		Carry_Out: out STD_LOGIC;
		BitA_In: in STD_LOGIC;
		BitB_In: in STD_LOGIC;
		Bit_Out: out STD_LOGIC);
end FullAdder;

architecture Design of FullAdder is

	signal sP1_CarryBit, sP2_CarryBit: STD_LOGIC;
	signal sP1_BitsSum: STD_LOGIC;

begin
	sP1_BitsSum <= BitA_In xor BitB_In;
	sP1_CarryBit <= BitA_In and BitB_In;

	Bit_Out <= sP1_BitsSum xor Carry_In;
	sP2_CarryBit <= sP1_BitsSum and Carry_In;

	Carry_Out <= sP1_CarryBit or sP2_CarryBit;
end Design;
