library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID_reg is
	port(
		clock, reset, IF_ID_EN : in std_logic;
		instruction_in, PC_IN : in std_logic_vector(15 downto 0);
		
		instruction_out, PC_OUT : out std_logic_vector(15 downto 0)
	);
end entity;

architecture reg of IF_ID_reg is
	signal buffer_1, buffer_2: std_logic_vector(15 downto 0):= (others=>'0');
begin	
	
	buffer_1 <= instruction_in when IF_ID_EN = '1';
	buffer_2 <= PC_IN when IF_ID_EN = '1';

	write: process(clock,reset)--,IF_ID_EN,instruction_in,PC_IN)
    begin
		if(reset = '1') then 
			instruction_out <= (others => '0');
			PC_OUT <= (others => '0');
        elsif (clock'event and clock = '0') then  
            instruction_out <= buffer_1;
			PC_OUT <= buffer_2;
        end if;
    end process write;
	
end architecture;