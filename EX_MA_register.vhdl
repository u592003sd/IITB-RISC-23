library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MA_reg is
	port(
		clock, reset, EX_MA_EN : in std_logic;
		BRANCH_IN, operand1_in, PC_IN, result_in, imm9_16_in : in std_logic_vector(15 downto 0);
		ra_in, rb_in, rc_in : in std_logic_vector(2 downto 0);
		OP_code_in: in std_logic_vector(3 downto 0);
		flags_in, CURRENT_FLAGS_IN: in std_logic_vector(1 downto 0);

		BRANCH_OUT, operand1_out, PC_OUT, result_out, imm9_16_out : out std_logic_vector(15 downto 0);
		ra_out, rb_out, rc_out : out std_logic_vector(2 downto 0);
		OP_code_out: out std_logic_vector(3 downto 0);
		flags_out, CURRENT_FLAGS_OUT: out std_logic_vector(1 downto 0)
	);
end entity;

architecture reg of EX_MA_reg is
	signal buffer_10, buffer_9, buffer_8, buffer_1, buffer_2 : std_logic_vector(15 downto 0);
	signal buffer_3, buffer_4, buffer_5 : std_logic_vector(2 downto 0);
	signal buffer_6: std_logic_vector(3 downto 0);
	signal buffer_7: std_logic_vector(1 downto 0);
	signal buffer_11: std_logic_vector(1 downto 0);
begin	
	
	buffer_10 <= BRANCH_IN when EX_MA_EN = '1';
	buffer_9 <= operand1_in when EX_MA_EN = '1';
	buffer_8 <= PC_IN when EX_MA_EN = '1';
	buffer_1 <= result_in when EX_MA_EN = '1';
    buffer_2 <= imm9_16_in when EX_MA_EN = '1';
    buffer_3 <= ra_in when EX_MA_EN = '1';
	buffer_4 <= rb_in when EX_MA_EN = '1';
    buffer_5 <= rc_in when EX_MA_EN = '1';
	buffer_6 <= OP_code_in when EX_MA_EN = '1';
    buffer_7 <= flags_in when EX_MA_EN = '1';
	buffer_11 <= CURRENT_FLAGS_IN when EX_MA_EN = '1';

	
	write: process(clock,reset)--BRANCH_IN,EX_MA_EN,operand1_in, PC_IN,result_in, imm9_16_in, ra_in, rb_in, rc_in, OP_code_in, flags_in)
    begin
		if(reset = '1') then 
			CURRENT_FLAGS_OUT <= (others => '0');
			BRANCH_OUT <= (others => '0');
			operand1_out <= (others => '0');
			PC_OUT <= (others => '0');
			result_out <= (others => '0');
			imm9_16_out <= (others => '0');
			ra_out <= (others => '0');
			rb_out <= (others => '0');
			rc_out <= (others => '0');
			OP_code_out <= (others => '0');
			flags_out <= (others => '0');

        elsif (clock'event and clock = '0') then 
			BRANCH_OUT <= buffer_10;
			operand1_out <= buffer_9; 
			PC_OUT <= buffer_8;
			result_out <= buffer_1;
			imm9_16_out <= buffer_2;
			ra_out <= buffer_3;
			rb_out <= buffer_4;
			rc_out <= buffer_5;
			OP_code_out <= buffer_6;
			flags_out <= buffer_7;
			CURRENT_FLAGS_OUT <= buffer_11;
        end if;
    end process write;
	
end architecture;