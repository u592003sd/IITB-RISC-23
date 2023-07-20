library ieee;
use ieee.std_logic_1164.all;

entity Stage3 is
    port(
        clk : in std_logic;
        reset : in std_logic;
        OPCODE_RR: in std_logic_vector(3 downto 0);
        RA_RR: in std_logic_vector(2 downto 0);
        RB_RR: in std_logic_vector(2 downto 0);
        RC_RR: in std_logic_vector(2 downto 0);
        IMM6_RR : in std_logic_vector(5 downto 0);
        IMM9_16_RR, PC_RR: in std_logic_vector(15 downto 0);
        COMP_RR : in std_logic;
        PC_NEXT_IN: in std_logic_vector(15 downto 0);
        CONDITION_RR: in std_logic_vector(1 downto 0);
        WB_AD: in std_logic_vector(2 downto 0);
        WB_DA: in std_logic_vector(15 downto 0);
		RF_WR: in std_logic;

        RA_A_EX: out std_logic_vector(2 downto 0);
        RB_A_EX: out std_logic_vector(2 downto 0);
        RC_A_EX: out std_logic_vector(2 downto 0);
        RA_D_EX: out std_logic_vector(15 downto 0);
        RB_D_EX: out std_logic_vector(15 downto 0);
        IMM6_EX : out std_logic_vector(5 downto 0); 
		IMM9_16_EX, PC_EX : out std_logic_vector(15 downto 0);
        COMP_EX : out std_logic;
        CONDITION_EX: out std_logic_vector(1 downto 0);
        OPCODE_EX : out std_logic_vector(3 downto 0);
        RF_D0_OUT: out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of Stage3 is
    component RF is 
    port(
        --to store the register number for each address
        RF_AD_OUT1 : in std_logic_vector(2 downto 0);
        RF_AD_OUT2 : in std_logic_vector(2 downto 0);
        RF_AD_IN : in std_logic_vector(2 downto 0);
        RF_reset: in std_logic;
       -- clk: in std_logic;
        -- input data
        RF_DA_IN : in std_logic_vector(15 downto 0);
        RF_D0_IN: in std_logic_vector(15 downto 0);
        RF_WR : in std_logic;
        --output data
        RF_DA_OUT1 : out std_logic_vector(15 downto 0);
        RF_DA_OUT2 : out std_logic_vector(15 downto 0);
        RF_D0_OUT : out std_logic_vector(15 downto 0)
    );
    end component RF;

    component MUX_4x3 is 
    port(
        --select signal
        sel : in std_logic_vector(1 downto 0);
        -- input data
        P0 : in std_logic_vector(2 downto 0);
        P1: in std_logic_vector(2 downto 0);
        P2: in std_logic_vector(2 downto 0);
        P3: in std_logic_vector(2 downto 0);
        --output data
        outp : out std_logic_vector(2 downto 0)
    );
    end component;
begin
    RF1: RF port map(
        RF_AD_OUT1 => RA_RR,
        RF_AD_OUT2 => RB_RR,
        RF_AD_IN => WB_AD,
        RF_reset => reset,
        RF_DA_IN => WB_DA,
		RF_D0_IN => PC_NEXT_IN,
        RF_WR => RF_WR,
        RF_DA_OUT1 => RA_D_EX,
        RF_DA_OUT2 => RB_D_EX,
        RF_D0_OUT => RF_D0_OUT
    );

    --PIPELINING FORWARD PASSES.
    OPCODE_EX <= OPCODE_RR;
    RA_A_EX <= RA_RR;
    RB_A_EX <= RB_RR;
    RC_A_EX <= RC_RR;
    PC_EX <= PC_RR;
    IMM6_EX <= IMM6_RR;
    IMM9_16_EX <= IMM9_16_RR;
    COMP_EX <= COMP_RR;
    CONDITION_EX <= CONDITION_RR;


end architecture;