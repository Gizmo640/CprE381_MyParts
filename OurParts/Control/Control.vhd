--Lincoln Hatlestad
--Control.vhd

library IEEE;
use IEEE.std_logic_1164.all;


entity Control is
    port(
        Opcode: in std_logic_vector(5 downto 0);
      --  ControlOut: std_logic_vector(11 downto 0);
        Jump: out std_logic; --bit 0
        Jr: out std_logic;   --bit 1 (does jr need to be an ALU control sig? It depends on the funct code)
        Branch: out std_logic;   --bit 2
        Link: out std_logic;     --bit 3
        MemRead: out std_logic;  --bit 4
        MemWrite: out std_logic; --bit 5
        MemtoReg: out std_logic; --bit 6
        ALUOp: out std_logic_vector(1 downto 0); --bit 8, bit 7
        ALUSrc: out std_logic;   --bit 9
        RegWrite: out std_logic; --bit 10
        RegDst: out std_logic;  --bit 11
    );
end Control;


architecture dataflow of Control is
    Jump <=
    '1' when (Opcode = "000010") else '0';

    Jr <=
    '1' when (Opcode = "000000") else '0';

    Branch <=
    '1' when (Opcode = "000010") else
    '1' when (Opcode = "000101") else '0';

    Link <=
    '1' when (Opcode = "000011") else '0';

    MemRead <=
    '1' when (Opcode = "100011") else '0'; --lw

    MemWrite <= 
    '1' when (Opcode = "101011") else '0'; --sw

    MemtoReg <=
    '1' when (Opcode = "100011") else '0'; --lw

 --   ALUOp <=

    ALUSrc <=
    '0' when (Opcode = "000000") else
    '0' when (Opcode = "000100") else
    '0' when (Opcode = "000101") else
    '0' when (Opcode = "000010") else
    '0' when (Opcode = "000011") else '1';

    -- RegWrite <= --how to do jal
    -- '0' when (Opcode = )

    RegDst <=
    '1' when (Opcode = "000000") else
    '1' when (Opcode = "000100") else
    '1' when (Opcode = "000101") else '0';

end dataflow;