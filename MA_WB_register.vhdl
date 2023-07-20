library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MA_WB_reg is
	port(
		clock, reset: in std_logic;
		MA_WB_EN: in std_logic;
		--BRANCH_IN, 
		PC_IN, result_in, imm9_16_in, DM_D_OUT_in : in std_logic_vector(15 downto 0);
		ra_in, rb_in, rc_in : in std_logic_vector(2 downto 0);
		OPCODE_IN: in std_logic_vector(3 downto 0);
		flags_in, CURRENT_FLAGS_IN: in std_logic_vector(1 downto 0);

		--BRANCH_OUT, 
		PC_OUT, result_out, imm9_16_out, DM_D_OUT_out : out std_logic_vector(15 downto 0);
		ra_out, rb_out, rc_out : out std_logic_vector(2 downto 0);
		OPCODE_OUT: out std_logic_vector(3 downto 0);
		flags_out, CURRENT_FLAGS_OUT: out std_logic_vector(1 downto 0)
	);
end entity;

architecture reg of MA_WB_reg is
	signal buffer_9, buffer_1, buffer_2, buffer_8 : std_logic_vector(15 downto 0);
	signal buffer_3, buffer_4, buffer_5 : std_logic_vector(2 downto 0);
	signal buffer_6: std_logic_vector(3 downto 0);
	signal buffer_7: std_logic_vector(1 downto 0);
	signal buffer_10: std_logic_vector(1 downto 0);
	
begin
	buffer_9 <= PC_IN when MA_WB_EN = '1';	
	buffer_1 <= result_in when MA_WB_EN = '1';
	buffer_2 <= imm9_16_in when MA_WB_EN = '1';
	buffer_8 <= DM_D_OUT_in when MA_WB_EN = '1';
	buffer_3 <= ra_in when MA_WB_EN = '1';
	buffer_4 <= rb_in when MA_WB_EN = '1';
	buffer_5 <= rc_in when MA_WB_EN = '1';
	buffer_6 <= OPCODE_IN when MA_WB_EN = '1';
	buffer_7 <= flags_in when MA_WB_EN = '1';
	buffer_10 <= CURRENT_FLAGS_IN when MA_WB_EN = '1';
	
	write: process(clock,reset)--,MA_WB_EN, BRANCH_IN, PC_IN, result_in, imm9_16_in, DM_D_OUT_in, ra_in, rb_in, rc_in, OPCODE_IN, flags_in)
    begin
		if(reset = '1') then 
			--BRANCH_OUT <= (OTHERS => '0');
			PC_OUT <= (others => '0');
			result_out <= (others => '0');
			imm9_16_out <= (others => '0');
			DM_D_OUT_out <= (others => '0');
			ra_out <= (others => '0');
			rb_out <= (others => '0');
			rc_out <= (others => '0');
			OPCODE_OUT <= (others => '0');
			flags_out <= (others => '0');
			CURRENT_FLAGS_OUT <= (others => '0');

		elsif (clock'event and clock = '0') then  
			--BRANCH_OUT <= buffer_10;
			PC_OUT <= buffer_9;
			result_out <= buffer_1;
			imm9_16_out <= buffer_2;
			DM_D_OUT_out <= buffer_8;
			ra_out <= buffer_3;
			rb_out <= buffer_4;
			rc_out <= buffer_5;
			OPCODE_OUT <= buffer_6;
			flags_out <= buffer_7;
			CURRENT_FLAGS_OUT <= buffer_10;
        end if;
    end process write;
	
end architecture;