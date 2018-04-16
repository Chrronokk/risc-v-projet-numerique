-------------------------------------------------------------------------------
-- Title      : Decoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : decoder.vhd
-- Author     :   <antoine@localhost>
-- Company    : 
-- Created    : 2018-03-01
-- Last update: 2018-04-13
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Decodes the instruction data and generates control signals
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-01  1.0      antoine Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity decoder is

  port (code : in std_logic_vector (31 downto 0);
        clk  : in std_logic;
        rst  : in std_logic;

        --ALU control signals
        aluSel : out std_logic_vector(3 downto 0);


        --Regfile control signals
        reqRead1 : inout   std_logic;     -- Requests a read on regfile
        reqRead2 : inout   std_logic;     -- Requests a second read on regfile
        reqWrite : inout   std_logic;     -- Requests a write on regfile
        rs1      : inout std_logic_vector(4 downto 0);
        rs2      : inout std_logic_vector(4 downto 0);
        rd       : inout std_logic_vector(4 downto 0);
        selRegIn : out   std_logic;  -- Selects which signal writes into the regfile

        --Memory control signals
        mem_access : out std_logic;     -- Requests an access to the memory
        memRW      : out std_logic;     -- 0 for Read / 1 for Write
        memSize    : out std_logic_vector(1 downto 0);  -- Size of the memory access
        memSign    : out std_logic;     -- 0 if unsigned, 1 if signed


        --Unclassified control signals
        aluE1Sel : out std_logic_vector(2 downto 0);  -- Selects which signal enters E1
        aluE2Sel : out std_logic_vector(1 downto 0);  -- Selects which signal enters E2

        --Bypass control signals
        bpT1E1 : out std_logic;         -- Bypass T+1 E1 enable
        bpT1E2 : out std_logic;         -- Bypass T+1 E2 enable
        bpT2E1 : out std_logic;         -- Bypass T+2 E1 enable
        bpT2E2 : out std_logic;         -- Bypass T+2 E2 enable

        bubbleReq : out std_logic       --Requests a bubble generation

        );

end entity decoder;

-------------------------------------------------------------------------------

architecture arch of decoder is


  --Internal signals
  signal opcode     : std_logic_vector(6 downto 0);
  signal func3      : std_logic_vector(2 downto 0);
  signal jumpType   : std_logic;
  signal branchType : std_logic;
  signal loadType   : std_logic;

  signal prev_write_1 : std_logic_vector(4 downto 0);
  signal prev_write_2 : std_logic_vector(4 downto 0);
  signal loadTypePrev : std_logic;

  signal bpT2E1next : std_logic;
  signal bpT2E2next : std_logic;

