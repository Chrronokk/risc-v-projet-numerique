library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux4 is

  port (
    a, b, c, d : in  std_logic_vector(31 downto 0);   -- entrées
    sel        : in  std_logic_vector(1 downto 0);    -- selection
    s          : out std_logic_vector(31 downto 0));  -- sortie

end entity mux4;

architecture A of mux4 is

 

begin  -- architecture A 

  combi : process (a, b, c, d, sel) is
  begin  -- process combi

 s <= (others => '0');
    case sel is
      when "00" =>
        s <= a;
      when "01" =>
        s <= b;
      when "10" =>
        s <= c;
      when others =>
        s <= d;
    end case;
  end process combi;




end architecture A;
