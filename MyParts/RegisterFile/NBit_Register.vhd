library IEEE;
use IEEE.std_logic_1164.all;

entity NBit_Register is
	generic(N: INTEGER);
	port(
		Input_In: in STD_LOGIC_VECTOR(N-1 downto 0);
		Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
		Reset_Signal: in STD_LOGIC;
		WriteEnable_Signal: in STD_LOGIC;
		CLK_Signal: in STD_LOGIC);
end NBit_Register;

architecture Design of NBit_Register is
	component DFF is
		port(
			CLK_Signal: in STD_LOGIC;
			Reset_Signal: in STD_LOGIC;
			WriteEnable_Signal: in STD_LOGIC;
			InputD_In: in STD_LOGIC;
			OutputQ_Out: out STD_LOGIC);
	end component;
begin
	Register1: for i in N-1 downto 0 generate
		Register_Bits: DFF
			port map(
				CLK_Signal,
				Reset_Signal,
				WriteEnable_Signal,
				Input_In(i),
				Output_Out(i));
	end generate Register1;
end Design;