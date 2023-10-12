library IEEE;
use IEEE.std_logic_1164.all;

entity NBit_RippleAdder is
	generic(N: INTEGER);
	port(
		Carry_In: in STD_LOGIC;
		Carry_Out: out STD_LOGIC;
		BitsA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		BitsB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		Bits_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
		OverFlow_Flag: out STD_LOGIC;
		Zero_Flag: out STD_LOGIC;
		Carry_Flag: out STD_LOGIC);
end NBit_RippleAdder;

architecture Design of NBit_RippleAdder is

	component FullAdder is
		port(
			Carry_In: in STD_LOGIC;
			Carry_Out: out STD_LOGIC;
			BitA_In: in STD_LOGIC;
			BitB_In: in STD_LOGIC;
			Bit_Out: out STD_LOGIC);
	end component;

	signal s_Carries: STD_LOGIC_VECTOR(N downto 0);
	signal S_OutPutBits: STD_LOGIC_VECTOR(N-1 downto 0);

begin
	s_Carries(0) <= Carry_In;

	Adder_Generator: for i in 0 to N-1 generate
		Adder_Bit0: FullAdder
			port map(
				s_Carries(i),
				s_Carries(i+1),
				BitsA_In(i),
				BitsB_In(i),
				S_OutPutBits(i));
	end generate Adder_Generator;

	Bits_Out <= S_OutPutBits;
	Carry_Out <= s_Carries(N);
	
	OverFlow_Flag <= s_Carries(N) xor s_Carries(N-1);
	Zero_Flag <= '1' when (S_OutPutBits = (N-1 downto 0 => '0')) else '0';
	Carry_Flag <= s_Carries(N);
end Design;
