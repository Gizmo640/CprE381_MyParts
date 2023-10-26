library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_ControlUnit is
	port(
		ALU_ControlUnit_In: in STD_LOGIC_VECTOR(3 downto 0);
		AddSubtract_Signal_Out: out STD_LOGIC; --bit 7
		LogicSelect_Signal_Out: out STD_LOGIC_VECTOR(1 downto 0); --bits 6-5
		InvertSelect_Signal_Out: out STD_LOGIC; --bit 4
		ArithmeticLogicSelect_Signal_Out: out STD_LOGIC; --bit 3
		Shift_RightLeft_Signal_Out: out STD_LOGIC; --bit 2
		ALUShifterSelect_Signal_Out: out STD_LOGIC; --bit 1
		Signed_Signal_Out: out STD_LOGIC); --bit 0
end ALU_ControlUnit;

architecture Design of ALU_ControlUnit is

	signal s_ControlBits: STD_LOGIC_VECTOR(7 downto 0);
begin
	with ALU_ControlUnit_In select
	s_ControlBits <=
		"00001001" when "0000", --add
		"00001000" when "0001", --addu
		"00100000" when "0010", --and
		"01000000" when "0011", --or
		"01010000" when "0100",	--nor
		"01100000" when "0101",	--xor
		"10000000" when "0110",	--slt
		"00000010" when "0111",	--sll
		"00000110" when "1000", --srl
		"00000111" when "1001", --sra
		"10001001" when "1010", --sub
		"10001000" when "1011",	--subu
		"00000010" when "1100",	--lui
		"11111111" when others;

	AddSubtract_Signal_Out <= s_ControlBits(7);
	LogicSelect_Signal_Out <= s_ControlBits(6 downto 5);
	InvertSelect_Signal_Out<= s_ControlBits(4);
	ArithmeticLogicSelect_Signal_Out <= s_ControlBits(3);
	Shift_RightLeft_Signal_Out <= s_ControlBits(2);
	ALUShifterSelect_Signal_Out <= s_ControlBits(1);
	Signed_Signal_Out <= s_ControlBits(0);
end Design;
