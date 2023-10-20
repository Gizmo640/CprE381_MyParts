library IEEE;
use IEEE.std_logic_1164.all;

entity TB_BarrelShifter is
    generic(HalfCycle_CLK: time := 10 ns);
end TB_BarrelShifter;


architecture mixed of TB_BarrelShifter is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

    component Barrel_Shifter is
	port(
		shiftAmount : in std_logic_vector(4 downto 0); 
		BarrelInput : in std_logic_vector(31 downto 0); 
		LeftOrRight : in std_logic; --0 is right and 1 is left
		BarrelOutput : out std_logic_vector(31 downto 0));
    end component;


    --signals
    signal s_shiftAmount : std_logic_vector(4 downto 0);
    signal s_BarrelInput : std_logic_vector(31 downto 0);
    signal s_LeftOrRight : std_logic;
    signal s_BarrelOutput : std_logic_vector(31 downto 0);


begin

    Clock: process begin
            CLK <= '0';
            wait for HalfCycle_CLK;
            CLK <= '1';
            wait for HalfCycle_CLK;
        end process;

    --portmapping
    DUT0: Barrel_Shifter
        port map(
            shiftAmount => s_shiftAmount,
            BarrelInput => s_BarrelInput,
     	    LeftOrRight => s_LeftOrRight, --0 is left and 1 is right
            BarrelOutput => s_BarrelOutput
        );

    --test cases
    
    PTESTCASES: process
        begin
		wait for HalfCycle_CLK/2;


    --TEST CASE 1  expected output is x"0000FFFF"
    s_LeftOrRight <= '1';
    s_BarrelInput <= x"FFFFFFFF";
    s_shiftAmount <= "10000";
    wait for HalfCycle_CLK*2;

    --TEST CASE 2   expected output is x"8FFFFFFF"
    s_LeftOrRight <= '1';
    s_BarrelInput <= x"FFFFFFFF";
    s_shiftAmount <= "00001";
    wait for HalfCycle_CLK*2;

    --TEST CASE 3   expected output is x"00001"
    s_LeftOrRight <= '1';
    s_BarrelInput <= x"FFFFFFFF";
    s_shiftAmount <= "11111";
    wait for HalfCycle_CLK*2;

    --TEST CASE 4   expected output is x"FFFF0000"
    s_LeftOrRight <= '0';
    s_BarrelInput <= x"0000FFFF";
    s_shiftAmount <= "10000";
    wait for HalfCycle_CLK*2;

    --TEST CASE 5   expected output is x"00000000"
    s_LeftOrRight <= '0';
    s_BarrelInput <= x"FFFF0000";
    s_shiftAmount <= "10000";
    wait for HalfCycle_CLK*2;
 
    --TEST CASE 6   expected output is x"000FFFF0"
    s_LeftOrRight <= '0';
    s_BarrelInput <= x"0000FFFF";
    s_shiftAmount <= "00100";
    wait for HalfCycle_CLK*2;

    end process;



end mixed;