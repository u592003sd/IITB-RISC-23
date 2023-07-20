library ieee;
use ieee.std_logic_1164.all;

entity Stage1 is
    port(
        clk : in std_logic;
        reset : in std_logic;
        MA_BRANCH: in std_logic_vector(15 downto 0);
        RF_D0: in std_logic_vector(15 downto 0);
        IM_MUX_CTRL: in std_logic;
        BUBBLE_CTRL: in std_logic;

        IF_ID : out std_logic_vector(15 downto 0);
        PC_NEXT: out std_logic_vector(15 downto 0);
        PC_ID: out std_logic_vector(15 downto 0)
        );
end entity;

architecture Behavioral of Stage1 is
    
    component instruction_memory is
        port(
            IM_AD_OUT1 : in std_logic_vector(15 downto 0);
            IM_DA_OUT1 : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component  PC_adder is
        port (
            PC_A: in std_logic_vector(15 downto 0);
            PC_B: in std_logic_vector(15 downto 0);
            PC_C: out std_logic_vector(15 downto 0)
				
        );
    end component;

    component MUX_2x16 is 
    port(
        --select signal
        sel : in std_logic;
        -- input data
        P0 : in std_logic_vector(15 downto 0);
        P1: in std_logic_vector(15 downto 0);
        --output data
        outp : out std_logic_vector(15 downto 0)
    );
    end component ;

    signal PC_ADDED: std_logic_vector(15 downto 0);
    signal PC_B: std_logic_vector(15 downto 0);
    begin

    INSTR_MEM1: instruction_memory port map(
        IM_AD_OUT1 => RF_D0,
        IM_DA_OUT1 => IF_ID
    );
    PC_AD: PC_adder port map(
        PC_A => RF_D0,
        PC_B => PC_B,
        PC_C => PC_ADDED
    );
    PC_B_MUX: MUX_2x16 port map(
        sel => BUBBLE_CTRL,
        P0 => "0000000000000010",
        P1 => "0000000000000000",
        outp => PC_B    
        );
    IM_MUX: MUX_2x16 port map(
        sel => IM_MUX_CTRL,
        P0 => PC_ADDED,
        P1 => MA_BRANCH,
        outp => PC_NEXT
    );
    PC_ID <= RF_D0;

end architecture;