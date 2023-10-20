--Lincoln Hatlestad
--Control.vhd

library IEEE;
use IEEE.std_logic_1164.all;


entity Control is
    port(
        Opcode: in std_logic_vector(5 downto 0);
        Funct: in std_logic_vector(5 downto 0);
        Sign: out std_logic;
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
end Control;


architecture dataflow of Control is
    begin

    Sign <=
    '0' when (Opcode = "001100") else --andi
    '0' when (Opcode = "001101") else --ori
    '1'; --everything else uses signed extension

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
    "0000" when ((Opcode = "000000") and (Funct = "100000")) else  --add
    "0000" when (Opcode = "001000") else  --add (addi)
    "0001" when ((Opcode = "000000") and (Funct = "100001")) else  --addu
    "0001" when (Opcode = "001001") else --addu(addiu)
    "0010" when ((Opcode = "000000") and (Funct = "100100")) else  --and
    "0010" when (Opcode = "001100") else --and (andi)
    "0100" when ((Opcode = "000000") and (Funct = "100111")) else  --nor
    "0101" when ((Opcode = "000000") and (Funct = "100110")) else  -- xor
    "0101" when (Opcode = "001110") else --xor (xori)
    "0011" when ((Opcode = "000000") and (Funct = "100101")) else  -- or
    "0011" when (Opcode = "001101") else --or (ori)
    "0110" when ((Opcode = "000000") and (Funct = "101010")) else  --slt
    "0110" when (Opcode = "001010") else --slt (slti)
    "0111" when ((Opcode = "000000") and (Funct = "000000")) else  -- sll 
    "1000" when ((Opcode = "000000") and (Funct = "000010")) else  -- srl 
    "1001" when ((Opcode = "000000") and (Funct = "000011")) else  -- sra
    "1010" when ((Opcode = "000000") and (Funct = "100010")) else  -- sub
    "1011" when ((Opcode = "000000") and (Funct = "100011")) else  -- subu
    "1100" when (Opcode = "001111") else   -- lui
    "1101" when (Opcode = "100011") else   -- lw
    "1110" when (Opcode = "000100") else   -- beq
    "1111"; --idc
    --errors in ALUOp

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