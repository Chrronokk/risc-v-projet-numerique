library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_VHDL;
use lib_VHDL.all;

entity Tb_memory is
end Tb_memory;

architecture A of Tb_memory is

  component memoire
    port (
      rst        : in  std_logic;       --reset
      mem_access : in  std_logic;       -- utilisation de la mémoire
      read_write : in  std_logic;       -- 0 pour read 1 pour write
      adresse    : in  std_logic_vector(3 downto 0);  -- adresse d'accès mémoire
      data_in    : in  std_logic_vector(31 downto 0);  -- données à charger dans la mémoire
      data_out   : out std_logic_vector(31 downto 0);  -- données à charger dans le registre
      size       : in  std_logic_vector(1 downto 0);  -- signal de sélection des extentions de données
      sign       : in  std_logic);      -- signal de sélection sur le signe
  end component;

--Inputs
  signal sig_rst     : std_logic                    := '1';
  signal sig_access  : std_logic                    := '0';
  signal sig_rw      : std_logic                    := '1';
  signal sig_adresse : std_logic_vector(3 downto 0);
  signal sig_in      : std_logic_vector(31 downto 0):= (others => '0');
  signal sig_size    : std_logic_vector(1 downto 0) := "00";
  signal sig_sign    : std_logic := '0';

  --Output
  signal sig_out : std_logic_vector(31 downto 0);

begin  -- Tb_memory

  Tb_memory : memoire port map (
    rst        => sig_rst,
    mem_access => sig_access,
    read_write => sig_rw,
    adresse    => sig_adresse,
    data_in    => sig_in,
    size       => sig_size,
    sign       => sig_sign,
    data_out   => sig_out);

    -- purpose: bench mémoire
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    bench : process
    begin  -- process bench
      sig_rst                 <= '0';
      wait for 100 ns;
      sig_rst                 <= '1';
      sig_access              <= '1';
      sig_in(16 downto 0)     <= "11111111111111111";
      sig_adresse(3 downto 0) <= "0000";
      wait for 100 ns;
      sig_adresse(3 downto 0) <= "0001";
      sig_size(1 downto 0)    <= "01";
      wait for 100 ns;
      sig_adresse(3 downto 0) <= "0010";
      sig_size(1 downto 0)    <= "10";
      wait for 100 ns;
      sig_rw                  <= '0';
      sig_adresse(3 downto 0) <= "0000";
      sig_size(1 downto 0)    <= "01";
      sig_sign                <= '1';
      wait for 100 ns;
      sig_sign                <= '0';
      wait for 100 ns;
      sig_size(1 downto 0)    <= "10";
      sig_sign                <= '1';
      wait for 100 ns;
      sig_sign                <= '0';
      wait for 100 ns;
      sig_access              <= '0';
      sig_rw                  <= '1';
      sig_adresse(3 downto 0) <= "0011";
      wait for 100 ns;
      
      
      
      
    end process bench;

    end A;
