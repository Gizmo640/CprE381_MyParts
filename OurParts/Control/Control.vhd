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
        RegDst: out std_logic  --bit 11
    );
end Control;


architecture dataflow of Control is
    begin

    Jump <=
    '1' when (Opcode = "000010") else '0';

    Jr <= --how to do for jr
    '1' when (Opcode = "000000") else '0'; --rtype

    Branch <=
    '1' when (Opcode = "000010") else --beq
    '1' when (Opcode = "000101") else '0'; --bne

    Link <=
    '1' when (Opcode = "000011") else '0'; --jal

    MemRead <=
    '1' when (Opcode = "100011") else '0'; --lw

    MemWrite <= 
    '1' when (Opcode = "101011") else '0'; --sw

    MemtoReg <=
    '1' when (Opcode = "100011") else '0'; --lw

    ALUOp <=
    "10" when (Opcode = "000000") else  --rtype
    "00" when (Opcode = "100011") else  --lw
    "00" when (Opcode = "101011") else  --sw
    "01" when (Opcode = "000100") else --beq
    "01" when (Opcode = "000101") else --bne
    "11"; --for I type (how do we choose which function?)
    
    ALUSrc <=
    '0' when (Opcode = "000000") else
    '0' when (Opcode = "000100") else
    '0' when (Opcode = "000101") else
    '0' when (Opcode = "000010") else
    '0' when (Opcode = "000011") else '1';

    RegWrite <= --what do we do for jr???
    '0' when (Opcode = "101011") else --sw
    '0' when (Opcode = "000100") else --beq
    '0' when (Opcode = "000101") else --bne
    '0' when (Opcode = "000010") else --j
    '0' when (Opcode = "000000") else '1'; --we only want to set this for jr


    RegDst <=
    '1' when (Opcode = "000000") else '0'; --rtype

end dataflow;