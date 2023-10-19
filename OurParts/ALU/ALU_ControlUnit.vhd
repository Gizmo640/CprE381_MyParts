library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_ControlUnit is
	port(
		ALU_ControlUnit_In: in STD_LOGIC_VECTOR(5 downto 0)
		AddSubtract_Signal_Out: out STD_LOGIC;
		LogicSelect_Signal_Out: out STD_LOGIC_VECTOR(1 downto 0);
		InvertSelect_Signal_Out: out STD_LOGIC;
		ArithmeticLogicSelect_Signal_Out: out STD_LOGIC;
		Shift_LeftRight_Signal_Out: out STD_LOGIC;
		ALUShifterSelect_Signal_Out: out STD_LOGIC;
		Signed_Signal_Out: out STD_LOGIC);
end ALU_ControlUnit;

architecture Design of ALU_ControlUnit is

	signal s_ControlBits: STD_LOGIC_VECTOR(7 downto 0);
begin
	with ALU_ControlUnit_In select
	s_ControlBits <=
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"xxxxxxxx" when "uuuuu",
		"000000" when others;

	AddSubtract_Signal_Out <= s_ControlBits(7);
	LogicSelect_Signal_Out <= s_ControlBits(6 downto 5);
	InvertSelect_Signal_Out<= s_ControlBits(4);
	ArithmeticLogicSelect_Signal_Out <= s_ControlBits(3);
	Shift_LeftRight_Signal_Out <= s_ControlBits(2);
	ALUShifterSelect_Signal_Out <= s_ControlBits(1);
	Signed_Signal_Out <= s_ControlBits(0);
end Design;
