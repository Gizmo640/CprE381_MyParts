library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Barrel_Shifter is
    generic(HalfCycle_CLK: time := 10 ns);
end tb_Barrel_Shifter;


architecture mixed of tb_Barrel_Shifter is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

    component Barrel_Shifter is
        port(
            shiftAmount : in std_logic_vector(4 downto 0); 
            BarrelInput : in std_logic_vector(31 downto 0);
            Load_barrelInput : in std_logic;
            Load_selectLines : in std_logic;
            Load_BarrelOutput : std_logic;
            BarrelOutput : out std_logic_vector(31 downto 0));
    end component;


    --signals
    signal s_shiftAmount : std_logic_vector(4 downto 0);
    signal s_BarrelInput : std_logic_vector(31 downto 0);
    signal s_Load_barrelInput : std_logic;
    signal s_Load_selectLines : std_logic;
    signal s_Load_BarrelOutput : std_logic;
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
            Load_barrelInput => s_Load_barrelInput,
            Load_selectLines => s_Load_selectLines,
            Load_BarrelOutput => s_Load_BarrelOutput,
            BarrelOutput => s_BarrelOutput
        );

    --test cases
    
    PTESTCASES: process
        begin
		wait for HalfCycle_CLK/2;

    --TEST CASE 1   expected output is x"0000FFFF"
    s_BarrelInput <= x"FFFFFFFF";
    s_shiftAmount <= "10000";
    wait for HalfCycle_CLK/2;

    --TEST CASE 2   expected output is x"8FFFFFFF"
    s_BarrelInput <= x"FFFFFFFF";
    s_shiftAmount <= "00001";
    wait for HalfCycle_CLK/2;

    --TEST CASE 3   expected output is x"00001"
    s_BarrelInput <= x"FFFFFFFF";
    s_shiftAmount <= "11111";
    wait for HalfCycle_CLK/2;

    end process;



end mixed;