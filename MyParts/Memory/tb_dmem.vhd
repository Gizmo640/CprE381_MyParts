library IEEE;
use IEEE.std_logic_1164.all;


entity tb_mem is
     generic(gCLK_HPER   : time := 10 ns);
end tb_mem;

architecture arch of tb_mem is
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component mem is
        generic (DATA_WIDTH : natural := 32;
                ADDR_WIDTH : natural := 10);
        port (clk: in std_logic;
            addr: in std_logic_vector((ADDR_WIDTH-1) downto 0);
            data_in: in std_logic_vector((DATA_WIDTH-1) downto 0);
            we: in std_logic := '1';
            data_out: out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component; 

    signal CLK: std_logic;

    signal s_addrSel: std_logic_vector(9 downto 0);
    signal s_output, s_input: std_logic_vector(31 downto 0);
    signal write_enable: std_logic;
begin
    P_CLK: process
        begin
            CLK <= '0';
            wait for gCLK_HPER;
            CLK <= '1';
            wait for gCLK_HPER;
    end process;

	dmem: mem
        port map(CLK, s_addrSel, s_input, write_enable, s_output);
    
	P_TEST_CASES: process begin
        wait for gCLK_HPER/2;


        write_enable <= '0';
        s_addrSel <= "0000000000";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000000";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000000001";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000001";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000000010";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000010";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000000011";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000011";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000000100";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000100";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000000101";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000101";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000000110";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000110";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000000111";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100000111";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000001000";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100001000";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0000001001";
		wait for cCLK_PER; -- 20ns
        write_enable <= '1';
        s_addrSel <= "0100001001";
        s_input <= s_output;
        wait for cCLK_PER; -- 20ns

        write_enable <= '0';
        s_addrSel <= "0100000000";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100000001";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100000010";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100000011";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100000100";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100000101";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100000110";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100000111";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100001000";
		wait for cCLK_PER; -- 20ns
        s_addrSel <= "0100001001";
		wait for cCLK_PER; -- 20ns
	end process;
end arch;