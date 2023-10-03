---------------------------------------------------
--Lincoln Hatlestad
--ISU SE
-----------------------------------

--mux2t1.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is
	port(
		i_D0		: in std_logic;
		i_D1		: in std_logic;
		i_S		: in std_logic;
		o_0		: out std_logic);
end mux2t1;

  -- Describe the component entities as defined in org2.vhd, andg2.vhd, invg.vhd

architecture structural of mux2t1 is

	component org2
	  port(i_A          : in std_logic;
	       i_B          : in std_logic;
	       o_F          : out std_logic);
	end component;

	component andg2
	  port(i_A          : in std_logic;
	       i_B          : in std_logic;
	       o_F          : out std_logic);
	end component;

	component invg
	  port(i_A          : in std_logic;
	       o_F          : out std_logic);
	end component;


  --Signals to carry and gate and not gate outputs
	--signal for the not i_S
	signal s_not		: std_logic;
	--Signal for the s_not and i_D0
	signal s_and1		: std_logic;
	--Signal for the i_S and i_D1
	signal s_and2		: std_logic;
	
  --Port mapping is where design (gates and wires) are actually implemented

begin

	--not gate
	g_not: invg
	  port MAP(i_A		=> i_S,
		   o_F		=> s_not);

	--first and gate
	g_and1: andg2
	  port MAP(i_A		=> i_D0,
		   i_B		=> s_not,
		   o_F		=> s_and1);

	--second and gate
	g_and2: andg2
	  port MAP(i_A		=> i_S,
		   i_B		=> i_D1,
		   o_F		=> s_and2);

	--or gate
	g_or2: org2
	  port MAP(i_A		=> s_and1,
		   i_B		=> s_and2,
		   o_F		=> o_0);

end structural;



