library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_ControlUnit is
	port(
		ALU_ControlUnit_In: in STD_LOGIC_VECTOR(3 downto 0)
		AddSubtract_Signal_Out: out STD_LOGIC;
		LogicSelect_Signal_Out: out STD_LOGIC_VECTOR(1 downto 0);
		InvertSelect_Signal_Out: out STD_LOGIC;
		ArithmeticLogicSelect_Signal_Out: out STD_LOGIC;
		Shift_LeftRight_Signal_Out: out STD_LOGIC);
end ALU_ControlUnit;

architecture Design of ALU_ControlUnit is

	signal s_ControlBits: STD_LOGIC_VECTOR(5 downto 0);
begin
	with ALU_ControlUnit_In select
	s_ControlBits <=
		"000000" when "uuuu",
		"000000" when "uuuu",
		"000000" when "uuuu",
		"000000" when "uuuu",
		"000000" when "uuuu",
		"000000" when "uuuu",
		"000000" when "uuuu",
		"000000" when "uuuu",
		"000000" when "uuuu",
		"xxxxxx" when others;

	AddSubtract_Signal_Out <= s_ControlBits(5);
	LogicSelect_Signal_Out <= s_ControlBits(4 downto 3);
	InvertSelect_Signal_Out<= s_ControlBits(2);
	ArithmeticLogicSelect_Signal_Out <= s_ControlBits(1);
	Shift_LeftRight_Signal_Out <= s_ControlBits(0);
end Design;

--ALU input
--add = 0001
--and = 0010
--nor = 0011
--xor = 0100
--or = 0101
--slt = 0110
--sll = 0111
--srl = 1000
--sra = 1001
--sub = 1010
--lui = 1101
--lw/sw = 0000
--beq = 1011
--bne = 1100
--jumps = 1110