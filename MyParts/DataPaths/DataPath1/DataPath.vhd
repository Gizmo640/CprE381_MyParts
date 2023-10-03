library IEEE;
use IEEE.std_logic_1164.all;

entity DataPate is
    port(Immediate: in std_logic_vector(31 downto 0);
       WriteReg_Sel, Do0_Sel,Do1_Sel: in std_logic_vector(4 downto 0);
       Reset, Write_Enable, ALUSel, AddSub_Sel, CLK: in std_logic);
end DataPate;

architecture arch of DataPate is

    component RegisterFile is
    port(Data_In: in std_logic_vector(31 downto 0);
        DataOut_0, DataOut_1: out std_logic_vector(31 downto 0);
        WriteReg_Sel, Do0_Sel,Do1_Sel: in std_logic_vector(4 downto 0);
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

    signal DataOut_A, DataOut_B, ALU_In, ALU_Out: std_logic_vector(31 downto 0);
    signal o_C: std_logic;
begin

    RegisterFile1: RegisterFile
        port map (ALU_Out, DataOut_A, DataOut_B, WriteReg_Sel, Do0_Sel, Do1_Sel, Reset, Write_Enable, CLK);

    Add_Sub1: AdderSub_N
        generic map(32)
        port map(DataOut_A, ALU_In, AddSub_Sel, o_C, ALU_Out);
        
    Mux1: Nb_MUX2t1
        generic map (32)
        port map(ALUSel, DataOut_B, Immediate, ALU_In);
end arch;