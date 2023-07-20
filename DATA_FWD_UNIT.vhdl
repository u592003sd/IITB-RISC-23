library ieee;
use ieee.std_logic_1164.all;

entity DATA_FWD_UNIT is
    port(
        clk: in std_logic;
        OPCODE_RR_STAGE, OPCODE_EX_STAGE, OPCODE_MA_STAGE, OPCODE_WB_STAGE : in std_logic_vector(3 downto 0);
        RA_RR_STAGE, RB_RR_STAGE, RC_RR_STAGE : in std_logic_vector(2 downto 0);
        RA_EX_STAGE, RB_EX_STAGE, RC_EX_STAGE : in std_logic_vector(2 downto 0);
        RA_MA_STAGE, RB_MA_STAGE, RC_MA_STAGE : in std_logic_vector(2 downto 0);
        RA_WB_STAGE, RB_WB_STAGE, RC_WB_STAGE : in std_logic_vector(2 downto 0);

        FWD_A_MUX_CTRL: out std_logic_vector(1 downto 0);
        FWD_B_MUX_CTRL: out std_logic_vector(1 downto 0)
    );
end entity;

architecture arch of DATA_FWD_UNIT is
    signal S_EN,T_EN: std_logic:='0';
    signal RR_S, RR_T : std_logic_vector(2 downto 0);
    signal EX_D, MA_D, WB_D : std_logic_vector(2 downto 0);
    signal EX_D_EN,MA_D_EN,WB_D_EN:std_logic;
begin
    RR_determine_source: process(OPCODE_RR_STAGE,RA_RR_STAGE, RB_RR_STAGE, RC_RR_STAGE)
    begin
        if(OPCODE_RR_STAGE(2) = '0' AND (OPCODE_RR_STAGE /= "0011")) then
            RR_S <= RA_RR_STAGE;
            S_EN<='1';
        elsif (OPCODE_RR_STAGE="0101" OR OPCODE_RR_STAGE="1111") then
            RR_S <= RA_RR_STAGE;
            S_EN<='1';
        elsif (OPCODE_RR_STAGE="0100" OR OPCODE_RR_STAGE="1101") then
            RR_S <= RB_RR_STAGE;
            S_EN<='1';
        else
            S_EN<='0';
        end if;
        
        if(OPCODE_RR_STAGE = "0001" OR OPCODE_RR_STAGE = "0010" OR OPCODE_RR_STAGE = "0101") then
            RR_T <= RB_RR_STAGE;
            T_EN<='1';
        elsif (OPCODE_RR_STAGE(3 downto 2) = "10") then
            RR_T <= RB_RR_STAGE;
            T_EN<='1';
        else
            T_EN<='0';
        end if;            
    end process;

    EX_determine_destination: process(OPCODE_EX_STAGE,RA_EX_STAGE, RB_EX_STAGE, RC_EX_STAGE)
    begin 
        if(OPCODE_EX_STAGE(3 downto 1) = "110" ) then
            EX_D <= RA_EX_STAGE;
        elsif (OPCODE_EX_STAGE="0100" OR OPCODE_EX_STAGE="0011") then
            EX_D <= RA_EX_STAGE;
        elsif (OPCODE_EX_STAGE="0001" OR OPCODE_EX_STAGE="0010") then
            EX_D <= RC_EX_STAGE;
        elsif (OPCODE_EX_STAGE="0000") then
            EX_D <= RB_EX_STAGE;
        else
            EX_D_EN <='0';
        end if;
    end process;
        
    MA_determine_destination: process(OPCODE_MA_STAGE,RA_MA_STAGE, RB_MA_STAGE, RC_MA_STAGE)
    begin 
        if(OPCODE_MA_STAGE(3 downto 1) = "110" ) then
            MA_D <= RA_MA_STAGE;
        elsif (OPCODE_MA_STAGE="0100" OR OPCODE_MA_STAGE="0011") then
            MA_D <= RA_MA_STAGE;
        elsif (OPCODE_MA_STAGE="0001" OR OPCODE_MA_STAGE="0010") then
            MA_D <= RC_MA_STAGE;
        elsif (OPCODE_MA_STAGE="0000") then
            MA_D <= RB_MA_STAGE;
        else
            MA_D_EN <='0';
        end if;
    end process;

    WB_determine_destination: process(OPCODE_WB_STAGE,RA_WB_STAGE, RB_WB_STAGE, RC_WB_STAGE)
    begin 
        if(OPCODE_WB_STAGE(3 downto 1) = "110" ) then
            WB_D <= RA_WB_STAGE;
        elsif (OPCODE_WB_STAGE="0100" OR OPCODE_WB_STAGE="0011") then
            WB_D <= RA_WB_STAGE;
        elsif (OPCODE_WB_STAGE="0001" OR OPCODE_WB_STAGE="0010") then
            WB_D <= RC_WB_STAGE;
        elsif (OPCODE_WB_STAGE="0000") then
            WB_D <= RB_WB_STAGE;
        else
            WB_D_EN <='0';
        end if;
    end process;
    
    FWD_A_MUX_CTRL <= "00" when (S_EN='1' AND EX_D_EN='1' AND MA_D_EN='1' AND WB_D_EN='1' AND RR_S=EX_D) else
                      "01" when (S_EN='1' AND EX_D_EN='1' AND MA_D_EN='1' AND WB_D_EN='1' AND RR_S=MA_D) else
                      "10" when (S_EN='1' AND EX_D_EN='1' AND MA_D_EN='1' AND WB_D_EN='1' AND RR_S=WB_D) else
                      "00";
                      
    FWD_B_MUX_CTRL <= "00" when (T_EN='1' AND EX_D_EN='1' AND MA_D_EN='1' AND WB_D_EN='1' AND RR_T=EX_D) else
                      "01" when (T_EN='1' AND EX_D_EN='1' AND MA_D_EN='1' AND WB_D_EN='1' AND RR_T=MA_D) else
                      "10" when (T_EN='1' AND EX_D_EN='1' AND MA_D_EN='1' AND WB_D_EN='1' AND RR_T=WB_D) else
                      "00";
end arch;