library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.MyPackage.all;

entity Bit32_32t1Mux is
	port(
		Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
		Input_In: in STD_LOGIC_ARRAY(0 to 31)(31 downto 0);
		Output_Out: out STD_LOGIC_VECTOR(31 downto 0));
end Bit32_32t1Mux;
architecture Design of Bit32_32t1Mux is
type STD_LOGIC_ARRAY is array (natural range <>) of STD_LOGIC_VECTOR;

begin
	for i is 0 to 31 loop
		Output_Out <= Input_In(i) when (to_integer(Select_Signal) = i) else
			(31 downto 0 => 'x');
	end loop;
end Design;