-------------------------------------------------------------------------
-- Lincoln Hatelstad & Doyle Chism & Jesse Giligham
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

--check inputs and ouputs to make sure it is mapped correctly
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

  --Memory that is used for DMEM and IMEM
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

  --Can shift left or right N Bits 
  component BarrelShifter is
  	port(
		    shiftAmount : in std_logic_vector(4 downto 0); 
		    BarrelInput : in std_logic_vector(31 downto 0); 
		    LeftOrRight : in std_logic; --0 is right and 1 is left
		    BarrelOutput : out std_logic_vector(31 downto 0));
  end component;

  --Adder for Processor 
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

  --NBit Register size
  component NBit_Register is
    generic(N: INTEGER);
    port(
        Input_In: in STD_LOGIC_VECTOR(N-1 downto 0);
        Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0);
        Reset_Signal: in STD_LOGIC;
        WriteEnable_Signal: in STD_LOGIC;
        CLK_Signal: in STD_LOGIC);
  end component;

  --Register File 
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

  --Sign Extender
  component Extender_16Bit is
    port(
      Input_In: in STD_LOGIC_VECTOR(15 downto 0);
      ExtendedOutput_Out: out STD_LOGIC_VECTOR(31 downto 0);
      UnsignedSigned_Signal: in STD_LOGIC);
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
        RegDst: out std_logic;  --bit 11
        Halt: out std_logic
    );
  end component;

  --ALU(could need adjustments)
  component ALU is
    port(
    ALU_ControlUnit_In: in STD_LOGIC_VECTOR(&* downto 0);--Size Needed
		BitsA_In: in STD_LOGIC_VECTOR(31 downto 0);
		BitsB_In: in STD_LOGIC_VECTOR(31 downto 0);
		Bits_Out: out STD_LOGIC_VECTOR(31 downto 0);
		OverFlow_Flag: out STD_LOGIC;
		Zero_Flag: out STD_LOGIC;
		Carry_Flag: out STD_LOGIC);
    end component;

  --ALU_ControlUnit(could need adjustments)
  component ALU_ControlUnit is 
    port(
    ALU_ControlUnit_In: in STD_LOGIC_VECTOR(&* downto 0)
		AddSubtract_Signal_Out: out STD_LOGIC;
		LogicSelect_Signal_Out: out STD_LOGIC_VECTOR(1 downto 0);
		InvertSelect_Signal_Out: out STD_LOGIC;
		ArithmeticLogicSelect_Signal_Out: out STD_LOGIC;
		Shift_LeftRight_Signal_Out: out STD_LOGIC);
    end component;

  --NBit MUX
  component NBit_2t1Mux is
    port(
      InputSelect_Signal: in STD_LOGIC;
      InputA_In: in STD_LOGIC_VECTOR(N-1 downto 0);
      InputB_In: in STD_LOGIC_VECTOR(N-1 downto 0);
      Output_Out: out STD_LOGIC_VECTOR(N-1 downto 0));
  end component;

  

  --SIGNALS FOR MAPPING
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

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
  --ALU signals
  signal s_Zero         : std_logic; --a single bit from the ALU output dictating whether its beq or bne
  

  --mapping signals
  signal s_PCAdderOut   : std_logic_vector(31 downto 0); --PC+4
  signal s_RegDstMuxOut : std_logic_vector(4 downto 0); --output of the mux controlled by reg destination
  signal s_LinkMuxOut   : std_logic_vector(4 downto 0); --output of the mux controlled by link signal
  signal s_ExtendedOut  : std_logic_vector(31 downto 0);
  signal s_Read1        : std_logic_vector(31 downto 0); --register outputs
  signal s_Read2        : std_logic_vector(31 downto 0); --^
  signal s_ALUSrcMuxOut : std_logic_vector(31 downto 0); --alu input B
  signal s_BranchAndOut : std_logic; --decides beq or bne
  signal s_shiftedInstructionBits : std_logic_vector(27 downto 0);
  signal s_JumpAddress  : std_logic_vector(31 downto 0); --s_shiftedInstructionBits with 4 bits from PC+4 concatonated to it
  signal s_shiftedSignExtenderOut : std_logic_vector(31 downto 0);--double check the size
  signal s_branchAdderOut : std_logic_vector(31 downto 0); -- double check size
  signal s_ANDsignalMuxOut : std_logic_vector(31 downto 0);
  signal s_JumpSignalMuxOut : std_logic_vector(31 downto 0);
  signal s_InstShift26t28   : std_logic_vector(28 downt0 0); --this is the output of the "shift left 2" component in our schematic, we will concat this with the 4 highest bits of PC+4
  signal s_JumpSignalMuxOut : std_logic_vector(31 downto 0); --the jump address is calculated from shifted inst bits being concatonated with the highest bits of PC+4 (goes into JumpMux)
  
  -- Required fetch logic signal -- for jump and branch instructions (control)
  --signals for the output of the Control Signal Block
  signal s_Jr           : std_logic; --jr mux select
  signal s_Jump         : std_logic; --jump mux select
  signal s_Link         : std_logic; --jal mux select
  signal s_Branch       : std_logic; --& with s_Zero
  signal s_ALUSrc       : std_logic; --PUT THIS IS LAB REPORT
  signal s_DestinationReg : std_logic; --reg dest 
  signal s_MemtoReg : std_logic; --output of Control Unit
  signal s_MemRead : std_logic; --mem read output 
  signal s_ALUOp : std_logic_vector(1 downto 0);
  signal s_MemWrite : std_logic;
  --signal s_Unsigned : std_logic; --might need this sig for addiu and subu


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  --Given data don't mess with
  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  --Given data don't mess with
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- add s_Halt to Control?

  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU
  -- TODO: Implement the rest of your processor below this comment! 
  --REGISTER/ALU/DMEM LOGIC

  RegDstMux: NBit_2t1Mux
    generic map(N => 32);
    port map(
      InputSelect_Signal => RegDst,
      InputA_In => s_Inst(20 downto 16),
      InputB_In => s_Inst(15 downto 11),
      Output_Out => s_RegDstMuxOut
    );

  LinkMux: NBit_2t1Mux
    generic map(N => 32);
    port map(
      InputSelect_Signal => Link,
      InputA_In => s_RegDstMuxOut,
      InputB_In => b"11111", --hard coded 31
      Output_Out => s_LinkMuxOut
      );

  Registers: RegisterFile
    port map(
      Data_In => s_RegWrData,
      DataA_Out => s_Read1, --ALU input A, also in jrMux
      DataB_Out => s_Read2,
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
      UnsignedSigned_Signal => '0';
    );
  --MUX NAMED BASED ON SELECT LINE
  ALUSrcMux: NBit_2t1Mux
    generic map(N => 32);
    port map(
      InputSelect_Signal => s_ALUSrc,
      InputA_In => s_Read2,
      InputB_In => s_ExtendedOut,
      Output_Out => s_ALUSrcMuxOut --ALU input B
    );

  --TODO ALU CONTROL AND ALU
  ALUControl: ALU_ControlUnit
    port map(
      ALU_ControlUnit_In => ,                            --in STD_LOGIC_VECTOR(&* downto 0)
      AddSubtract_Signal_Out => ,                        --out STD_LOGIC;
      LogicSelect_Signal_Out => ,                        --out STD_LOGIC_VECTOR(1 downto 0);
      InvertSelect_Signal_Out => ,                       --out STD_LOGIC;
      ArithmeticLogicSelect_Signal_Out => ,              --out STD_LOGIC;
      Shift_LeftRight_Signal_Out =>                      --out STD_LOGIC);
    );

  --TODO
  ALU_Unit: ALU
    port map(
    ALU_ControlUnit_In => ,                 --in STD_LOGIC_VECTOR(&* downto 0);--Size Needed
		BitsA_In => ,                             --in STD_LOGIC_VECTOR(31 downto 0);
		BitsB_In => ,                             --in STD_LOGIC_VECTOR(31 downto 0);
		Bits_Out => ,                             --out STD_LOGIC_VECTOR(31 downto 0);
		OverFlow_Flag => ,                        --out STD_LOGIC;
		Zero_Flag => ,                            --out STD_LOGIC;
		Carry_Flag =>                             --out STD_LOGIC
    );

  s_BranchAndOut <= s_Branch and s_Zero; --ALU Zero and Branch signal

  DMemMux: NBit_2t1Mux
    generic map(N => 32);
    port map(
      InputSelect_Signal => s_MemtoReg,
      InputA_In => s_DMemOut,
      InputB_In => ,--ALU ouput signal
      Output_Out => s_RegWrData -- write data input
    );


  --CONTROL LOGIC
    ControlUnit : Control 
    port map(
      Opcode => s_Inst(31 downto 26), --in std_logic_vector(5 downto 0);
      --  ControlOut: std_logic_vector(11 downto 0);
      Jump => s_Jump, --bit 0
      Jr => s_Jr,  --bit 1 (does jr need to be an ALU control sig? It depends on the funct code)
      Branch => s_Branch,  --bit 2
      Link => s_Link,    --bit 3
      MemRead => s_MemRead--bit 4
      MemWrite => s_MemWrite--bit 5
      MemtoReg => s_MemtoReg, --bit 6
      ALUOp => s_ALUOp, --bit 8, bit 7
      ALUSrc => s_ALUSrc, --bit 9
      RegWrite => s_RegWr,--bit 10
      RegDst => s_DestinationReg, --bit 11
      Halt => s_Halt
      );

  --FETCH LOGIC

    --UNSURE ABOUT MAJORITY OF INPUTS FOR THE ADDER(EXCEPT BITS A, BITS B, BITS OUT)
    PCAdder: NBit_LookAheadAdder -- first adder in schematic
    generic map(N => 32);
      port map(
        Carry_In => '0',--??
        Carry_Out => TODOsignal,--?? can we just null?
        BitsA_In => s_IMemAddr, --PC
        BitsB_In => x"00000004", --hard code 4
        Bits_Out => s_PCAdderOut, --4 highest bits concatted to end of jump address, also connects to branch adder
        OverFlow_Flag => null, -- idk
        Zero_Flag => null, --idk
        Carry_Flag => null --idk
      );

    s_InstShift26t28 <= s_Inst(25 downto 0) & "00"; --shift left 2

    s_JumpAddress <= sInst(25 downto 0) & s_PCAdderOut(31 downto 28);

    s_shiftedSignExtenderOut <= s_ExtendedOut & "00"; --shift left 2

    BranchAdder: NBit_LookAheadAdder --second adder in schematic
      generic map(N => 32);
      port map(
        Carry_In => '0',--??
        Carry_Out => TODOsignal,--??
        BitsA_In => s_PCAdderOut, --adder ouput
        BitsB_In => s_shiftedSignExtenderOut, -- shifted output of the extender
        Bits_Out => s_branchAdderOut, -- signal for ouput 
        OverFlow_Flag => null,
        Zero_Flag => null,
        Carry_Flag => null
      );

  --SHOULD WE JUST DO MUX1 MUX2 MUX3 ?
  --TODO MAP TO A 32bit 4t1 Mux instead (OPTIONAL)
  MUXAndSelectSignal: NBit_2t1Mux
    generic map(N => 32);
    port map(
      InputSelect_Signal => s_BranchAndOut,--output of the and gate
		  InputA_In => s_PCAdderOut, -- have to check if this is working properly
		  InputB_In => s_branchAdderOut, --adder output 
		  Output_Out => s_ANDsignalMuxOut;
    );

  MUXJumpSelectSignal: NBit_2t1Mux
    generic map(N => 32);
    port map(
      InputSelect_Signal => s_Jump,--from control unit
		  InputA_In => s_JumpAddress,--think I figured out figured out concatonation
		  InputB_In => s_ANDsignalMuxOut,
		  Output_Out => s_JumpSignalMuxOut
    );

  MUXJrSelectSignal: NBit_2t1Mux
    generic map(N => 32);
    port map(
      InputSelect_Signal => s_Jr,--from control unit
		  InputA_In => s_Read1,
		  InputB_In => s_JumpSignalMuxOut,
		  Output_Out => s_NextInstAddr
    );





end structure;

