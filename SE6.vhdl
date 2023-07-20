library ieee;
use ieee.std_logic_1164.all;

entity SE6 is
    port(
        IMM6_IN: in std_logic_vector(5 downto 0);
        IMM6_OUT: out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of SE6 is
    signal IMM6: std_logic_vector(15 downto 0);
    begin
        process(IMM6_IN)
        begin
            if IMM6_IN(5) = '1' then
                IMM6 <= (others => '1');
            else
                IMM6 <= (others => '0');
            end if;
            IMM6(4 downto 0) <= IMM6_IN(4 downto 0);
        end process;
        IMM6_OUT <= IMM6;
end architecture;