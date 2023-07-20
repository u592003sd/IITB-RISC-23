library ieee;
use ieee.std_logic_1164.all;

entity SE9 is
    port(
        IMM9_IN: in std_logic_vector(8 downto 0);
        IMM9_OUT: out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of SE9 is
    
    begin
        IMM9_OUT <= "0000000" & IMM9_IN;
end architecture;