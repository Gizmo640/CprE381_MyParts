library IEEE;
use IEEE.std_logic_1164.all;

entity Extender_16Bit is
	port(
		Immediate_In: in STD_LOGIC_VECTOR(15 downto 0);
		ExtendedImmediate_Out: out STD_LOGIC_VECTOR(31 downto 0);
		Immediate_SignedUnsigned_Signal: in STD_LOGIC);
end Extender_16Bit;

architecture Design of Extender_16Bit is

	component NBit_2t1Mux is
		generic(N: INTEGER);
		port(
			InputSelect_Signal: in STD_LOGIC;
			InputA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			InputB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0));
	end component;

	signal s_Zeros, s_Ones: STD_LOGIC_VECTOR(15 downto 0);
	signal s_SignedUnsigned_Signal: STD_LOGIC;
begin
	s_Zeros <= x"0000";
	s_Ones <= x"FFFF";
	s_SignedUnsigned_Signal <= Immediate_In(15) and Immediate_SignedUnsigned_Signal;

	Muxs: NBit_2t1Mux generic map(16)
		port map(
			s_SignedUnsigned_Signal,
			s_Zeros,
			s_Ones,
			ExtendedImmediate_Out(31 downto 16));
	ExtendedImmediate_Out(15 downto 0) <= Immediate_In;
end Design;