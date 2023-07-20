library ieee;
use ieee.std_logic_1164.all;

entity Stage2 is
    port(
        clk : in std_logic;
        reset : in std_logic;
        IF_ID_OUT: in std_logic_vector(15 downto 0);
        PC_ID : in std_logic_vector(15 downto 0);

        ID_RR_IN: out std_logic_vector(15 downto 0);
        PC_RR: out std_logic_vector(15 downto 0);
        OPCODE_ID: out std_logic_vector(3 downto 0);
        RA_ID: out std_logic_vector(2 downto 0);
        RB_ID: out std_logic_vector(2 downto 0);
        RC_ID: out std_logic_vector(2 downto 0);
        CONDITION_ID: out std_logic_vector(1 downto 0);
        COMP_ID: out std_logic;
        IMM6_ID: out std_logic_vector(5 downto 0);
        IMM9_ID: out std_logic_vector(15 downto 0)
        );
end entity;


architecture rtl of Stage2 is

    begin 
    ID_RR_IN <= IF_ID_OUT;
    OPCODE_ID<=IF_ID_OUT(15 downto 12);
    RA_ID<= IF_ID_OUT(11 downto 9);
    RB_ID<= IF_ID_OUT(8 downto 6);
    RC_ID<= IF_ID_OUT(5 downto 3);
    CONDITION_ID <= IF_ID_OUT(1 downto 0);
    IMM6_ID <= IF_ID_OUT(5 downto 0);
    IMM9_ID <= "0000000" & IF_ID_OUT(8 downto 0);
    PC_RR <= PC_ID;
    COMP_ID <= IF_ID_OUT(2);
	 
end architecture;