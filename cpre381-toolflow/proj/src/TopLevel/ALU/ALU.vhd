library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
	port(
		ALU_Op: in STD_LOGIC_VECTOR(3 downto 0); --ALUop
		ShiftAmount : in std_logic_vector(4 downto 0);
		BitsA_In: in STD_LOGIC_VECTOR(31 downto 0); --rs
		BitsB_In: in STD_LOGIC_VECTOR(31 downto 0); --rt
		ALU_Out: out STD_LOGIC_VECTOR(31 downto 0);
		OverFlow_Flag: out STD_LOGIC;
		Zero_Flag: out STD_LOGIC;
		Carry_Flag: out STD_LOGIC);
end ALU;

architecture Design of ALU is

	component NBit_AdderSubtracter is
		generic(N: INTEGER);
		port(
			AddSubtract_Signal: in STD_LOGIC;
			BitsA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			BitsB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			Bits_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
			Carry_Out: out STD_LOGIC;
			OverFlow_Flag: out STD_LOGIC;
			Zero_Flag: out STD_LOGIC;
			Carry_Flag: out STD_LOGIC);
	end component;

	component NBit_2t1Mux is
		generic(N: INTEGER);
		port(
			InputSelect_Signal: in STD_LOGIC;
			InputA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			InputB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0));
	end component;

	component NBit_4t1Mux is
		generic(N: INTEGER);
		port(
			InputSelect_Signal: in STD_LOGIC_VECTOR(1 downto 0);
			InputA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			InputB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			InputC_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			InputD_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0));
	end component;

	component Barrel_Shifter is
		port(
			shiftAmount : in std_logic_vector(4 downto 0);
			BarrelInput : in std_logic_vector(31 downto 0);
			LeftOrRight : in std_logic; --0 is right and 1 is left
			BarrelOutput : out std_logic_vector(31 downto 0));
	end component;

	component ALU_ControlUnit
		port(
			ALU_ControlUnit_In: in STD_LOGIC_VECTOR(3 downto 0);
			AddSubtract_Signal_Out: out STD_LOGIC;
			LogicSelect_Signal_Out: out STD_LOGIC_VECTOR(1 downto 0);
			InvertSelect_Signal_Out: out STD_LOGIC;
			ArithmeticLogicSelect_Signal_Out: out STD_LOGIC;
			Shift_RightLeft_Signal_Out: out STD_LOGIC;
			ALUShifterSelect_Signal_Out: out STD_LOGIC;
			Signed_Signal_Out: out STD_LOGIC);
	end component;

	--ALU control output
	signal s_AddSubtract_Signal: STD_LOGIC;
	signal s_LogicSelect_Signal: STD_LOGIC_VECTOR(1 downto 0);
	signal s_InvertSelect_Signal: STD_LOGIC;
	signal s_ArithmeticLogicSelect_Signal: STD_LOGIC;
	signal s_Shift_RightLeft_Signal: STD_LOGIC;
	signal s_ALUShifterSelect_Signal: STD_LOGIC;
	signal s_Signed_Signal: STD_LOGIC;

	--flags
	signal s_OverFlow_Flag: STD_LOGIC;
	signal s_Zero_Flag: STD_LOGIC;
	signal s_Carry_Flag: STD_LOGIC;

	signal s_Carry_Out: STD_LOGIC;

	--and, or, xor, nor
	signal s_AND_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal s_OR_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal s_XOR_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal s_InvertedLogic_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal s_Inverter_Out: STD_LOGIC_VECTOR(31 downto 0);

	--logical component outputs
	signal s_Arithmetic_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal s_Logic_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal s_Shifter_Out: STD_LOGIC_VECTOR(31 downto 0);

	--mux outputs
	signal s_ArithmeticLogicMux_Out: STD_LOGIC_VECTOR(31 downto 0);
	signal s_ALUShifterMux_Out: STD_LOGIC_VECTOR(31 downto 0);

	-- huh??
	signal s_ZeroOneSelect_Signal: STD_LOGIC;
	signal s_SLT_Out: STD_LOGIC_VECTOR(31 downto 0);

begin

	ALUControl: ALU_ControlUnit
		port map(
			ALU_Op,
			s_AddSubtract_Signal,
			s_LogicSelect_Signal,
			s_InvertSelect_Signal,
			s_ArithmeticLogicSelect_Signal,
			s_Shift_RightLeft_Signal,
			s_ALUShifterSelect_Signal,
			s_Signed_Signal);

	Shifter: Barrel_Shifter --BACKWARDS??
		port map(
			ShiftAmount,
			BitsB_In,
			s_Shift_RightLeft_Signal,
			s_Shifter_Out);

	AdderSubtracter: NBit_AdderSubtracter
		generic map(32)
		port map(
			s_AddSubtract_Signal,
			BitsA_In,
			BitsB_In,
			s_Arithmetic_Out,
			s_Carry_Out, --error, wrong sig
			s_OverFlow_Flag,
			s_Zero_Flag,
			s_Carry_Flag);

	--Flag Setting
	OverFlow_Flag <= s_OverFlow_Flag and s_Signed_Signal;
	Zero_Flag <= s_Zero_Flag;
	Carry_Flag <= s_Carry_Flag;

	s_ZeroOneSelect_Signal <= s_Carry_Flag and (not s_Zero_Flag);

	--Not sure how this is an option for the output
	SLT_Mux: NBit_2t1Mux
		generic map(32)
		port map(
			s_ZeroOneSelect_Signal,
			x"00000000",
			x"00000001",
			s_SLT_Out);

	--Bitwise Operations
	s_AND_Out <= BitsA_In and BitsB_In;
	s_OR_Out <= BitsA_In or BitsB_In;
	s_XOR_Out <= BitsA_In xor BitsB_In;

	LogicSelect_Mux: NBit_4t1Mux
		generic map(32)
		port map(
			s_LogicSelect_Signal,
			s_SLT_Out, -- (why is stl connected here?)
			s_AND_Out, --and
			s_OR_Out, --or
			s_XOR_Out, --xor
			s_Logic_Out); --output of mux


	--this is probably used for nor
	s_InvertedLogic_Out <= not s_Logic_Out;

	--Either outputs the normal bitwise or it outputs nor
	Inverter_Mux: NBit_2t1Mux
		generic map(32)
		port map(
			s_InvertSelect_Signal,
			s_Logic_Out, --other bitwise
			s_InvertedLogic_Out, --nor
			s_Inverter_Out);

	ArithmeticLogic_Mux: NBit_2t1Mux
		generic map(32)
		port map(
			s_ArithmeticLogicSelect_Signal,
			s_Inverter_Out, --0 (bitwise function output)
			s_Arithmetic_Out,	--1 (add/sub output)
			s_ArithmeticLogicMux_Out);

	ALUShifter_Mux: NBit_2t1Mux
		generic map(32)
		port map(
			s_ALUShifterSelect_Signal,
			s_ArithmeticLogicMux_Out, --when sig is 0
			s_Shifter_Out, --when sig is 1
			s_ALUShifterMux_Out); --output of ALU

	ALU_Out <= s_ALUShifterMux_Out;
end Design;