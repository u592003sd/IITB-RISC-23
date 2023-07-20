library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Muxes.all;

entity HazardUnit is
    port(
        -- Inputs
        clk: in std_logic;
        IR_S1: in std_logic_vector(15 downto 0);
        --OPCODE_S2,OPCODe_S3,OPCODE_S4,OPCODE_S5,OPCODE_S6: in std_logic_vector(3 downto 0);

        -- Outputs
        RF_WR: out std_logic;
        IF_ID_RESET: out std_logic;
        ID_RR_RESET: out std_logic;
        RR_EX_RESET: out std_logic;
        EX_MA_RESET: out std_logic;
        MA_WB_RESET: out std_logic;
        BUBBLE_CTRL: out std_logic
    );
end entity;

architecture RTL of HazardUnit is
    component DEMUX_5x1 is
        port(
            default_value: in std_logic;
            input_value: in std_logic;
            enable_signal: in std_logic;
            sel: in integer;
            P0: out std_logic;
            P1: out std_logic;
            P2: out std_logic;
            P3: out std_logic;
            P4: out std_logic;
				P5: out std_logic
            );
    end component;
	component sub_flop is
    port (
        clk, reset, en,set6,up: in std_logic;
		  data_in: in integer range -1 to 8;
        data_out : out integer
    );
	end component;

    signal stage_count: integer range -1 to 8:=-1;
	signal stage_count_next: integer :=-1;

    signal dem_en: std_logic;
	signal BUBBLE_TEMP: std_logic:='0';
    begin
        BUBBLE_BRANCH:process(clk,IR_S1)
        begin
            if (IR_S1(15 downto 13) ="110") then
                BUBBLE_TEMP<='1';
                --stage_count<= 3; 	 
            elsif(stage_count =-1) then
				BUBBLE_TEMP<='0';
			end if;
        end process;
        

        DEM: DEMUX_4x1 port map(
            default_value=>'0',
            input_value=>'1',
            enable_signal=>dem_en,
            sel=>stage_count,
            P0=>RF_WR,
            P1=>MA_WB_RESET,
            P2=>EX_MA_RESET,
            P3=>RR_EX_RESET,
            P4=>ID_RR_RESET,
            P5=>IF_ID_RESET
        );

        dem_en<=(not clk) and BUBBLE_TEMP;
			sub_f: sub_flop port map(
				clk => clk, 
				reset=> not dem_en,
				en=> '1',
				set6 => BUBBLE_TEMP,
                up=> dem_en, 
				data_in => stage_count, 
				data_out => stage_count);
				
		BUBBLE_CTRL<= BUBBLE_TEMP when stage_count>=0 else '0';
end architecture;