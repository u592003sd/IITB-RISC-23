library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compliment is
	port(
		inp : in std_logic_vector(15 downto 0);
        outp : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of compliment is
begin	
	comp:process(inp)
	begin
    for i in 0 to 15 loop
        outp(i) <= not inp(i);
    end loop;
	 end process;
end architecture;