library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multi_FLOP is
    port(
        clk : in std_logic;
        en : in std_logic;
        
        ov_flag_out : out std_logic;
        x_out  : out integer range 0 to 8
    );
end entity;

architecture rtl of Multi_FLOP is
    signal x : integer range -1 to 8 := 0;
	 signal ov_flag : std_logic;
    --signal bub : integer range 0 to 8;
begin
    process(clk)
    begin
        if(en = '1' and ov_flag='0') then
            x<=-1;
            end if;
        if (clk'event and clk='1' and (ov_flag = '1')) then
            x <= x + 1;
        else 
            x <= x;
        end if;
    end process;        --END PROCESS IF THE X REACHES 8.
    ov_flag <= '0' when x=8 else '1';
	ov_flag_out<=ov_flag;
    
    x_out <= x;
end architecture;

