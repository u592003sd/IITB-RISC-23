library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
    port(
        clk : in std_logic;
        DM_EN : in std_logic;
        reset : in std_logic;
        DM_AD_IN1 : in std_logic_vector(15 downto 0);
        DM_DA_IN1 : in std_logic_vector(15 downto 0);
        DM_AD_OUT1 : in std_logic_vector(15 downto 0);
        --DM_AD_OUT2 : in std_logic_vector(15 downto 0);

        DM_DA_OUT1 : out std_logic_vector(15 downto 0)
        --DM_DA_OUT2 : out std_logic_vector(15 downto 0)
        );
    
end entity;

architecture arch of data_memory is
 --build 2^16 units of 16-bit size(as it is 16 bit architecture)
type mem_array is array( 0 to 63 ) of std_logic_vector(15 downto 0);      
signal data_block : mem_array := (others => (others => '0'));             --Intruction System

begin
    memory_mod: process(clk)
    begin

        if (clk'event and clk = '0') then  
            if (DM_EN = '1') then
                data_block(to_integer(unsigned(DM_AD_IN1))) <= DM_DA_IN1;
            end if;
        end if;
    end process memory_mod;
    
    --READ LINES
    DM_DA_OUT1 <= data_block(to_integer(unsigned(DM_AD_OUT1)));
    --DM_DA_OUT2 <= data_block(to_integer(unsigned(DM_AD_OUT2)));
	 
end architecture arch;