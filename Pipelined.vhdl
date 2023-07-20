library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Muxes.all;

entity pipelined is
    port (
        clk : in std_logic;
        reset : in std_logic
    );
end entity;

architecture rtl of pipelined is

    component Stage1 is
        port(
            clk : in std_logic;
            reset : in std_logic;
            MA_BRANCH: in std_logic_vector(15 downto 0);
            RF_D0: in std_logic_vector(15 downto 0);
            IM_MUX_CTRL: in std_logic;
            BUBBLE_CTRL: in std_logic;
            
            IF_ID : out std_logic_vector(15 downto 0);
            PC_NEXT: out std_logic_vector(15 downto 0);
            PC_ID: out std_logic_vector(15 downto 0)
            );
    end component;

    component IF_ID_reg is
        port(
            clock, reset, IF_ID_EN : in std_logic;
            instruction_in, PC_IN : in std_logic_vector(15 downto 0);
            
            instruction_out, PC_OUT : out std_logic_vector(15 downto 0)
        );
    end component;

    component Stage2 is
        port(
            clk : in std_logic;
            reset : in std_logic;
            IF_ID_OUT: in std_logic_vector(15 downto 0);
            PC_ID : in std_logic_vector(15 downto 0);
    
            ID_RR_IN: out std_logic_vector(15 downto 0);
            PC_RR: out std_logic_vector(15 downto 0);
            OPCODE_ID: out std_logic_vector(3 downto 0);
            RA_ID: out std_logic_vector(2 downto 0);
            RB_ID: out std_logic_vector(2 downto 0);
            RC_ID: out std_logic_vector(2 downto 0);
            CONDITION_ID: out std_logic_vector(1 downto 0);
            COMP_ID: out std_logic;
            IMM6_ID: out std_logic_vector(5 downto 0);
            IMM9_ID: out std_logic_vector(15 downto 0)
            );
    end component;

    component ID_RR_reg is
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
    end component;

    component Stage3 is
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
    end component;

    component RR_EX_reg is
        port(
            clock, reset, RR_EX_EN : in std_logic;
            PC_IN, operand1_in, operand2_in : in std_logic_vector(15 downto 0); 
            imm6_in : in std_logic_vector(5 downto 0); 
            imm9_16_in : in std_logic_vector(15 downto 0);
            comp_in : in std_logic;
            ra_in, rb_in, rc_in : in std_logic_vector(2 downto 0);
            OP_code_in: in std_logic_vector(3 downto 0);
            flags_in: in std_logic_vector(1 downto 0);
    
            PC_OUT, operand1_out, operand2_out : out std_logic_vector(15 downto 0); 
            imm6_out : out std_logic_vector(5 downto 0); 
            imm9_16_out : out std_logic_vector(15 downto 0);
            comp_out : out std_logic;
            ra_out, rb_out, rc_out : out std_logic_vector(2 downto 0);
            OP_code_out: out std_logic_vector(3 downto 0);
            flags_out: out std_logic_vector(1 downto 0)
        );
    end component;

    component Stage4 is
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
            CONDITION_MA: out std_logic_vector(1 downto 0);
				CURRENT_FLAGS:out std_logic_vector(1 downto 0)
        );
    end component;

    component EX_MA_reg is
        port(
            clock, reset, EX_MA_EN : in std_logic;
            BRANCH_IN, operand1_in, PC_IN, result_in, imm9_16_in : in std_logic_vector(15 downto 0);
            ra_in, rb_in, rc_in : in std_logic_vector(2 downto 0);
            OP_code_in: in std_logic_vector(3 downto 0);
            flags_in,CURRENT_FLAGS_IN: in std_logic_vector(1 downto 0);

            BRANCH_OUT, operand1_out, PC_OUT, result_out, imm9_16_out : out std_logic_vector(15 downto 0);
            ra_out, rb_out, rc_out : out std_logic_vector(2 downto 0);
            OP_code_out: out std_logic_vector(3 downto 0);
            flags_out,CURRENT_FLAGS_OUT: out std_logic_vector(1 downto 0)
        );
    end component;

    component Stage5 is
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
    end component;

    component MA_WB_reg is
        port(
            clock, reset: in std_logic;
            MA_WB_EN: in std_logic;
            --BRANCH_IN, 
            PC_IN, result_in, imm9_16_in, DM_D_OUT_in : in std_logic_vector(15 downto 0);
            ra_in, rb_in, rc_in : in std_logic_vector(2 downto 0);
            OPCODE_IN: in std_logic_vector(3 downto 0);
            flags_in,CURRENT_FLAGS_IN: in std_logic_vector(1 downto 0);
    
            --BRANCH_OUT, 
            PC_OUT, result_out, imm9_16_out, DM_D_OUT_out : out std_logic_vector(15 downto 0);
            ra_out, rb_out, rc_out : out std_logic_vector(2 downto 0);
            OPCODE_OUT: out std_logic_vector(3 downto 0);
            flags_out,CURRENT_FLAGS_OUT: out std_logic_vector(1 downto 0)
        );
    end component;

    component Stage6 is
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
    end component;
    
    component HazardUnit is
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
    end component;
    
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
    end component;
    
    component DATA_FWD_UNIT is
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
	 end component;
     component M_CONTROl_UNIT is
        port(
            clk : in std_logic;
            OPCODE: in std_logic_vector(3 downto 0);
            IMM9_16: in std_logic_vector(15 downto 0);
        
            BUBBLE_CTRL_M: out std_logic;
            M_INDEX: out integer range 0 to 8;
            M_M_EN: out std_logic
        );
    end component;
    --Signal Definitions
    --stage 1
    signal IF_ID_IN: std_logic_vector(15 downto 0);
    signal PC_NEXT: std_logic_vector(15 downto 0);
    signal PC_ID_IN: std_logic_vector(15 downto 0);
    signal BRANCH_MA: std_logic_vector(15 downto 0);
    --stage 1 ctrl signal
    signal IM_MUX_CTRL: std_logic;
    signal IF_ID_EN: std_logic;
    signal BUBBLE_CTRL_BRANCH: std_logic;
    signal BUBBLE_CTRL_M: std_logic;
    signal IF_ID_RESET: std_logic;
    signal M_INDEX: integer range 0 to 8;
    signal M_EN: std_logic;
    --stage2 
    signal PC_ID_OUT: std_logic_vector(15 downto 0);
    signal IF_ID_OUT: std_logic_vector(15 downto 0);
    signal ID_RR_IN : std_logic_vector(15 downto 0);
    signal PC_RR_IN: std_logic_vector(15 downto 0);
    signal OPCODE_ID: std_logic_vector(3 downto 0);
    signal RA_ID: std_logic_vector(2 downto 0);
    signal RB_ID: std_logic_vector(2 downto 0);
    signal RC_ID: std_logic_vector(2 downto 0);
    signal CONDITION_ID: std_logic_vector(1 downto 0);
    signal COMP_ID: std_logic;
    signal IMM6_ID: std_logic_vector(5 downto 0);
    signal IMM9_ID: std_logic_vector(15 downto 0);
    --stage2 ctrl signal
    signal ID_RR_EN: std_logic;
    signal ID_RR_RESET: std_logic;

    --stage3
    signal PC_RR_OUT: std_logic_vector(15 downto 0);
    signal OPCODE_RR_IN: std_logic_vector(3 downto 0);
    signal RA_RR_IN: std_logic_vector(2 downto 0);
    signal RB_RR_IN: std_logic_vector(2 downto 0);
    signal RC_RR_IN: std_logic_vector(2 downto 0);
    signal IMM6_RR_IN : std_logic_vector(5 downto 0);
    signal IMM9_16_RR_IN: std_logic_vector(15 downto 0);
    signal COMP_RR_IN :std_logic;
    signal PC_NEXT_IN: std_logic_vector(15 downto 0);
    signal CONDITION_RR_IN: std_logic_vector(1 downto 0);
    signal WB_AD:  std_logic_vector(2 downto 0);
    signal WB_DA:  std_logic_vector(15 downto 0);
    signal RF_WR: std_logic;

    signal OPCODE_RR_OUT: std_logic_vector(3 downto 0);
    signal RA_A_RR_OUT:  std_logic_vector(2 downto 0);
    signal RB_A_RR_OUT:  std_logic_vector(2 downto 0);
    signal RC_A_RR_OUT: std_logic_vector(2 downto 0);
    signal IMM6_RR_OUT : std_logic_vector(5 downto 0);
    signal IMM9_16_RR_OUT:  std_logic_vector(15 downto 0);
    signal COMP_RR_OUT :  std_logic;
    signal CONDITION_RR_OUT:  std_logic_vector(1 downto 0);
	signal RA_D_RR_OUT:  std_logic_vector(15 downto 0);
	signal RB_D_RR_OUT:  std_logic_vector(15 downto 0);

    --stage4
    signal RA_A_EX_IN: std_logic_vector(2 downto 0);
    signal RB_A_EX_IN: std_logic_vector(2 downto 0);
    signal RC_A_EX_IN: std_logic_vector(2 downto 0);
    signal RA_D_EX_IN: std_logic_vector(15 downto 0);
    signal RB_D_EX_IN: std_logic_vector(15 downto 0);
    signal IMM6_EX_IN : std_logic_vector(5 downto 0); 
    signal IMM9_16_EX_IN, PC_EX_IN : std_logic_vector(15 downto 0);
    signal COMP_EX_IN : std_logic;
    signal CONDITION_EX_IN: std_logic_vector(1 downto 0);
    signal OPCODE_EX_IN : std_logic_vector(3 downto 0);
    signal RF_D0_OUT: std_logic_vector(15 downto 0);
    signal PC_EX_OUT: std_logic_vector(15 downto 0);

    signal RA_A_EX: std_logic_vector(2 downto 0);
    signal RB_A_EX: std_logic_vector(2 downto 0);
    signal RC_A_EX: std_logic_vector(2 downto 0);
    signal RA_D_EX: std_logic_vector(15 downto 0);
    signal RB_D_EX: std_logic_vector(15 downto 0);
    signal IMM6_EX : std_logic_vector(5 downto 0); 
    signal IMM9_MA_IN : std_logic_vector(15 downto 0);
    signal COMP_EX : std_logic;
    signal CONDITION_EX: std_logic_vector(1 downto 0);
    --signal FLAGS_MA_IN:std_logic_vector(1 downto 0);
    --signal FLAGS_MA_OUT:std_logic_vector(1 downto 0);
    signal OPCODE_EX : std_logic_vector(3 downto 0);
    --stage4 ctrl
    signal RR_EX_EN: std_logic;
    signal RR_EX_RESET: std_logic;


    --stage5
    signal BRANCH_MA_IN: std_logic_vector(15 downto 0);
    signal PC_MA_IN: std_logic_vector(15 downto 0);
    signal OPERAND1_MA_IN: std_logic_vector(15 downto 0);
    signal RESULT_MA_IN: std_logic_vector(15 downto 0);
    signal IMM9_16_MA_IN : std_logic_vector(15 downto 0);
    signal RA_MA_IN, RB_MA_IN, RC_MA_IN : std_logic_vector(2 downto 0);
    signal OPCODE_MA_IN: std_logic_vector(3 downto 0);
    signal CONDITION_MA_IN: std_logic_vector(1 downto 0);

    signal PC_MA_OUT: std_logic_vector(15 downto 0);
    signal OPERAND1_MA_OUT: std_logic_vector(15 downto 0);
    signal RESULT_MA_OUT: std_logic_vector(15 downto 0);
    signal IMM9_16_MA_OUT : std_logic_vector(15 downto 0);
    signal RA_MA_OUT, RB_MA_OUT, RC_MA_OUT : std_logic_vector(2 downto 0);
    signal OPCODE_WB_OUT: std_logic_vector(3 downto 0);
    signal CONDITION_WB_OUT: std_logic_vector(1 downto 0);
    signal FLAGS_MA_IN:std_logic_vector(1 downto 0);
    signal FLAGS_MA_OUT:std_logic_vector(1 downto 0);
	 signal CONDITION_MA_OUT: std_logic_vector(1 downto 0);
	 signal OPCODE_MA_OUT: std_logic_vector(3 downto 0);
	 signal FLAGS_WB_IN: std_logic_vector(1 downto 0);
    --stage5 ctrl
    signal EX_MA_EN: std_logic;
    signal EX_MA_RESET: std_logic;

    --stage6
    signal PC_WB_IN: std_logic_vector(15 downto 0);
    signal DM_D_OUT_WB_IN: std_logic_vector(15 downto 0);
    signal RESULT_WB_IN: std_logic_vector(15 downto 0);
    signal IMM9_16_WB_IN : std_logic_vector(15 downto 0);
    signal RA_WB_IN, RB_WB_IN, RC_WB_IN : std_logic_vector(2 downto 0);
    signal OPCODE_WB_IN: std_logic_vector(3 downto 0);
    signal CONDITION_WB_IN: std_logic_vector(1 downto 0);
    
    signal PC_WB_OUT: std_logic_vector(15 downto 0);
    signal DM_D_OUT_WB_OUT: std_logic_vector(15 downto 0);
    signal RESULT_WB_OUT: std_logic_vector(15 downto 0);
    signal IMM9_16_WB_OUT : std_logic_vector(15 downto 0);
    signal RA_WB_OUT, RB_WB_OUT, RC_WB_OUT : std_logic_vector(2 downto 0);

    signal WRITE_BACK_ADDRESS: std_logic_vector(2 downto 0);
    signal WRITE_BACK_DATA: std_logic_vector(15 downto 0);

    --stage6 ctrl
    signal MA_WB_EN: std_logic;
    signal MA_WB_RESET: std_logic;

    --DATA FORWARDING UNIT RELATED SIGNALS:
    signal RA_MUX_DFU_CTRL, RB_MUX_DFU_CTRL : std_logic_vector(1 downto 0);
    signal RA_MUX_DFU_OUT, RB_MUX_DFU_OUT : std_logic_vector(15 downto 0);
