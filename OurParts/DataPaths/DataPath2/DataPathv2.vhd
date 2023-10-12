library IEEE;
use IEEE.std_logic_1164.all;

entity DataPate2 is
    port(Immediate: in std_logic_vector(15 downto 0);
       WriteReg_Sel, Do0_Sel, Do1_Sel: in std_logic_vector(4 downto 0);
       Reset, Reg_Write_Enable, ALUSel, AddSub_Sel, Mem_Sel, Mem_Write_Enable, SignUnsign_ImmSel, CLK: in std_logic);
end DataPate2;

architecture Datapaths of DataPate2 is

    component RegisterFile is
    port(Data_In: in std_logic_vector(31 downto 0);
        DataOut_0, DataOut_1: out std_logic_vector(31 downto 0);
        WriteReg_Sel, Do0_Sel, Do1_Sel: in std_logic_vector(4 downto 0);
        Reset, Write_Enable, CLK: in std_logic);
    end component;

    component AdderSub_N is
        generic(N : integer := 32);
        port(i_X : in std_logic_vector(N-1 downto 0);
            i_Y : in std_logic_vector(N-1 downto 0);
            Add_Sub : in std_logic;
            o_C : out std_logic;
            o_O : out std_logic_vector(N-1 downto 0));
    end component;

    component Nb_MUX2t1 is
        generic(n: positive);
        port( i_S : in std_logic;
            i_A : in std_logic_vector(n-1 downto 0);
            i_B : in std_logic_vector(n-1 downto 0);
            o_O : out std_logic_vector(n-1 downto 0));
    end component; 

    component bit16_Extender is
    port(in_16bit: in std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(31 downto 0);
        select_Pin: in std_logic);
    end component;

    component mem is
    generic(
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 10
    );
    port(
        clk		: in std_logic;
        addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
        data_in	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
        we		: in std_logic := '1';
        data_out		: out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
    end component;

    signal Reg_IN, DataOut_A, DataOut_B, ALU_In, Imm_Ext, ALU_Out, Mem_Out: std_logic_vector(31 downto 0);
    signal o_C: std_logic;
begin

    RegisterFile1: RegisterFile
        port map(Reg_IN, DataOut_A, DataOut_B, WriteReg_Sel, Do0_Sel, Do1_Sel, Reset, Reg_Write_Enable, CLK);

    Add_Sub1: AdderSub_N
        generic map(32)
        port map(DataOut_A, ALU_In, AddSub_Sel, o_C, ALU_Out);
        
    Mux1: Nb_MUX2t1
        generic map(32)
        port map(ALUSel, DataOut_B, Imm_Ext, ALU_In);

    Extender: bit16_Extender
        port map(Immediate, Imm_Ext, SignUnsign_ImmSel);
    
    Memory: mem
        generic map(32, 10)
        port map(CLK, ALU_Out(9 downto 0), DataOut_B, Mem_Write_Enable, Mem_Out);

    Mux2: Nb_MUX2t1
        generic map(32)
        port map(Mem_Sel, ALU_Out, Mem_Out, Reg_IN);
end Datapaths;