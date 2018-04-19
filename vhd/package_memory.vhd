library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package programme is

  type   B32 is array (0 to 7) of std_logic_vector(31 downto 0);  -- mémoire interne
  constant prog : B32 := ("00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000");                -- mémoire

  constant nop : std_logic_vector(31 downto 0) := (others => '0');
end programme;
