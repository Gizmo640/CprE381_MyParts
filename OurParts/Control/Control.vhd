--Lincoln Hatlestad
--Control.vhd

library IEEE;
use IEEE.std_logic_1164.all;


entity Control is
    port(
        Opcode: in std_logic_vector(5 downto 0);
        Funct: in std_logic_vector(5 downto 0);
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
        Halt: out std_logic
    );
end Control;


architecture dataflow of Control is
    begin

    Jump <=
    '1' when (Opcode = "000010") else '0'; --jump

    Jr <= --how to do for jr
    '1' when ((Opcode = "000000") and (Funct = "001000")) else '0'; --rtype

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
    "00000" when ((Opcode = "000000") and (Funct = "100001")) else  --addu
    "00000" when ((Opcode = "000000") and (Funct = "100000")) else  --add
    "00001" when ((Opcode = "000000") and (Funct = "100100")) else  --and
    "00010" when ((Opcode = "000000") and (Funct = "100111")) else  --nor
    "00011" when ((Opcode = "000000") and (Funct = "100110")) else  -- xor
    "00100" when ((Opcode = "000000") and (Funct = "100101")) else  -- or
    "00101" when ((Opcode = "000000") and (Funct = "101010")) else  --slt
    "00110" when ((Opcode = "000000") and (Funct = "000000")) else  -- sll 
    "00111" when ((Opcode = "000000") and (Funct = "000010")) else  -- srl 
    "01000" when ((Opcode = "000000") and (Funct = "000011")) else  -- sra
    "01001" when ((Opcode = "000000") and (Funct = "100010")) else  -- sub
    "01001" when ((Opcode = "000000") and (Funct = "100011")) else  -- subu
    "01010" when (Opcode = "001000") else   -- addi
    "01010" when (Opcode = "001001") else   -- addiu
    "01011" when (Opcode = "001100") else   --andi
    "01100" when (Opcode = "001111") else   -- lui
    "01101" when (Opcode = "100011") else   -- lw
    "01101" when (Opcode = "101011") else   -- sw
    "01110" when (Opcode = "001110") else   -- xori
    "01111" when (Opcode = "001010") else   -- slti
    "10000" when (Opcode = "001101") else   -- ori
    "10001" when (Opcode = "000100") else   -- beq
    "10001" when (Opcode = "000101") else   -- bne
    "xxxxx"; --useless

    ALUSrc <=
    '0' when (Opcode = "000000") else
    '0' when (Opcode = "000100") else
    '0' when (Opcode = "000101") else
    '0' when (Opcode = "000010") else
    '0' when (Opcode = "000011") else '1';

    RegWrite <= 
    '0' when (Opcode = "101011") else --sw
    '0' when (Opcode = "000100") else --beq
    '0' when (Opcode = "000101") else --bne
    '0' when (Opcode = "000010") else --j
    '0' when ((Opcode = "000000") and (Funct = "001000")) else '1'; --we only want to set this for jr


    RegDst <=
    '1' when (Opcode = "000000") else '0'; --rtype

    Halt <=
    '1' when (Opcode = "010100") else '0'; --single signal

end dataflow;