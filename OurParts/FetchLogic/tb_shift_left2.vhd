--Lincoln Hatlestad
--tb_shift_left2.vhd

library IEEE;
use IEEE.std_logic_1164.all;


entity tb_shift_left2 is
    generic(HalfCycle_CLK: time := 10 ns);
end tb_shift_left2;


architecture mixed of tb_shift_left2 is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

    component shift_left2 is
        port(
            DataIn: in std_logic_vector(25 downto 0);
            shiftedData: out std_logic_vector(27 downto 0));
    end component;

    signal s_DataIn: std_logic_vector(25 downto 0);
    signal s_shiftedData: std_logic_vector(27 downto 0);

begin

    Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

    DUT0: shift_left2
    port map(
        DataIn => s_DataIn,
        shiftedData => s_shiftedData
    );

    --Test Cases
    P_TEST_CASES: process
    
        begin

        wait for HalfCycle_CLK/2;

        --test case 1
        s_DataIn <= "11111111111111111111111111";
        wait for HalfCycle_CLK/2;

                --test case 2
        s_DataIn <= "00000111111111111111111111";
        wait for HalfCycle_CLK/2;


    
    end process;

end mixed;