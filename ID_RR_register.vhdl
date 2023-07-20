library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_RR_reg is
	port(
        --inputs
        clock, reset, ID_RR_EN : in std_logic;
        IMM6_IN : in std_logic_vector(5 downto 0);
        IMM9_16_IN, PC_IN: in std_logic_vector(15 downto 0);
        COMP_IN : in std_logic;
        RA_IN, RB_IN, RC_IN: in std_logic_vector(2 downto 0);
        CONDITION_IN: in std_logic_vector(1 downto 0);
        OPCODE_IN: in std_logic_vector(3 downto 0);
        M_EN: in std_logic;
        M_COUNTER: in integer range 0 to 8;
        M_M_EN: in std_logic;
        --outputs
        IMM6_OUT : out std_logic_vector(5 downto 0); 
        IMM9_16_OUT, PC_OUT : out std_logic_vector(15 downto 0);
        COMP_OUT : out std_logic;
        RA_OUT, RB_OUT, RC_OUT: out std_logic_vector(2 downto 0);
        CONDITION_OUT: out std_logic_vector(1 downto 0);
        OPCODE_OUT: out std_logic_vector(3 downto 0)
	);
end entity;

architecture reg of ID_RR_reg is
    signal buffer_1 : std_logic_vector(5 downto 0);
    signal buffer_2, buffer_9: std_logic_vector(15 downto 0);
    signal buffer_3 : std_logic;
    signal buffer_4, buffer_5, buffer_6: std_logic_vector(2 downto 0);
    signal buffer_7: std_logic_vector(1 downto 0);
    signal buffer_8: std_logic_vector(3 downto 0); 

	 begin	
	
    buffer_1 <= IMM6_IN when ID_RR_EN = '1';
    buffer_2 <= IMM9_16_IN  when ID_RR_EN = '1';
    buffer_9 <= PC_IN when ID_RR_EN = '1';
    buffer_3 <= COMP_IN when ID_RR_EN = '1';
    buffer_4 <= RA_IN when ID_RR_EN = '1';
    buffer_5 <= RB_IN when ID_RR_EN = '1';
    buffer_6 <= RC_IN when ID_RR_EN = '1';
    buffer_7 <= CONDITION_IN when ID_RR_EN = '1';
    buffer_8 <= OPCODE_IN when ID_RR_EN = '1';

	write: process(clock,reset)--,ID_RR_EN,IMM6_IN,IMM9_16_IN,PC_IN,COMP_IN,RA_IN,RB_IN,RC_IN,CONDITION_IN,OPCODE_IN)
    begin
		if(reset = '1') then 
            IMM6_OUT <= (others => '0');
            PC_OUT <= (OTHERS => '0');
            IMM9_16_OUT <= (others => '0');
            COMP_OUT <='0';
            RA_OUT <= (others => '0');
            RB_OUT <= (others => '0');
            RC_OUT <= (others => '0');
            CONDITION_OUT <= (others => '0');
            OPCODE_OUT <= (others => '0');
        elsif (clock'event and clock = '0') then 
            if (M_EN='0') then 
                IMM6_OUT <= buffer_1;
                IMM9_16_OUT <= buffer_2;
                PC_OUT <= buffer_9;
                COMP_OUT <= buffer_3;
                RA_OUT <= buffer_4;
                RB_OUT <= buffer_5;
                RC_OUT <= buffer_6;
                CONDITION_OUT <= buffer_7;
                OPCODE_OUT <= buffer_8;
            elsif(M_EN='1')then
                if (M_M_EN='1') then
                    IMM6_OUT <= std_logic_vector(to_unsigned(M_COUNTER, IMM6_OUT'length));
                    IMM9_16_OUT <=  (OTHERS => '0');
                    PC_OUT <=  (OTHERS => '0');
                    COMP_OUT <= '0';
                    RA_OUT <= std_logic_vector(to_unsigned(M_COUNTER, RA_OUT'length));
                    RB_OUT <= buffer_4;
                    RC_OUT <= (others => '0'); 
                    CONDITION_OUT <= (others => '0');
                    if (buffer_8 = "0110") then
                        OPCODE_OUT <= "0100";
                    elsif(buffer_8 = "0111") then
                        OPCODE_OUT <= "0101";
                    end if;
                elsif (M_M_EN='0') then
                    IMM6_OUT <= (others => '0');
                    PC_OUT <= (OTHERS => '0');
                    IMM9_16_OUT <= (others => '0');
                    COMP_OUT <='0';
                    RA_OUT <= (others => '0');
                    RB_OUT <= (others => '0');
                    RC_OUT <= (others => '0');
                    CONDITION_OUT <= (others => '0');
                    OPCODE_OUT <= (others => '0');
                end if;
            end if;
        end if;
    end process write;
	
end architecture;