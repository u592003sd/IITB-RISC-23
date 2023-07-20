library ieee;
use ieee.std_logic_1164.all;

entity PC_adder is
    port (
        PC_A: in std_logic_vector(15 downto 0);
        PC_B: in std_logic_vector(15 downto 0);
        PC_C: out std_logic_vector(15 downto 0)
    );
end PC_adder;

architecture a1 of PC_adder is
	signal op1 : std_logic_vector(15 downto 0);
	signal x : std_logic := '0';
    signal C_init : std_logic := '0';
begin
	pc : process( PC_A, PC_B,C_init)
	begin
        C_init<='0';
        for i in 0 to 15 loop
        op1(i)<= PC_A(i) XOR PC_B(i) XOR C_init;
        C_init <= ( PC_A(i) AND PC_B(i) ) OR (C_init AND (PC_A(i) XOR PC_B(i)));
        end loop;
		PC_C <= op1;
	end process ;
end a1 ;