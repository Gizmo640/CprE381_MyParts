library IEEE;
use IEEE.std_logic_1164.all;

entity NBit_AdderSubtracter is
	generic(N: INTEGER);
	port(
		AddSubtract_Signal: in STD_LOGIC;
		Carry_Out: out STD_LOGIC;
		BitsA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		BitsB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		Bits_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
		OverFlow_Flag: out STD_LOGIC;
		Zero_Flag: out STD_LOGIC);
end NBit_AdderSubtracter;

architecture Design of NBit_AdderSubtracter is
	
	component NBit_RippleAdder is
		generic(N: INTEGER);
		port(
			Carry_In: in STD_LOGIC;
			Carry_Out: out STD_LOGIC;
			BitsA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			BitsB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			Bits_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
			OverFlow_Flag: out STD_LOGIC;
			Zero_Flag: out STD_LOGIC);
	end component;

	signal s_InvertedBitsB_In: STD_LOGIC_VECTOR(N-1 downto 0);
begin
	AdderSubtracter_Generator: for i in 0 to N-1 generate
		s_InvertedBitsB_In(i) <= BitsB_In(i) xor AddSubtract_Signal;
	end generate AdderSubtracter_Generator;

	AdderSubtracter: NBit_RippleAdder
		generic map(N)
		port map(
			AddSubtract_Signal,
			Carry_Out,
			BitsA_In,
			s_InvertedBitsB_In,
			Bits_Out,
			OverFlow_Flag,
			Zero_Flag);
end Design;