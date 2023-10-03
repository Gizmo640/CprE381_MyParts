library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  
          


entity tb_datapath2 is
  generic(gCLK_HPER   : time := 10 ns);  
end tb_datapath2;

architecture mixed of tb_datapath2 is


constant cCLK_PER  : time := gCLK_HPER * 2;


component DataPate2 is
   port(CLK		: in std_logic;
     Reg_Write_Enable : in std_logic; 
     Mem_Write_Enable : in std_logic; 
     Reset		    : in std_logic; 
     AddSub_Sel : in std_logic; 
	 ALUSel		    : in std_logic; 
     SignUnsign_ImmSel : in std_logic; 
     Mem_Sel        : in std_logic; 
	 Immediate		    : in std_logic_vector (15 downto 0);
     WriteReg_Sel		    : in std_logic_vector (4 downto 0);
     Do0_Sel		    : in std_logic_vector (4 downto 0);
     Do1_Sel		    : in std_logic_vector (4 downto 0));
end component;


signal CLK, reset : std_logic := '0';

signal s_RWEn		: std_logic;
signal s_MWEn       : std_logic;
signal s_RST		: std_logic;
signal s_nAdd_Sub	: std_logic;
signal s_ALUSrc		: std_logic;
signal s_ImmSign    : std_logic;
signal s_Mem2Reg    : std_logic;
signal s_I		    : std_logic_vector (15 downto 0);
signal s_WAdd		: std_logic_vector(4 downto 0);
signal s_RO1		: std_logic_vector(4 downto 0);
signal s_RO2		: std_logic_vector(4 downto 0);
signal s_Co		    : std_logic;

begin

 
  Datapath2: DataPate2
  port map(
        CLK     	=> CLK,
	    Reg_Write_Enable	    => s_RWEn,
        Mem_Write_Enable       => s_MWEn,
	    Reset	    => s_RST,
	    AddSub_Sel	=> s_nAdd_Sub,
	    ALUSel	    => s_ALUSrc,
        SignUnsign_ImmSel     => s_ImmSign,
        Mem_Sel     => s_Mem2Reg,
	    Immediate		    => s_I,
	    WriteReg_Sel	    => s_WAdd,
	    Do0_Sel	    => s_RO1,
	    Do1_Sel	    => s_RO2);


  
 
  P_CLK: process
  begin
    CLK <= '1';        
    wait for gCLK_HPER; 
    CLK <= '0';        
    wait for gCLK_HPER; 
  end process;


  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; 

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "11001";
    s_RO1		<= "00000";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0100";
    s_WAdd		<= "11010";
    s_RO1		<= "00000";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '1';
    s_I			<= x"0000";
    s_WAdd		<= "00001";
    s_RO1		<= "11001";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '1';
    s_I			<= x"0004";
    s_WAdd		<= "00010";
    s_RO1		<= "11001";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '0';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "00001";
    s_RO1		<= "00001";
    s_RO2		<= "00010";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '0';
    s_MWEn      <= '1';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "00000";
    s_RO1		<= "11010";
    s_RO2		<= "00001";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '1';
    s_I			<= x"0008";
    s_WAdd		<= "00010";
    s_RO1		<= "11001";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '0';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "00001";
    s_RO1		<= "00001";
    s_RO2		<= "00010";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '0';
    s_MWEn      <= '1';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0004";
    s_WAdd		<= "00000";
    s_RO1		<= "11010";
    s_RO2		<= "00001";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '1';
    s_I			<= x"000C";
    s_WAdd		<= "00010";
    s_RO1		<= "11001";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '0';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "00001";
    s_RO1		<= "00001";
    s_RO2		<= "00010";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '0';
    s_MWEn      <= '1';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0008";
    s_WAdd		<= "00000";
    s_RO1		<= "11010";
    s_RO2		<= "00001";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '1';
    s_I			<= x"0010";
    s_WAdd		<= "00010";
    s_RO1		<= "11001";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '0';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "00001";
    s_RO1		<= "00001";
    s_RO2		<= "00010";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '0';
    s_MWEn      <= '1';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"000C";
    s_WAdd		<= "00000";
    s_RO1		<= "11010";
    s_RO2		<= "00001";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '1';
    s_I			<= x"0014";
    s_WAdd		<= "00010";
    s_RO1		<= "11001";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '0';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "00001";
    s_RO1		<= "00001";
    s_RO2		<= "00010";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '0';
    s_MWEn      <= '1';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0010";
    s_WAdd		<= "00000";
    s_RO1		<= "11010";
    s_RO2		<= "00001";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '1';
    s_I			<= x"0018";
    s_WAdd		<= "00010";
    s_RO1		<= "11001";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '0';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0000";
    s_WAdd		<= "00001";
    s_RO1		<= "00001";
    s_RO2		<= "00010";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '1';
    s_MWEn      <= '0';
    s_nAdd_Sub	<= '0';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0200";
    s_WAdd		<= "11011";
    s_RO1		<= "00000";
    s_RO2		<= "00000";
    wait for gCLK_HPER*2;

    -- Test case:
    s_RST		<= '0';
    s_RWEn		<= '0';
    s_MWEn      <= '1';
    s_nAdd_Sub	<= '1';
    s_ALUSrc	<= '1';
    s_ImmSign   <= '1';
    s_Mem2Reg   <= '0';
    s_I			<= x"0004";
    s_WAdd		<= "00000";
    s_RO1		<= "11011";
    s_RO2		<= "00001";
    wait for gCLK_HPER*2;

    wait for gCLK_HPER*2;

  end process;

end mixed;
