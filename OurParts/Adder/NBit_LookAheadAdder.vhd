library IEEE;
use IEEE.std_logic_1164.all;

entity NBit_LookAheadAdder is
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
end NBit_LookAheadAdder;

architecture Design of NBit_LookAheadAdder is

	signal s_GenerateCarry: STD_LOGIC_VECTOR(N-1 downto 0);
	signal s_PropagateCarry: STD_LOGIC_VECTOR(N-1 downto 0);
	signal s_Carries: STD_LOGIC_VECTOR(N downto 0);
	signal S_OutPutBits: STD_LOGIC_VECTOR(N-1 downto 0);
begin

	s_Carries(0) <= Carry_In;

	FullAdders: for i in 0 to N-1 generate
		s_PropagateCarry(i) <= BitsA_In(i) xor BitsB_In(i);
		s_GenerateCarry(i) <= BitsA_In(i) and BitsB_In(i);
		S_OutPutBits(i) <= s_PropagateCarry(i) xor s_Carries(i);

		s_Carries(i+1) <= s_GenerateCarry(i) or (s_PropagateCarry(i) and s_Carries(i));
	end generate FullAdders;

	Bits_Out <= S_OutPutBits;
	Carry_Out <= s_Carries(N);

	OverFlow_Flag <= s_Carries(N) xor s_Carries(N-1);
	Zero_Flag <= '1' when (S_OutPutBits = (N-1 downto 0 => '0')) else '0';
	Carry_Flag <= s_Carries(N);
end Design;
