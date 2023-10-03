library IEEE;
use IEEE.std_logic_1164.all;

entity RegisterFile is
	port(
		Data_In: in STD_LOGIC_VECTOR(31 downto 0);
		DataA_Out: out STD_LOGIC_VECTOR(31 downto 0);
		DataB_Out: out STD_LOGIC_VECTOR(31 downto 0);
		RegisterWriteSelect_Signal: in STD_LOGIC_VECTOR(4 downto 0);
		DataA_Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
		DataB_Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
		Reset_Signal: in STD_LOGIC;
		WriteEnable_Signal: in STD_LOGIC;
		CLK_Signal: in STD_LOGIC);
end RegisterFile;

architecture Design of RegisterFile is
	component Decoder_5t32 is
		port(
			Enable_Signal: in STD_LOGIC;
			Input_In: in std_logic_vector(4 downto 0);
			Output_Out: out std_logic_vector(31 downto 0));
	end component;
	
	component Bit32_32t1Mux is
		port(
			Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
			Input_In: in array(31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
			Output_Out: out STD_LOGIC_VECTOR(31 downto 0));
	end component;

	component NBit_Register is
		generic(N: INTEGER);
		port(
			Input_In: in STD_LOGIC_VECTOR(N-1 downto 0);
			Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
			Reset_Signal: in STD_LOGIC;
			WriteEnable_Signal: in STD_LOGIC;
			CLK_Signal: in STD_LOGIC);
	end component;
begin

end Design;