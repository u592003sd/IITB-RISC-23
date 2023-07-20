library ieee;
use ieee.std_logic_1164.all;

entity M_CONTROl_UNIT is
port(
    clk : in std_logic;
    OPCODE: in std_logic_vector(3 downto 0);
    IMM9_16: in std_logic_vector(15 downto 0);

    BUBBLE_CTRL_M: out std_logic;
    M_INDEX: out integer range 0 to 8;
    M_M_EN: out std_logic
);
end M_CONTROl_UNIT;

architecture Behavioral of M_CONTROl_UNIT is
    component Multi_FLOP is
        port(
            clk : in std_logic;
            en : in std_logic;
            ov_flag_out: out std_logic;
            x_out  : out integer range 0 to 8
        );
    end component;
    
    signal BUB_TEMP: std_logic;
    signal EN_SIGNAL: std_logic;
    signal x: integer range 0 to 8:=8;
begin
        counter: Multi_FLOP port map(
            clk => clk,
            en => EN_SIGNAL,
            
            ov_flag_out => BUB_TEMP,
            x_out  => x
        );
        
        EN_SIGNAL <='1' when OPCODE(3 downto 1) ="011" else '0'; 
        BUBBLE_CTRL_M <= BUB_TEMP AND EN_SIGNAL;
        M_M_En <= IMM9_16(x);
        M_INDEX <= x;

end Behavioral;