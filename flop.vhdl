library ieee;
use ieee.std_logic_1164.all;

entity flop is
    port (
        clk, reset, en, data_in : in std_logic;
        data_out : out std_logic
    );
end flop;

architecture arch of flop is
	signal buf: std_logic;
    begin   
        buf <= data_in when en = '1';
        
        flop: process(clk,en,reset,data_in)
        begin
            if(reset = '1') then 
                data_out <= '0';
            elsif (clk'event and clk = '0') then  
                data_out <= buf;
            end if;
        end process flop;
    end arch ;