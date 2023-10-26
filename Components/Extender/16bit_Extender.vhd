library IEEE;
use IEEE.std_logic_1164.all;

entity Extender_16Bit is
	port(
		Input_In: in STD_LOGIC_VECTOR(15 downto 0);
		ExtendedOutput_Out: out STD_LOGIC_VECTOR(31 downto 0);
		UnsignedSigned_Signal: in STD_LOGIC);
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
	signal s_UnsignedSigned_Signal: STD_LOGIC;
begin
	s_Zeros <= x"0000";
	s_Ones <= x"FFFF";
	s_UnsignedSigned_Signal <= Input_In(15) and UnsignedSigned_Signal;

	Muxs: NBit_2t1Mux
		generic map(16)
		port map(
			s_UnsignedSigned_Signal,
			s_Zeros,
			s_Ones,
			ExtendedOutput_Out(31 downto 16));
	ExtendedOutput_Out(15 downto 0) <= Input_In;
end Design;