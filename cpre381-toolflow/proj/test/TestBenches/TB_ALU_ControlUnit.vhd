library IEEE;
use IEEE.std_logic_1164.all;

entity TB_ALU_ControlUnit is
	generic(HalfCycle_CLK: time := 10 ns);
end TB_ALU_ControlUnit;

architecture TB of TB_ALU_ControlUnit is
	constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	constant N: INTEGER := 32;

    component ALU_ControlUnit is
        port (		
            ALUOp: in std_logic_vector(3 downto 0);
		    Funct: in std_logic_vector(5 downto 0);
		    ALUControl: out std_logic_vector(3 downto 0)
		);
    end component;

    --signals
    signal s_ALUOp: std_logic_vector(3 downto 0);
    signal s_Funct: std_logic_vector(5 downto 0);
    signal s_ALUControl: std_logic_vector(3 downto 0);

begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

    --port mapping
    DUT0: ALU_ControlUnit
        port map(
            s_ALUOp,
            s_Funct,
            s_ALUControl
        );

	TEST_CASES: process 
    begin
		wait for HalfCycle_CLK/2;

        s_ALUOp <= "0001"; --r type
        s_Funct <= "1000000"; --add
        --Expected output is "0001"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0001"; --r type
        s_Funct <= "101010"; --slt
        --Expected output is "0110"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0001"; --r type
        s_Funct <= "000000"; --sll
        --Expected output is "0111"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0001"; --r type
        s_Funct <= "000010"; --srl
        --Expected output is "1000"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0001"; --r type
        s_Funct <= "000011"; --sra
        --Expected output is "1001"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0001"; --r type
        s_Funct <= "100010"; --sub
        --Expected output is "1010"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0010"; --addi
        s_Funct <= "111111"; --shouldn't matter
        --Expected output is "0001"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0000"; --LS
        s_Funct <= "111111"; --shouldn't matter
        --Expected output is "0000"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "0111"; --ori
        --Expected output is "1010"
		wait for CLK_Cycle;--20ns

        s_ALUOp <= "1000"; --beq
        --Expected output is "1010"
		wait for CLK_Cycle;--20ns
	end process;
end TB;