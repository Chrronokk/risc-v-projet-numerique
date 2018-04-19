library ieee;
use ieee.std_logic_1164.all;


entity CondTest is
  
  port (
    aluLSB : in  std_logic;
    JBsel  : in  std_logic;
    PCcom  : out std_logic
    );

end CondTest;


architecture arch of CondTest is

begin  -- arch


  testCond : process(JBsel, aluLSB)
  begin  -- process testCond

    if JBsel = '0' or aluLSB = '1' then
      PCcom <= '1';
    else
      PCcom <= '0';
    end if;
    
	end process testCond;
  end arch;