begin

    Stage11: Stage1 port map(
        clk => clk,
        reset => reset,
        MA_BRANCH => BRANCH_MA,
        RF_D0 => RF_D0_OUT,
        IM_MUX_CTRL => IM_MUX_CTRL,
        BUBBLE_CTRL=> BUBBLE_CTRL_BRANCH OR BUBBLE_CTRL_M ,
        IF_ID => IF_ID_IN,
        PC_NEXT => PC_NEXT,
        PC_ID => PC_ID_IN
    );
    IF_ID: IF_ID_reg port map(
            clock => clk, 
            reset =>  IF_ID_RESET,
            IF_ID_EN => IF_ID_EN,
            instruction_in => IF_ID_IN, 
            PC_IN => PC_ID_IN,
            
            instruction_out => IF_ID_OUT, 
            PC_OUT => PC_ID_OUT
        );

    Stage21: Stage2 port map(
        clk => clk,
        reset => reset,
        IF_ID_OUT => IF_ID_OUT,
        PC_ID => PC_ID_OUT,
        
        ID_RR_IN => ID_RR_IN,
        PC_RR => PC_RR_IN,
        OPCODE_ID => OPCODE_ID,
        RA_ID => RA_ID,
        RB_ID => RB_ID,
        RC_ID => RC_ID,
        CONDITION_ID => CONDITION_ID,
        COMP_ID => COMP_ID,
        IMM6_ID => IMM6_ID,
        IMM9_ID => IMM9_ID
    );

    ID_RR: ID_RR_reg port map(
        clock => clk,
        reset => ID_RR_RESET,
        ID_RR_EN => ID_RR_EN,
        IMM6_IN => IMM6_ID,
        IMM9_16_IN => IMM9_ID,
        PC_IN => PC_RR_IN,
        COMP_IN => COMP_ID,
        RA_IN => RA_ID,
        RB_IN => RB_ID,
        RC_IN => RC_ID,
        CONDITION_IN => CONDITION_ID,
        OPCODE_IN => OPCODE_ID,
        M_EN => BUBBLE_CTRL_M,
        M_COUNTER=> M_INDEX,
        M_M_EN=> M_EN,

        IMM6_OUT => IMM6_RR_IN,
        IMM9_16_OUT => IMM9_16_RR_IN,
        PC_OUT => PC_RR_OUT,
        COMP_OUT => COMP_RR_IN,
        RA_OUT => RA_RR_IN,
        RB_OUT => RB_RR_IN,
        RC_OUT => RC_RR_IN,
        CONDITION_OUT => CONDITION_RR_IN,
        OPCODE_OUT => OPCODE_RR_IN
    );

    Stage31: Stage3 port map(
        clk => clk,
        reset => reset,
        OPCODE_RR => OPCODE_RR_IN,
        RA_RR => RA_RR_IN,
        RB_RR => RB_RR_IN,
        RC_RR => RC_RR_IN,
        IMM6_RR => IMM6_RR_IN,
        IMM9_16_RR => IMM9_16_RR_IN,
        PC_RR => PC_RR_OUT,
        COMP_RR => COMP_RR_IN,
        PC_NEXT_IN => PC_NEXT,
        CONDITION_RR => CONDITION_RR_IN,
        WB_AD => wRITE_BACK_ADDRESS,
        WB_DA => WRITE_BACK_DATA,
        RF_WR => RF_WR ,

        RA_A_EX => RA_A_RR_OUT,
        RB_A_EX => RB_A_RR_OUT,
        RC_A_EX => RC_A_RR_OUT,
        RA_D_EX => RA_D_RR_OUT,
        RB_D_EX => RB_D_RR_OUT,
        IMM6_EX => IMM6_RR_OUT,
        IMM9_16_EX => IMM9_16_RR_OUT,
        PC_EX => PC_EX_IN,
        COMP_EX => COMP_RR_OUT,
        CONDITION_EX => CONDITION_RR_OUT,
        OPCODE_EX => OPCODE_RR_OUT,
        RF_D0_OUT => RF_D0_OUT
    );

    RR_EX: RR_EX_reg port map(
        clock => clk,
        reset => RR_EX_RESET,
        RR_EX_EN => RR_EX_EN,
        IMM6_IN => IMM6_RR_OUT,
        IMM9_16_IN => IMM9_16_RR_OUT,
        PC_IN => PC_EX_IN,
        operand1_in => RA_D_RR_OUT,
        operand2_in => RB_D_RR_OUT,
        comp_in => COMP_RR_OUT,
        ra_in => RA_A_RR_OUT,
        rb_in => RB_A_RR_OUT,
        rc_in => RC_A_RR_OUT,
        OP_code_in => OPCODE_RR_OUT,
        flags_in => CONDITION_RR_OUT,

        PC_OUT => PC_EX_OUT,
        operand1_out => RA_D_EX_IN,
        operand2_out => RB_D_EX_IN,
        imm6_out => IMM6_EX_IN,
        imm9_16_out => IMM9_16_EX_IN,
        comp_out => COMP_EX_IN,
        ra_out => RA_A_EX_IN,
        rb_out => RB_A_EX_IN,
        rc_out => RC_A_EX_IN,
        OP_code_out => OPCODE_EX_IN,
        flags_out => CONDITION_EX_IN
    );

    stage41: Stage4 port map(
        clk => clk,
        reset => reset,
        PC_EX => PC_EX_OUT,
        OPERAND1_EX => RA_MUX_DFU_OUT,
        OPERAND2_EX => RB_MUX_DFU_OUT,
        IMM6_EX => IMM6_EX_IN,
        IMM9_16_EX => IMM9_16_EX_IN,
        COMP_EX => COMP_EX_IN,
        RA_EX => RA_A_EX_IN,
        RB_EX => RB_A_EX_IN,
        RC_EX => RC_A_EX_IN,
        OPCODE_EX => OPCODE_EX_IN,
        CONDITION_EX => CONDITION_EX_IN,

        BRANCH_MA => BRANCH_MA_IN,
        PC_MA => PC_MA_IN,
        OPERAND1_MA => OPERAND1_MA_IN,
        RESULT_MA => RESULT_MA_IN, 
        IMM9_16_MA => IMM9_MA_IN,
        RA_MA => RA_MA_IN,
        RB_MA => RB_MA_IN,
        RC_MA => RC_MA_IN,
        OPCODE_MA => OPCODE_MA_IN,
        CONDITION_MA => CONDITION_MA_IN,
        CURRENT_FLAGS => FLAGS_MA_IN
    );

    EX_MA: EX_MA_reg port map(
        clock => clk,
        reset => EX_MA_RESET,
        BRANCH_IN => BRANCH_MA_IN,
        EX_MA_EN => EX_MA_EN,
        PC_IN => PC_MA_IN,
        OPERAND1_IN => OPERAND1_MA_IN,
        RESULT_IN => RESULT_MA_IN,
        IMM9_16_IN => IMM9_MA_IN,
        RA_IN => RA_MA_IN,
        RB_IN => RB_MA_IN,
        RC_IN => RC_MA_IN,
        OP_code_IN => OPCODE_MA_IN,
        flags_in => CONDITION_MA_IN,
        CURRENT_FLAGS_IN => FLAGS_MA_IN,



        PC_OUT => PC_MA_OUT,
        BRANCH_OUT=>BRANCH_MA,
        OPERAND1_OUT => OPERAND1_MA_OUT,
        RESULT_OUT => RESULT_MA_OUT,
        IMM9_16_OUT => IMM9_16_MA_OUT,
        RA_OUT => RA_MA_OUT,
        RB_OUT => RB_MA_OUT,
        RC_OUT => RC_MA_OUT,
        OP_code_OUT => OPCODE_MA_OUT,
        flags_out => CONDITION_MA_OUT,
        CURRENT_FLAGS_OUT => FLAGS_MA_OUT
    );

    Stage51: Stage5 port map(
        clk => clk,
        reset => reset,
        PC_MA => PC_MA_OUT,
        operand1_MA => OPERAND1_MA_OUT,
        RESULT_MA => RESULT_MA_OUT,
        imm9_16_MA => IMM9_16_MA_OUT,
        ra_MA => RA_MA_OUT,
        rb_MA => RB_MA_OUT,
        rc_MA => RC_MA_OUT,
        OPCODE_MA => OPCODE_MA_OUT,
        flags_MA => CONDITION_MA_OUT,

        PC_WB => PC_WB_IN,
        DM_D_OUT_WB => DM_D_OUT_WB_IN,
        RESULT_WB => RESULT_WB_IN,
        imm9_16_WB => IMM9_16_WB_IN,
        ra_WB => RA_WB_IN,
        rb_WB => RB_WB_IN,
        rc_WB => RC_WB_IN,
        OPCODE_WB => OPCODE_WB_IN,
        flags_WB => CONDITION_WB_IN
    );

    MA_WB: MA_WB_reg port map(
        clock => clk,
        reset => MA_WB_RESET,
        MA_WB_EN => MA_WB_EN,
        --BRANCH_IN => ,
        PC_IN => PC_WB_IN,
        DM_D_OUT_in => DM_D_OUT_WB_IN,
        RESULT_IN => RESULT_WB_IN,
        imm9_16_IN => IMM9_16_WB_IN,
        ra_in => RA_WB_IN,
        rb_in => RB_WB_IN,
        rc_in => RC_WB_IN,
        OPCODE_IN => OPCODE_WB_IN,
        flags_in => CONDITION_WB_IN,
        CURRENT_FLAGS_IN => FLAGS_MA_OUT,

        --BRANCH_OUT => ,
        PC_OUT => PC_WB_OUT,
        DM_D_OUT_out => DM_D_OUT_WB_OUT,
        RESULT_OUT => RESULT_WB_OUT,
        imm9_16_OUT => IMM9_16_WB_OUT,
        ra_out => RA_WB_OUT,
        rb_out => RB_WB_OUT,
        rc_out => RC_WB_OUT,
        OPCODE_OUT => OPCODE_WB_OUT,
        flags_out => CONDITION_WB_OUT,
        CURRENT_FLAGS_OUT => FLAGS_WB_IN
    );

    Stage61: Stage6 port map(
        clk => clk,
        reset => MA_WB_RESET,
		PC_PLUS_2 => PC_MA_OUT,
        PC_WB => PC_WB_OUT,
        DM_D_OUT_WB => DM_D_OUT_WB_OUT,
        RESULT_WB => RESULT_WB_OUT,
        imm9_16_WB => IMM9_16_WB_OUT,
        ra_WB => RA_WB_OUT,
        rb_WB => RB_WB_OUT,
        rc_WB => RC_WB_OUT,
        OPCODE_WB => OPCODE_WB_OUT,
        flags_WB => CONDITION_WB_OUT,
        Condition_WB => FLAGS_WB_IN,

        RF_AD_WB_RR => WRITE_BACK_ADDRESS,
        RF_DA_WB_RR => wRITE_BACK_DATA
    );
    Hazard: HazardUnit port map(
        clk => clk,
        IR_S1 => IF_ID_OUT,
        
        RF_WR => RF_WR,
        IF_ID_RESET => IF_ID_RESET,
        ID_RR_RESET => ID_RR_RESET,
        RR_EX_RESET => RR_EX_RESET,
        EX_MA_RESET => EX_MA_RESET,
        MA_WB_RESET => MA_WB_RESET,
        BUBBLE_CTRL => BUBBLE_CTRL_BRANCH 
    );
    
    RA_MUX_DFU: MUX_4x16 port map(
        sel => RA_MUX_DFU_CTRL,
        P0 => RA_D_EX_IN,
        P1 => RESULT_MA_OUT,
        P2 => WRITE_BACK_DATA,
        P3 => "0000000000000000",
        outp => RA_MUX_DFU_OUT
    );

    RB_MUX_DFU: MUX_4x16 port map(
        sel => RB_MUX_DFU_CTRL,
        P0 => RB_D_EX_IN,
        P1 => RESULT_MA_OUT,
        P2 => WRITE_BACK_DATA,
        P3 => "0000000000000000",
        outp => RB_MUX_DFU_OUT
    );

    DFU : DATA_FWD_UNIT port map(
        clk=> clk,
        OPCODE_RR_STAGE => OPCODE_RR_IN, 
        OPCODE_EX_STAGE => OPCODE_EX_IN, 
        OPCODE_MA_STAGE => OPCODE_MA_OUT, 
        OPCODE_WB_STAGE => OPCODE_WB_OUT, 
        RA_RR_STAGE => RA_RR_IN, 
        RB_RR_STAGE => RB_RR_IN, 
        RC_RR_STAGE => RC_RR_IN,

        RA_EX_STAGE => RA_A_EX_IN, 
        RB_EX_STAGE => RB_A_EX_IN, 
        RC_EX_STAGE => RC_A_EX_IN,

        RA_MA_STAGE => RA_MA_OUT, 
        RB_MA_STAGE => RB_MA_OUT, 
        RC_MA_STAGE => RC_MA_OUT,

        RA_WB_STAGE => RA_WB_OUT,
        RB_WB_STAGE => RB_WB_OUT, 
        RC_WB_STAGE => RC_WB_OUT,

        FWD_A_MUX_CTRL => RA_MUX_DFU_CTRL,
        FWD_B_MUX_CTRL => RB_MUX_DFU_CTRL
    );
    M_UNIT: M_CONTROl_UNIT port map(
            clk => clk,
            OPCODE => OPCODE_ID ,
            IMM9_16 => IMM9_ID ,
        
            BUBBLE_CTRL_M => BUBBLE_CTRL_M,
            M_INDEX => M_INDEX,
            M_M_EN => M_EN
        );
end architecture;
