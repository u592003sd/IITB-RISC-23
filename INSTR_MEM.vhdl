library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is
    port(
        IM_AD_OUT1 : in std_logic_vector(15 downto 0);
        IM_DA_OUT1 : out std_logic_vector(15 downto 0)
        );
end entity;

architecture arch of instruction_memory is
    --build 2^16 units of 16-bit size(as it is 16 bit architecture)
    
    --We have reduced this block to 64 bytes temporarily as we were running into quartus related errors.
type mem_array is array( 0 to 63 ) of std_logic_vector(7 downto 0);    

    --Program the instructions here!  
signal data_block : mem_array := (0 => "00110101", 1 => "00001111",
                                others => (others => '0'));     

begin
    --READ LINES
    IM_DA_OUT1 <= data_block(to_integer(unsigned(IM_AD_OUT1))) & data_block(to_integer(unsigned(IM_AD_OUT1))+1);

end architecture arch;