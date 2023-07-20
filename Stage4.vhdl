library ieee;
use ieee.std_logic_1164.all;

entity Stage4 is
    port(
        --INPUTS
        clk : in std_logic;
        reset : in std_logic;
        PC_EX, OPERAND1_EX, OPERAND2_EX : in std_logic_vector(15 downto 0); 
        IMM6_EX : in std_logic_vector(5 downto 0); 
        IMM9_16_EX : in std_logic_vector(15 downto 0);
        COMP_EX : in std_logic;
        RA_EX, RB_EX, RC_EX : in std_logic_vector(2 downto 0);
        OPCODE_EX: in std_logic_vector(3 downto 0);
        CONDITION_EX: in std_logic_vector(1 downto 0);

        --OUTPUTS
        BRANCH_MA, PC_MA, OPERAND1_MA, RESULT_MA : out std_logic_vector(15 downto 0);  
        IMM9_16_MA : out std_logic_vector(15 downto 0);
        RA_MA, RB_MA, RC_MA : out std_logic_vector(2 downto 0);
        OPCODE_MA: out std_logic_vector(3 downto 0);
        CONDITION_MA, CURRENT_FLAGS: out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of Stage4 is
    
	 component ALU is
        port (
            ALU_A: in std_logic_vector(15 downto 0);
            ALU_B: in std_logic_vector(15 downto 0);
            alu_control: in std_logic;
            C_in: in std_logic;
            ALU_C: out std_logic_vector(15 downto 0);
            C_out: out std_logic;
            Z_out: out std_logic
        ) ;
    end component ALU;
    
    component SE6 is
        port(
            IMM6_IN: in std_logic_vector(5 downto 0);
            IMM6_OUT: out std_logic_vector(15 downto 0)
        );
    end component SE6;
	 
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
	end component MUX_2x16;
	
    component MUX_4x16 is 
    port(
        --select signal
        sel : in std_logic_vector(1 downto 0);
        -- input data
        P0 : in std_logic_vector(15 downto 0);
        P1: in std_logic_vector(15 downto 0);
        P2: in std_logic_vector(15 downto 0);
        P3: in std_logic_vector(15 downto 0);
        --output data
        outp : out std_logic_vector(15 downto 0)
    );

    end component MUX_4x16;

    component MUX_2x1 is 
        port(
            --select signal
            sel : in std_logic;
            -- input data
            P0 : in std_logic;
            P1: in std_logic;
            --output data
            outp : out std_logic
        );
    end component;

    component flop is
        port (
            clk, reset, en, data_in : in std_logic;
            data_out : out std_logic
        );
    end component;

    component PC_adder is
        port (
            PC_A: in std_logic_vector(15 downto 0);
            PC_B: in std_logic_vector(15 downto 0);
            PC_C: out std_logic_vector(15 downto 0)
        );
    end component;

    component compliment is
        port(
            inp : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0)
        );
    end component;

    signal RESULT : std_logic_vector(15 downto 0);
    --CTRL INPUTS
    signal ALU_CTRL : std_logic;
    signal ALU_MUX_A_CTRL: std_logic;
    signal ALU_MUX_B_CTRL: std_logic_vector(1 downto 0);
    signal CARRY_CTRL, ZERO_CTRL: std_logic;
    signal CARRY_MUX_CTRL: std_logic;
    signal BRANCH_MUX_CTRL: std_logic;
    --MUX INPUTS
    signal ALU_MUX_A_OUT, ALU_MUX_B_OUT: std_logic_vector(15 downto 0);
    signal CARRY_MUX_OUT: std_logic;
    signal ADDER_B_EX_MUX_CTRL: std_logic;
    --FLOP INPUTS
    signal CARRY_IN, ZERO_IN: std_logic;
    signal CARRY_OUT, ZERO_OUT: std_logic;
    --MUX INPUTS
    signal ADDER_EX_B: std_logic_vector(15 downto 0);
    signal ADDER_EX_OUT: std_logic_vector(15 downto 0);
    signal IMM6_16: std_logic_vector(15 downto 0);
    signal OPERAND2_COMPLIMENT: std_logic_vector(15 downto 0);
    
    begin
        ALU1 : ALU port map(
            ALU_A => ALU_MUX_A_OUT,
            ALU_B => ALU_MUX_B_OUT,
            alu_control => ALU_CTRL,
            C_in => CARRY_MUX_OUT,
            ALU_C => RESULT,
            C_out => CARRY_IN,
            Z_out => ZERO_IN
        ) ;

        ADDER_EX: PC_adder port map(
            PC_A => PC_EX,
            PC_B => ADDER_EX_B,
            PC_C => ADDER_EX_OUT
        );
			
			
        ADDER_EX_B_MUX: MUX_2x16 port map(
            sel => ADDER_B_EX_MUX_CTRL,
            P0 => ("000000000"&imm6_EX&'0'),
            P1 => (imm9_16_EX(14 downto 0)&'0'),
            outp => ADDER_EX_B
        );
		  
        BRANCH_MUX: MUX_2x16 port map(
            sel => BRANCH_MUX_CTRL,
            P0 => ADDER_EX_OUT,
            P1 => OPERAND2_EX,
            outp => BRANCH_MA
        );

        ALU_MUX_A : MUX_2x16 port map(
            sel => ALU_MUX_A_CTRL,
            P0 => OPERAND1_EX,
            P1 => IMM6_16,
            outp => ALU_MUX_A_OUT
        );

        ALU_MUX_B : MUX_4x16 port map(
            sel => ALU_MUX_B_CTRL,
            P0 => OPERAND2_EX,
            P1 => IMM6_16,
            P2 => operand2_compliment,
            P3 => "0000000000000000",
            outp => ALU_MUX_B_OUT
        );

        SIGN_EXTENDED: SE6 port map(
            IMM6_IN => IMM6_EX,
            IMM6_OUT => IMM6_16
        );

        CARRY_MUX: MUX_2x1 port map(
            sel => CARRY_MUX_CTRL,
            P0 => '0',
            P1 => CARRY_OUT,
            outp => CARRY_MUX_OUT
        );

        CARRY_FLOP: flop port map(
            clk => clk, 
            reset => reset, 
            en => CARRY_CTRL, 
            data_in => CARRY_IN,
            data_out=> CARRY_OUT
            );

        CARRY_FLOP_CONTROLLER:process(CARRY_CTRL, OPCODE_EX)
        begin
            if (OPCODE_EX="0001") then
                CARRY_CTRL <= '1';
            else
                CARRY_CTRL <= '0';
            end if;
        end process;

        ZERO_FLOP: flop port map(
            clk => clk, 
            reset => reset, 
            en => ZERO_CTRL, 
            data_in => ZERO_IN,
            data_out=> ZERO_OUT
        );
        
        ZERO_FLOP_CONTROLLER: process(OPCODE_EX, ZERO_CTRL)
        begin
            if ((OPCODE_EX="0010") OR (OPCODE_EX="0001")) then
                ZERO_CTRL <= '1';
            else
                ZERO_CTRL <= '0';
            end if;
        end process;

        complimenter: compliment port map(
            inp => OPERAND2_EX,
            outp => OPERAND2_compliment
        );

        RESULT_MA <= RESULT;
        ALU_MUX_A_CTRL <= (not OPCODE_EX(3)) AND OPCODE_EX(2) AND (not OPCODE_EX(1));
        ALU_CTRL <= OPCODE_EX(1);
        ADDER_B_EX_MUX_CTRL <= OPCODE_EX(2);
        BRANCH_MUX_CTRL <= (OPCODE_EX(3) AND OPCODE_EX(2) AND (NOT(OPCODE_EX(1))) AND OPCODE_EX(0));
        CARRY_MUX_CTRL  <= std_logic(not(OPCODE_EX(3) OR OPCODE_EX(2) OR OPCODE_EX(1)) AND OPCODE_EX(0) AND CONDITION_EX(1) and CONDITION_EX(0));
        PC_MA <= PC_EX;
        IMM9_16_MA <= IMM9_16_EX;
        RA_MA <= RA_EX;
        RB_MA <= RB_EX;
        RC_MA <= RC_EX;
        CONDITION_MA <= CONDITION_EX;
        OPCODE_MA <= OPCODE_EX;
        OPERAND1_MA <= OPERAND1_EX;
        CURRENT_FLAGS <= (CARRY_OUT & ZERO_OUT); 
		  
        ALU_MUX_B_CONTROLLER:process(OPCODE_EX,COMP_EX)
        begin
            if (std_logic(not( OPCODE_EX(0) OR OPCODE_EX(1) OR OPCODE_EX(2) OR OPCODE_EX(3)))='1') then
                ALU_MUX_B_CTRL<="01";
            elsif(OPCODE_EX(3)='1') then
                ALU_MUX_B_CTRL<="00";
            elsif(OPCODE_EX(3 downto 1) = "010") then
                ALU_MUX_B_CTRL<="00";
            elsif(OPCODE_EX(3 downto 2) = "00") then 
                if(COMP_EX='1') then
                    ALU_MUX_B_CTRL <= "00";
                else
                    ALU_MUX_B_CTRL <= "10";
                end if;
            else
                ALU_MUX_B_CTRL <= "11";
            end if;
        end process;

end architecture;