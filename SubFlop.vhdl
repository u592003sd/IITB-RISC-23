library ieee;
use ieee.std_logic_1164.all;

entity sub_flop is
    port (
        clk, reset, en,set6,up: in std_logic;
		data_in: in integer range -1 to 8;
        data_out : out integer
    );
end sub_flop;

architecture arch of sub_flop is
	signal buf: integer;
    begin   
        buf <= data_in when en = '1';
        
        flop: process(clk,en,reset,data_in)
        begin
            if(reset = '1') then 
                data_out <= -1;
            --elsif (clk'event and clk = '0') then
					if(data_in = -1) then
						if (set6 ='1') then
							data_out <= 6;
                        else
                            data_out <= -1;
						end if;
					elsif(up ='1') then
                    data_out <= buf-1;
					else
					 data_out <= buf;
					end if;
            end if;
        end process flop;
    end arch ;