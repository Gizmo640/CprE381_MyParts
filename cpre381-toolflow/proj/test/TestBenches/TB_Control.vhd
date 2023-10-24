library IEEE;
use IEEE.std_logic_1164.all;


entity TB_Control is
    generic(HalfCycle_CLK: time := 10 ns);
end TB_Control;


architecture mixed of TB_Control is
    constant CLK_Cycle: time := HalfCycle_CLK*2;--20ns
	signal CLK: std_logic;

	constant N: INTEGER := 32;

    --Control 
    component Control is
      port(
          Opcode: in std_logic_vector(5 downto 0);
          Funct: in std_logic_vector(5 downto 0);
          ZeroSign: out std_logic;
          Jump: out std_logic; --bit 0
          Jr: out std_logic;   --bit 1 (does jr need to be an ALU control sig? It depends on the funct code)
          Branch: out std_logic;   --bit 2
          Link: out std_logic;     --bit 3
          MemRead: out std_logic;  --bit 4
          MemWrite: out std_logic; --bit 5
          MemtoReg: out std_logic; --bit 6
          ALUOp: out std_logic_vector(3 downto 0);
          ALUSrc: out std_logic;   --bit 9
          RegWrite: out std_logic; --bit 10
          RegDst: out std_logic;  --bit 11
          Halt: out std_logic
      );
    end component;

    --signals
    signal Opcode : std_logic_vector(5 downto 0);
    signal Funct  : std_logic_vector(5 downto 0);
    signal s_ZeroSign : std_logic;
    signal s_Jump : std_logic;
    signal s_Jr : std_logic;
    signal s_Branch : std_logic;
    signal s_Link : std_logic;
    signal s_MemRead : std_logic;
    signal s_MemWrite : std_logic;
    signal s_MemtoReg : std_logic;
    signal s_ALUOp : std_logic_vector(3 downto 0); 
    signal s_ALUSrc : std_logic; 
    signal s_RegWrite : std_logic;
    signal s_RegDst : std_logic;
    signal s_Halt : std_logic;

    begin
	Clock: process begin
		CLK <= '0';
		wait for HalfCycle_CLK;
		CLK <= '1';
		wait for HalfCycle_CLK;
	end process;

    --mapping components 
    DUT0: Control port map(
            Opcode,
            Funct,
            s_ZeroSign,
            s_Jump,
            s_Jr,
            s_Branch,
            s_Link,
            s_MemRead,
            s_MemWrite,
            s_MemtoReg,
            s_ALUOp,
            s_ALUSrc,
            s_RegWrite,
            s_RegDst,
            s_Halt
        );

	TEST_CASES: process begin
		wait for HalfCycle_CLK/2;

        Opcode <= "000000"; -- Rtypes
        Funct <= "100001"; --add
        wait for CLK_Cycle;--20ns

        Opcode <= "000000"; -- Rtypes
        Funct <= "100000"; --add
        wait for CLK_Cycle;--20ns
        
        Opcode <= "000000"; -- Rtypes
        Funct <= "100100"; --add
        wait for CLK_Cycle;--20ns

        Opcode <= "000000"; -- Rtypes
        Funct <= "100101"; --add
        wait for CLK_Cycle;--20ns

        Opcode <= "000000"; -- Rtypes
        Funct <= "101010"; --add
        wait for CLK_Cycle;--20ns

        Opcode <= "000000"; -- Rtypes
        Funct <= "000000"; --add
        wait for CLK_Cycle;--20ns

        Opcode <= "000000"; -- Rtypes
        Funct <= "000010"; --add
        wait for CLK_Cycle;--20ns

        Opcode <= "001000";--addi
        wait for CLK_Cycle;--20ns

        Opcode <= "001001";--addiu
        wait for CLK_Cycle;--20ns

        Opcode <= "001100";--andi
        wait for CLK_Cycle;--20ns

          Opcode <= "001111";--lui
        wait for CLK_Cycle;--20ns

        Opcode <= "100011";--lw
        wait for CLK_Cycle;--20ns

          Opcode <= "101011";--sw
        wait for CLK_Cycle;--20ns

        Opcode <= "001110";--xori
        wait for CLK_Cycle;--20ns

          Opcode <= "001010";--slti
        wait for CLK_Cycle;--20ns

        Opcode <= "001101";--ori
        wait for CLK_Cycle;--20ns

          Opcode <= "000100";--beq
        wait for CLK_Cycle;--20ns
    
          Opcode <= "000101"; --bne
        wait for CLK_Cycle;--20ns

        Opcode <=  "000010";--j 
        wait for CLK_Cycle;--20ns

          Opcode <= "000011"; --jal
        wait for CLK_Cycle;--20ns

        Opcode <= "000000"; --jr
        wait for CLK_Cycle;--20ns

	end process;




end mixed;