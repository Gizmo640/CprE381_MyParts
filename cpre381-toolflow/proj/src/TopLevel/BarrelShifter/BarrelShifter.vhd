library IEEE;
use IEEE.std_logic_1164.all;

--32 bit right shifter to start and left shifter in future
entity Barrel_Shifter is 
	--generic(N: INTEGER);
	port(
		shiftAmount : in std_logic_vector(4 downto 0); 
		UnsignedSigned: in std_logic;
		BarrelInput : in std_logic_vector(31 downto 0); 
		LeftOrRight : in std_logic; --0 is right and 1 is left
		BarrelOutput : out std_logic_vector(31 downto 0));

	end Barrel_Shifter;


architecture structure of Barrel_Shifter is 
	
	--signals
	signal s_MuxLorR	: std_logic_vector(31 downto 0);
	signal stage5MuxOutput : std_logic_vector(31 downto 0);
	signal stage4MuxOutput : std_logic_vector(31 downto 0);
	signal stage3MuxOutput : std_logic_vector(31 downto 0);
	signal stage2MuxOutput : std_logic_vector(31 downto 0);
	signal stage1MuxOutput : std_logic_vector(31 downto 0);
	signal s_UnsignedSigned : std_logic;


	--component mux 2t1
	component mux2t1 is 
		port(
			i_D0		: in std_logic;
			i_D1		: in std_logic;
			i_S		: in std_logic;
			o_0		: out std_logic);
		end component;

	
begin

--check sign
s_UnsignedSigned <= UnsignedSigned and BarrelInput(31);

--CHOOSES RIGHT OR LEFT SHIFT (NORMAL INPUT OR REVERSED INPUT)
	LEFT_OR_RIGHT: for i in 31 downto 0 generate
		MuxLorR1: mux2t1
			port map(
				i_D0	=>	BarrelInput(31-i),
				i_D1	=>  BarrelInput(i),
				i_S		=>  LeftOrRight,
				o_0		=>  s_MuxLorR(i)
			);
			end generate LEFT_OR_RIGHT;

--STAGE 5
	--bits 31-16 set to 0
	Stage5Upper: for i in 31 downto 16 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => s_MuxLorR(i), --need a signal
							i_D1 => s_UnsignedSigned,
							i_S => shiftAmount(4),
							o_0 => stage5MuxOutput(i)
					);
				end generate Stage5Upper;

	--bits 15-0 set equal to shifted bits 31-16
	Stage5Lower: for i in 15 downto 0 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => s_MuxLorR(i),
							i_D1 => s_MuxLorR(i+16),
							i_S => shiftAmount(4),
							o_0 => stage5MuxOutput(i)
					);
					end generate Stage5Lower;		


--STAGE 4
	--bits 31-24 set to 0 
	Stage4Upper: for i in 31 downto 24 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => stage5MuxOutput(i),
							i_D1 => s_UnsignedSigned,
							i_S => shiftAmount(3),
							o_0 => stage4MuxOutput(i)
					);
					end generate Stage4Upper;
	--bits 23-0 set equal to bits 31-4
	Stage4Lower: for i in 23 downto 0 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => stage5MuxOutput(i),
							i_D1 => stage5MuxOutput(i+8),
							i_S => shiftAmount(3),
							o_0 => stage4MuxOutput(i)
					);
					end generate Stage4Lower;	


--STAGE 3
	Stage3Upper: for i in 31 downto 28 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => stage4MuxOutput(i),
							i_D1 => s_UnsignedSigned,
							i_S => shiftAmount(2),
							o_0 => stage3MuxOutput(i)
					);
					end generate Stage3Upper;
	--loop 31-24 bits set to 0 
	Stage3Lower: for i in 27 downto 0 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => stage4MuxOutput(i),
							i_D1 => stage4MuxOutput(i+4),
							i_S => shiftAmount(2),
							o_0 => stage3MuxOutput(i)
					);
					end generate Stage3Lower;


--STAGE 2
	Stage2Upper: for i in 31 downto 30 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => stage3MuxOutput(i),
							i_D1 => s_UnsignedSigned,
							i_S => shiftAmount(1),
							o_0 => stage2MuxOutput(i)

					);
					end generate Stage2Upper;
	--loop 31-24 bits set to 0 
	Stage2Lower: for i in 29 downto 0 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => stage3MuxOutput(i),
							i_D1 => stage3MuxOutput(i+2),
							i_S => shiftAmount(1),
							o_0 => stage2MuxOutput(i)
					);
					end generate Stage2Lower;


--STAGE 1
	--one bit set to 0
	Stage1UpperBit :  mux2t1
					port map(
							i_D0 => stage2MuxOutput(31),
							i_D1 => s_UnsignedSigned,
							i_S => shiftAmount(0),
							o_0 => stage1MuxOutput(31)
					);
	--loop from 30 downto 0 for all shifted bit values
	Stage1Lower: for i in 30 downto 0 generate
			MuxCascade: mux2t1
					port map(
							i_D0 => stage2MuxOutput(i),
							i_D1 => stage2MuxOutput(i+1),
							i_S => shiftAmount(0),
							o_0 => stage1MuxOutput(i)
					);
					end generate Stage1Lower;

--CHOOSES RIGHT OR LEFT SHIFT (NORMAL INPUT OR REVERSED INPUT)
	LEFT_OR_RIGHT_OUTPUT: for i in 31 downto 0 generate
		MuxLorR2: mux2t1
			port map(
				i_D0	=>	stage1MuxOutput(31-i),
				i_D1	=>  stage1MuxOutput(i),
				i_S		=>  LeftOrRight,
				o_0		=>  BarrelOutput(i)
			);
			end generate LEFT_OR_RIGHT_OUTPUT;

end structure;