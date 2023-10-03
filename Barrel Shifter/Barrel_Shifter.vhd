library IEEE;
use IEEE.std_logic_1164.all;

--32 bit right shifter to start and left shifter in future
entity Barrel_Shifter is 
	--generic(N: INTEGER);
	port(
		shiftAmount : in std_logic_vector(4 downto 0); 
		BarrelInput : in std_logic_vector(31 downto 0); 
		Load_barrelInput : in std_logic; --what are the load ports for?
		Load_selectLines : in std_logic;
		Load_BarrelOutput : std_logic;
		BarrelOutput : out std_logic_vector(31 downto 0));

	end Barrel_Shifter;


architecture structure of Barrel_Shifter is 
	
	--signals
	signal stage5MuxOutput : std_logic_vector(31 downto 0);
	signal stage4MuxOutput : std_logic_vector(31 downto 0);
	signal stage3MuxOutput : std_logic_vector(31 downto 0);
	signal stage2MuxOutput : std_logic_vector(31 downto 0);
	


	--component mux 2t1
	component mux2t1 is 
		port(
			i_D0		: in std_logic;
			i_D1		: in std_logic;
			i_S		: in std_logic;
			o_0		: out std_logic);
		end component;

	

--STAGE 5
	--bits 31-16 set to 0
	Stage5Upper: for i in 31 downto 16 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => BarrelInput(i),
								i_D1 => '0',
								i_S => shiftAmount(4),
								o_O => stage5MuxOutput(i)
					);
				end generate Stage5Upper;

	--bits 15-0 set equal to shifted bits 31-16
	Stage5Lower: for i in 15 downto 0 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => BarrelInput(i),
								i_D1 => BarrelInput(i+16),
								i_S => shiftAmount(4),
								o_O => stage5MuxOutput(i)
					);
					end generate Stage5Lower;		


--STAGE 4
	--bits 31-24 set to 0 
	Stage4Upper: for i in 31 downto 24 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => stage5MuxOutput(i),
								i_D1 => '0',
								i_S => shiftAmount(3),
								o_O => stage4MuxOutput(i)
					);
					end generate Stage4Upper;
	--bits 23-0 set equal to bits 31-4
	Stage4Lower: for i in 23 downto 0 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => stage5MuxOutput(i),
								i_D1 => stage5MuxOutput(i+8),
								i_S => shiftAmount(3),
								o_O => stage4MuxOutput(i)
					);
					end generate Stage4Lower;	


--STAGE 3
	Stage3Upper: for i in 31 downto 28 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => stage4MuxOutput(i),
								i_D1 => '0',
								i_S => shiftAmount(2),
								o_O => stage3MuxOutput(i)
					);
					end generate Stage3Upper;
	--loop 31-24 bits set to 0 
	Stage3Lower: for i in 27 downto 0 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => stage4MuxOutput(i),
								i_D1 => stage4MuxOutput(i+4),
								i_S => shiftAmount(2),
								o_O => stage3MuxOutput(i)
					);
					end generate Stage3Lower;


--STAGE 2
	Stage2Upper: for i in 31 downto 30 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => stage3MuxOutput(i),
								i_D1 => '0',
								i_S => shiftAmount(1)
								o_O => stage2MuxOutput(i)

					);
					end generate Stage2Upper;
	--loop 31-24 bits set to 0 
	Stage2Lower: for i in 29 downto 0 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => stage3MuxOutput(i),
								i_D1 => stage3MuxOutput(i+2),
								i_S => shiftAmount(1),
								o_O => stage2MuxOutput(i)
					);
					end generate Stage2Lower;


--STAGE 1
	--one bit set to 0
	Stage1UpperBit :  mux2t1
					port map(
								i_D0 => stage2MuxOutput(31),
								i_D1 => '0',
								i_S => shiftAmount(0),
								o_O => BarrelOutput(31)
					);
	--loop from 30 downto 0 for all shifted bit values
	Stage1Lower: for i in 30 downto 0 generate
			MuxCascade: mux2t1
					port map(
								i_D0 => stage2MuxOutput(i),
								i_D1 => stage2MuxOutput(i+1),
								i_S => shiftAmount(0),
								o_O => BarrelOutput(i)
					);
					end generate Stage1Lower;