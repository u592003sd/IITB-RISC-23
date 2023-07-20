library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Muxes.all;

entity Stage5 is
    port(
            clk : in std_logic;
            reset : in std_logic;
            OPCODE_MA: in std_logic_vector(3 downto 0);
            RESULT_MA: in std_logic_vector(15 downto 0);
            operand1_MA, PC_MA, imm9_16_MA : in std_logic_vector(15 downto 0);
            ra_MA, rb_MA, rc_MA : in std_logic_vector(2 downto 0);
            flags_MA: in std_logic_vector(1 downto 0);


            OPCODE_WB: out std_logic_vector(3 downto 0);
            PC_WB, result_WB, imm9_16_WB, DM_D_OUT_WB : out std_logic_vector(15 downto 0);
            ra_WB, rb_WB, rc_WB : out std_logic_vector(2 downto 0);
            flags_WB: out std_logic_vector(1 downto 0)
        );
end entity;

architecture rtl of Stage5 is
    component data_memory is
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
    end component data_memory;

    component MUX_2x16 is 
    port(
        sel : in std_logic;
        -- input data
        P0 : in std_logic_vector(15 downto 0);
        P1: in std_logic_vector(15 downto 0);
        --output data
        outp : out std_logic_vector(15 downto 0)
    );
    end component MUX_2x16;

    signal STORE : std_logic;
	--signal DM_READ_MUX_OUT: std_logic_vector(15 downto 0);
    begin
        STORE <= ((not(OPCODE_MA(3))) and OPCODE_MA(2) and OPCODE_MA(0));        --enable only for SW and SM
        DM1: data_memory port map(
            clk => clk,
            DM_EN => STORE,
            reset => reset,
            DM_AD_IN1 => RESULT_MA,
            DM_DA_IN1 => operand1_MA,

            DM_AD_OUT1 => RESULT_MA,
            --DM_AD_OUT2 => DM_AD_OUT2,
            DM_DA_OUT1 =>  DM_D_OUT_WB
            --DM_DA_OUT2 => DM_DA_OUT2
        );
        OPCODE_WB <= OPCODE_MA;
        PC_WB <= PC_MA;
        ra_WB <= ra_MA;
        rb_WB <= rb_MA;
        rc_WB <= rc_MA;
        flags_WB <= flags_MA;
        imm9_16_WB <= imm9_16_MA;
        result_WB <= RESULT_MA;

end architecture;