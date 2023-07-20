library ieee;
use ieee.std_logic_1164.all;

entity Stage6 is
    port(
        clk : in std_logic;
        reset : in std_logic;
        PC_PLUS_2, PC_WB, result_WB, imm9_16_WB, DM_D_OUT_WB : IN std_logic_vector(15 downto 0);
        ra_WB, rb_WB, rc_WB : in std_logic_vector(2 downto 0);
        OPCODE_WB: in std_logic_vector(3 downto 0);
        flags_WB: in std_logic_vector(1 downto 0);
        Condition_WB: in std_logic_vector(1 downto 0);

        RF_AD_WB_RR: out std_logic_vector(2 downto 0);
        RF_DA_WB_RR: out std_logic_vector(15 downto 0)
        );
end entity;

architecture rtl of Stage6 is
    signal AND_NAND_EN : std_logic;
    
    begin

        --DATA MUX
        process(clk, reset,OPCODE_WB)
        begin
            if (OPCODE_WB(3 downto 1)="110") then
                RF_DA_WB_RR <= PC_PLUS_2;
            elsif(OPCODE_WB="0100" OR OPCODE_WB = "0110") then
                RF_DA_WB_RR <= DM_D_OUT_WB;
            elsif(OPCODE_WB="0011") then
                RF_DA_WB_RR <= imm9_16_WB;
            else
                RF_DA_WB_RR <= result_WB;
            end if;
        end process;
        
        --ADDRESS MUX
        process(clk, reset,OPCODE_WB, Condition_WB)
        begin
            AND_NAND_EN <= ((Condition_WB(1) XNOR Condition_WB(0)) OR ((not Condition_WB(1)) AND ((not Condition_WB(0)) OR flags_WB(0))));
            if (((OPCODE_WB="0001") OR (OPCODE_WB="0010")) AND (AND_NAND_EN='1')) then
                RF_AD_WB_RR <= rc_WB;
            elsif(OPCODE_WB="0100") then
                RF_AD_WB_RR <= rb_WB;
            elsif((OPCODE_WB="0011") OR (OPCODE_WB = "0100")) then
                RF_AD_WB_RR <= ra_WB;
            else
                RF_AD_WB_RR <= "000";
            end if;
        end process;
end architecture;