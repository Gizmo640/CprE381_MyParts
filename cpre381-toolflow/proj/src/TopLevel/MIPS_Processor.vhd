-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH; N: INTEGER);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required Instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated



  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  component BarrelShifter is
  	port(
		    shiftAmount : in std_logic_vector(4 downto 0); 
		    BarrelInput : in std_logic_vector(31 downto 0); 
		    LeftOrRight : in std_logic; --0 is right and 1 is left
		    BarrelOutput : out std_logic_vector(31 downto 0));
  end component;

  component NBit_LookAheadAdder is
    port(
      Carry_In: in STD_LOGIC;
      Carry_Out: out STD_LOGIC;
      BitsA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
      BitsB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
      Bits_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
      OverFlow_Flag: out STD_LOGIC;
      Zero_Flag: out STD_LOGIC;
      Carry_Flag: out STD_LOGIC);
  end component;

  component NBit_Register is
    generic(N: INTEGER);
    port(
        Input_In: in STD_LOGIC_VECTOR(N-1 downto 0);
        Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
        Reset_Signal: in STD_LOGIC;
        WriteEnable_Signal: in STD_LOGIC;
        CLK_Signal: in STD_LOGIC);
  end component;

  component RegisterFile is
  	port(
      Data_In: in STD_LOGIC_VECTOR(31 downto 0);
      DataA_Out: out STD_LOGIC_VECTOR(31 downto 0);
      DataB_Out: out STD_LOGIC_VECTOR(31 downto 0);
      RegisterWriteSelect_Signal: in STD_LOGIC_VECTOR(4 downto 0)
      DataA_Select_Signal: in STD_LOGIC_VECTOR(4 downto 0)
      DataB_Select_Signal: in STD_LOGIC_VECTOR(4 downto 0);
      Reset_Signal: in STD_LOGIC;
      WriteEnable_Signal: in STD_LOGIC;
      CLK_Signal: in STD_LOGIC);
  end component;

  component Extender_16Bit is
    port(
      Input_In: in STD_LOGIC_VECTOR(15 downto 0);
      ExtendedOutput_Out: out STD_LOGIC_VECTOR(31 downto 0);
      UnsignedSigned_Signal: in STD_LOGIC);
  end component;

  component shift_left2 is
    port(
      DataIn: in std_logic_vector(25 downto 0);
      shiftedData: out std_logic_vector(27 downto 0));
  end component;

  component Control is
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
  end component;

  --ALU

  --ALU_ControlUnit

  component NBit_2t1Mux is
    port(
      InputSelect_Signal: in STD_LOGIC;
      InputA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
      InputB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
      Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0));
  end component;

  


  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
  -- Required fetch logic signal -- for jump and branch instructions (control)
  signal s_Jr           : std_logic; --jr mux select
  signal s_Jump         : std_logic; --jump mux select
  signal s_Link         : std_logic; --jal mux select
  signal s_Branch       : std_logic; --& with s_Zero
  signal s_Zero         : std_logic; --a single bit from the ALU output dictating whether its beq or bne
  signal s_ALUSrc       : std_logic; --PUT THIS IS LAB REPORT

  --mapping sigs
  signal s_PCAdderOut   : std_logic_vector(31 downto 0);
  signal s_RegDstMuxOut : std_logic_vector(4 downto 0); --output of the mux controlled by reg destination
  signal s_LinkMuxOut   : std_logic_vector(4 downto 0); --output of the mux controlled by link signal
  signal s_ExtendedOut  : std_logic_vector(31 downto 0);
  signal s_Read1        : std_logic_vector(31 downto 0); --register outputs
  signal s_Read2        : std_logic_vector(31 downto 0); --^
  signal s_ALUSrcMuxOut : std_logic_vector(31 downto 0); --alu input B
  signal s_BranchAndOut : std_logic; --controls 


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 



  --REGISTER/ALU/DMEM LOGIC

  RegDstMux: NBit_2t1Mux
    --generic
    port map(
      InputSelect_Signal => RegDst,
      InputA_In => s_Inst(20 downto 16),
      InputB_In => s_Inst(15 downto  11),
      Output_Out => s_RegDstMuxOut
    );

  LinkMux: NBit_2t1Mux
    --generic
      port map(
        InputSelect_Signal => Link,
        InputA_In => s_RegDstMuxOut,
        InputB_In => b"11111",
        Output_Out => s_LinkMuxOut
      );

  Registers: RegisterFile
    port map(
      Data_In => s_RegWrData,
      DataA_Out => , --idk
      DataB_Out => , --idk
      RegisterWriteSelect_Signal => s_RegWrAddr,
      DataA_Select_Signal => s_Inst(25 downto 21),
      DataB_Select_Signal => s_Inst(20 downto 16),
      Reset_Signal => iRST,
      WriteEnable_Signal => s_RegWr;
      CLK_Signal  => iCLK);

  SignExtender: Extender_16Bit
    port map(
      Input_In => s_Inst(15 downto 0),
      ExtendedOutput_Out  => s_ExtendedOut,
      UnsignedSigned_Signal => --idk
    );

  ALUSrcMux: NBit_2t1Mux
    --generic
    port map(
      InputSelect_Signal => s_ALUSrc,
      InputA_In => s_Read2,
      InputB_In => s_ExtendedOut,
      Output_Out => s_ALUSrcMuxOut
    );

  --alu control and alu
  ALUControl: ALU_ControlUnit
    port map();

  ALU_Unit: ALU
    port map();

  s_BranchAndOut <= s_Branch and s_Zero; --ALU Zero and Branch signal

  DMemMux: NBit_2t1Mux
    port map();
    

  --CONTROL LOGIC



  --FETCH LOGIC

    PCAdder: NBit_LookAheadAdder
      --generic map(N => DATA_WIDTH)
      port map(
        Carry_In => '0',
        Carry_Out => TODOsignal,
        BitsA_In => s_IMemAddr,
        BitsB_In => "00_0000_0100",
        Bits_Out => s_PCAdderOut, --4 highest bits concatted to end of jump address, also connects to branch adder
        OverFlow_Flag => null,
        Zero_Flag => null,
        Carry_Flag => null
      );

  

end structure;