begin  -- architecture str



  opcode <= code(6 downto 0);
  func3  <= code(14 downto 12);

  -- purpose: Initializes the value of rs1,rs2,rd
  -- type   : combinational
  -- inputs : opcode
  -- outputs: rs1,rs2,rd
  initReg : process (opcode)

  begin  -- process initReg
    
    if reqRead1 = '1' then
      rs1 <= code(19 downto 15);
    else
      rs1 <= "00000";
    end if;

    if reqRead2 = '1' then
      rs2 <= code(24 downto 20);
    else
      rs2 <= "00000";
    end if;

    if reqWrite = '1' then
      rd <= code (11 downto 7);
    else
      rd <= "00000";
    end if;
  end process initReg;



  decode : process(code) is             --Process combinatoire de décodage

  begin

    --Default signal values
    --Internal
    jumpType   <= '0';
    branchType <= '0';
    loadType   <= '0';

    --Regfile
    reqWrite <= '1';
    reqRead1 <= '1';
    reqRead2 <= '1';
    selRegIn <= '0';

    --ALU
    aluSel <= "0001";

    --Memory
    mem_access <= '0';
    memRW      <= '0';
    memSize    <= "01";
    memSign    <= '1';

    --Others
    aluE1Sel <= "011";
    aluE2Sel <= "00";



    --Réinitialisation des pointeurs des registres inutilises

    case opcode is

      when "1100011" =>                 --Branch type
        reqWrite   <= '0';
        branchType <= '1';
        case func3 is
          when "000" =>                 --BEQ
            aluSel <= "1001";
          when "001" =>                 --BNE
            aluSel <= "1001";
          when "100" =>                 --BLT
            aluSel <= "1011";
          when "101" =>                 --BGE
            aluSel <= "1010";
          when "110" =>                 --BLTU
            aluSel <= "1101";
          when "111" =>                 --BGEU
            aluSel <= "1100";
          when others =>
            null;
        end case;
        
      when "1101111" =>                 --JAL
        jumpType <= '1';
        aluSel   <= "0000";
        reqRead1 <= '0';
        reqRead2 <= '0';
        aluE1Sel <= "010";
      when "1100111" =>                 --JALR
        jumpType <= '1';
        aluSel   <= "1110";
        reqRead2 <= '0';
        aluE1Sel <= "010";
      when "0110111" =>                 --LUI
        aluSel   <= "0000";
        reqRead1 <= '0';
        reqRead2 <= '0';
        aluE2Sel <= "01";
      when "0010111" =>                 --AUIPC
        reqRead1 <= '0';
        reqRead2 <= '0';
        aluE1Sel <= "001";
        aluE2Sel <= "01";
        
      when "0000011" =>                 --Load type
        LoadType   <= '1';
        reqRead2   <= '0';
        aluE1Sel   <= "101";
        mem_access <= '1';
        selRegIn   <= '1';
        case func3 is
          when "000" =>                 --LB
          when "001" =>                 --LH
            memSize <= "10";
          when "010" =>                 --LW
            memSize <= "11";
          when "100" =>                 --LBU
            memSign <= '0';
          when "101" =>                 --LHU
            memSize <= "10";
            memSign <= '0';
          when others =>
            null;
        end case;
        
      when "0100011" =>                 --Store type
        reqWrite   <= '0';
        aluE1Sel   <= "100";
        mem_access <= '1';
        memRW      <= '1';
        case func3 is
          when "000" =>                 -- SB
          when "001" =>                 -- SH
            memSize <= "10";
          when "010" =>                 -- SW
            memSize <= "11";
          when others =>
            null;
        end case;
        
      when "0010011" =>                 --I_imm type
        reqRead2 <= '0';
        case func3 is
          when "000" =>                 -- ADDI
            aluE1Sel <= "101";
          when "001" =>                 -- SLLI
            aluSel   <= "0110";
            aluE2Sel <= "01";
          when "010" =>                 -- SLTI
            aluSel   <= "1011";
            aluE1Sel <= "001";
          when "011" =>                 -- SLTIU
            aluSel   <= "1101";
            aluE1Sel <= "001";
          when "100" =>                 -- XORI
            aluSel   <= "0101";
            aluE1Sel <= "001";
          when "101" =>
            aluE2Sel <= "01";
            if code(30) = '0' then      --SRLI
              aluSel <= "0111";
            else                        --SRAI
              aluSel <= "1000";
            end if;
            
          when "110" =>                 -- ORI
            aluSel   <= "0100";
            aluE1Sel <= "001";
          when "111" =>                 -- ANDI
            aluSel   <= "0011";
            aluE1Sel <= "001";
          when others =>
            null;
        end case;
      when "0110011" =>                 --Register type
        case func3 is
          when "000" =>
            if code(30) = '0' then      --ADD
              else                      --SUB
                     aluSel <= "0010";
            end if;
          when "001" =>                 --SLL
            aluSel <= "0110";
          when "010" =>                 --SLT
            aluSel <= "1011";
          when "011" =>                 --SLTU
            aluSel <= "1101";
          when "100" =>                 --XOR
            aluSel <= "0101";
          when "101" =>
            if code(30) = '0' then      --SRL
              aluSel <= "0111";
            else                        --SRA
              aluSel <= "1000";
            end if;
          when "110" =>                 --OR
            aluSel <= "0100";
          when "111" =>                 --AND
            aluSel <= "0011";
          when others =>
            null;
        end case;
        -- Rajouter les syscalls

      when others =>
        null;
    end case;
  end process decode;



                                        -- purpose: Inserts a bubble into the pipeline if necessary
                                        -- type   : sequential
                                        -- inputs : clk, rst
                                        -- outputs: 
  bubbleGen : process (clk, rst) is
  begin  -- process bubbleGen
    if rst = '0' then                   -- asynchronous reset (active low)

    elsif clk'event and clk = '1' then  -- rising clock edge
                                        --Jump or Branch instruction
      if jumpType = '1' or branchType = '1' then
        bubbleReq <= '1';
      else
        bubbleReq <= '0';
      end if;
                                        --
                                        --TODO: Other bubble-generating issues
                                        --
    end if;
  end process bubbleGen;


                                        -- purpose: Send control signals to bypasses
                                        -- type   : sequential
                                        -- inputs : clk, rst
                                        -- outputs: bpTiEj
  bypass_command : process (clk, rst) is
  begin  -- process bypass_command
    if rst = '0' then                   -- asynchronous reset (active low)

    elsif clk'event and clk = '1' then  -- rising clock edge


                                        --Updating the registers
      prev_write_2 <= prev_write_1;
      prev_write_1 <= rd;

      loadTypePrev <= loadType;


      if rs1 = prev_write_1 then
        bpT1E1 <= '1';
      else
        bpT1E1 <= '0';
      end if;

      if rs2 = prev_write_1 then
        bpT1E2 <= '1';
      else
        bpT1E2 <= '0';
      end if;

      if rs1 = prev_write_2 or bpT2E1next = '1' then
        bpT2E1 <= '1';
      else
        bpT2E1 <= '0';
      end if;

      if rs2 = prev_write_2 or bpT2E2next = '1' then
        bpT2E2 <= '1';
      else
        bpT2E2 <= '0';
      end if;

      if loadTypePrev = '1' then

        if rs1 = prev_write_2 then
          bpT2E1next <= '1';
        else
          bpT2E1next <= '0';
        end if;

        if rs2 = prev_write_2 then
          bpT2E2next <= '1';
        else
          bpT2E2next <= '0';
        end if;
        
      end if;
      
    end if;
  end process bypass_command;
end arch;
