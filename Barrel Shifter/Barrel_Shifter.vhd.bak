library IEEE;
use IEEE.std_logic_1164.all;

--32 bit right shifter to start and left shifter in future
entity Barrel_Shifter is 
	generic(N: INTEGER);
	port(
		selectLines : in std_logic_vector(4 downto 0); 
		barrelInput : in std_logic_vector(31 downto 0); 
		clock : in std_logic;
		Load_barrelInput : in std_logic;
		Load_selectLines : in std_logic;
		Load_BarrelOutput : std_logic;
		BarrelOutput : out std_logic_vector(31 downto 0));

	end Barrel_Shifter;


architecture structure of Barrel_Shifter is 
	
	--2 to 1 mux for barrel shfiter
	component	
		port(
	
	