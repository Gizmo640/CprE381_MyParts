library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_ControlUnit is
	port(
		-- ALU_ControlUnit_In: in STD_LOGIC_VECTOR(3 downto 0)
		-- AddSubtract_Signal_Out: out STD_LOGIC;
		-- LogicSelect_Signal_Out: out STD_LOGIC_VECTOR(1 downto 0);
		-- InvertSelect_Signal_Out: out STD_LOGIC;
		-- ArithmeticLogicSelect_Signal_Out: out STD_LOGIC;
		--Shift_LeftRight_Signal_Out: out STD_LOGIC
		ALUOp: in std_logic_vector(3 downto 0);
		Funct: in std_logic_vector(5 downto 0);
		ALUControl: out std_logic_vector(3 downto 0)
		);
end ALU_ControlUnit;

architecture Design of ALU_ControlUnit is

-- 	signal s_ControlBits: STD_LOGIC_VECTOR(5 downto 0);
-- begin
-- 	with ALU_ControlUnit_In select
-- 	s_ControlBits <=
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"000000" when "uuuu",
-- 		"xxxxxx" when others;

-- 	AddSubtract_Signal_Out <= s_ControlBits(5);
-- 	LogicSelect_Signal_Out <= s_ControlBits(4 downto 3);
-- 	InvertSelect_Signal_Out<= s_ControlBits(2);
-- 	ArithmeticLogicSelect_Signal_Out <= s_ControlBits(1);
-- 	Shift_LeftRight_Signal_Out <= s_ControlBits(0);

begin

	ALUControl <=
		"0001" when (ALUOp is "0001" && Funct is "100001") else -- addu
		"0001" when (ALUOp is "0001" && Funct is "100000") else -- add
		"0010" when (ALUOp is "0001" && Funct is "100100") else	--and
		"0011" when (ALUOp is "0001" && Funct is "100111") else	--nor
		"0100" when (ALUOp is "0001" && Funct is "100110") else	--xor
		"0101" when (ALUOp is "0001" && Funct is "100101") else	--or
		"0110" when (ALUOp is "0001" && Funct is "101010") else	--slt
		"0111" when (ALUOp is "0001" && Funct is "000000") else	--sll
		"1000" when (ALUOp is "0001" && Funct is "000010") else	--srl
		"1001" when (ALUOp is "0001" && Funct is "000011") else	--sra
		"1010" when (ALUOp is "0001" && Funct is "100010") else	--sub
		"1010" when (ALUOp is "0001" && Funct is "100011") else	--subu	
		--"0010" when (ALUOp is "0001" && Funct is "001000") else	--jr	
		"0001" when (ALUOp is "0010") else --addi
		"0001" when (ALUOp is "0011") else --addiu
		--TODO EVERYTHING BELOW
		"0001" when (ALUOp is "0011") else --andi
		"0001" when (ALUOp is "0011") else --lui
		"0001" when (ALUOp is "0011") else --lw
		"0001" when (ALUOp is "0011") else --sw
		"0001" when (ALUOp is "0011") else --xori
		"0001" when (ALUOp is "0011") else --slti
		"0001" when (ALUOp is "0011") else --or
		"0001" when (ALUOp is "0011") else --beq
		"0001" when (ALUOp is "0011") else --bne
		

end Design;
