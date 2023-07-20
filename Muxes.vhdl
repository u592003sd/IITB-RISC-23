library ieee;
use ieee.std_logic_1164.all;

package Muxes is
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

    component MUX_4x8 is 
    port(
        --select signal
        sel : in std_logic_vector(1 downto 0);
        -- input data
        P0 : in std_logic_vector(7 downto 0);
        P1: in std_logic_vector(7 downto 0);
        P2: in std_logic_vector(7 downto 0);
        P3: in std_logic_vector(7 downto 0);
        --output data
        outp : out std_logic_vector(7 downto 0)
    );
    end component;

    component MUX_4x3 is 
    port(
        --select signal
        sel : in std_logic_vector(1 downto 0);
        -- input data
        P0 : in std_logic_vector(2 downto 0);
        P1: in std_logic_vector(2 downto 0);
        P2: in std_logic_vector(2 downto 0);
        P3: in std_logic_vector(2 downto 0);
        --output data
        outp : out std_logic_vector(2 downto 0)
    );
    end component;

    component MUX_2x8 is 
    port(
        --select signal
        sel : in std_logic;
        -- input data
        P0 : in std_logic_vector(7 downto 0);
        P1: in std_logic_vector(7 downto 0);
        --output data
        outp : out std_logic_vector(7 downto 0)
    );
    end component;

    component DEMUX_4x1 is
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
end package;
library ieee;
use ieee.std_logic_1164.all;


entity MUX_2x16 is 
    port(
        --select signal
        sel : in std_logic;
        -- input data
        P0 : in std_logic_vector(15 downto 0);
        P1: in std_logic_vector(15 downto 0);
        --output data
        outp : out std_logic_vector(15 downto 0)
    );
end MUX_2x16 ;

architecture arch of MUX_2x16 is    
    signal OUT_IN_TEMP: std_logic_vector(15 downto 0);
begin
    --writing to register when write_enable is set
    MUX: process(P0, P1, OUT_IN_TEMP)    
    begin
		case sel is
			  when '0' =>
			  OUT_IN_TEMP <= P0;
			  when '1' =>
			  OUT_IN_TEMP <= P1;
		 end case;    
		 end process MUX;
		outp <= OUT_IN_TEMP; 
end arch;

library ieee;
use ieee.std_logic_1164.all;

entity MUX_4x16 is 
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
end MUX_4x16;

architecture arch of MUX_4x16 is    
    signal OUT_IN_TEMP: std_logic_vector(15 downto 0);
begin
    --writing to register when write_enable is set
    MUX: process(P0, P1, P2, P3, OUT_IN_TEMP)
    
    begin
	case sel is
        when "00" =>
        OUT_IN_TEMP <= P0;
        when "01" =>
        OUT_IN_TEMP <= P1;
        when "10" =>
        OUT_IN_TEMP <= P2;
        when "11" =>
        OUT_IN_TEMP <= P3;
    end case;    
    end process MUX;
	outp <= OUT_IN_TEMP; 
end arch;

library ieee;
use ieee.std_logic_1164.all;

entity MUX_2x1 is 
    port(
        --select signal
        sel : in std_logic;
        -- input data
        P0 : in std_logic;
        P1: in std_logic;
        --output data
        outp : out std_logic
    );
end MUX_2x1;

architecture arch of MUX_2x1 is    
    signal OUT_IN_TEMP: std_logic;
begin
    --writing to register when write_enable is set
    MUX: process(P0, P1, OUT_IN_TEMP)
    
    begin
	case sel is
        when '0' =>
        OUT_IN_TEMP <= P0;
        when '1' =>
        OUT_IN_TEMP <= P1;
    end case;    
    end process MUX;
	outp <= OUT_IN_TEMP; 
end arch;


library ieee;
use ieee.std_logic_1164.all;

entity MUX_4x8 is 
    port(
        --select signal
        sel : in std_logic_vector(1 downto 0);
        -- input data
        P0 : in std_logic_vector(7 downto 0);
        P1: in std_logic_vector(7 downto 0);
        P2: in std_logic_vector(7 downto 0);
        P3: in std_logic_vector(7 downto 0);
        --output data
        outp : out std_logic_vector(7 downto 0)
    );
end MUX_4x8;

architecture arch of MUX_4x8 is    
    signal OUT_IN_TEMP: std_logic_vector(7 downto 0);
begin
    --writing to register when write_enable is set
    MUX: process(P0, P1, P2, P3, OUT_IN_TEMP)
    
    begin
	case sel is
        when "00" =>
        OUT_IN_TEMP <= P0;
        when "01" =>
        OUT_IN_TEMP <= P1;
        when "10" =>
        OUT_IN_TEMP <= P2;
        when "11" =>
        OUT_IN_TEMP <= P3;
    end case;    
    end process MUX;
	outp <= OUT_IN_TEMP; 
end arch;


library ieee;
use ieee.std_logic_1164.all;

entity MUX_4x3 is 
    port(
        --select signal
        sel : in std_logic_vector(1 downto 0);
        -- input data
        P0 : in std_logic_vector(2 downto 0);
        P1: in std_logic_vector(2 downto 0);
        P2: in std_logic_vector(2 downto 0);
        P3: in std_logic_vector(2 downto 0);
        --output data
        outp : out std_logic_vector(2 downto 0)
    );
end MUX_4x3;

architecture arch of MUX_4x3 is    
    signal OUT_IN_TEMP: std_logic_vector(2 downto 0);
begin
    --writing to register when write_enable is set
    MUX: process(P0, P1, P2, P3, OUT_IN_TEMP)
    
    begin
	case sel is
        when "00" =>
        OUT_IN_TEMP <= P0;
        when "01" =>
        OUT_IN_TEMP <= P1;
        when "10" =>
        OUT_IN_TEMP <= P2;
        when "11" =>
        OUT_IN_TEMP <= P3;
    end case;    
    end process MUX;
	outp <= OUT_IN_TEMP; 
end arch;

library ieee;
use ieee.std_logic_1164.all;

entity MUX_2x8 is 
    port(
        --select signal
        sel : in std_logic;
        -- input data
        P0 : in std_logic_vector(7 downto 0);
        P1: in std_logic_vector(7 downto 0);
        --output data
        outp : out std_logic_vector(7 downto 0)
    );
end MUX_2x8;

architecture arch of MUX_2x8 is    
    signal OUT_IN_TEMP: std_logic_vector(7 downto 0);
begin
    --writing to register when write_enable is set
    MUX: process(P0, P1, OUT_IN_TEMP)
    
    begin
	case sel is
        when '0' =>
        OUT_IN_TEMP <= P0;
        when '1' =>
        OUT_IN_TEMP <= P1;
    end case;    
    end process MUX;
	outp <= OUT_IN_TEMP; 
end arch;

library ieee;
use ieee.std_logic_1164.all;

entity DEMUX_4x1 is
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
end DEMUX_4x1;

architecture arch of DEMUX_4x1 is
    begin
    process(input_value, enable_signal, sel)
    begin
        case sel is
            when 0 =>
                if enable_signal = '0' then
                    P0 <= input_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                else
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                end if;
            when 1 =>
                if enable_signal = '1' then
                    P0 <= default_value;
                    P1 <= input_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                else
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                end if;
            when 2 =>
                if enable_signal = '1' then
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= input_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                else
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                end if;
            when 4 =>
                if enable_signal = '1' then
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= input_value;
                    P4 <= default_value;
                    P5 <= default_value;
                else
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                end if;
            when 5 =>
                if enable_signal = '1' then
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= input_value;
                    P5 <= default_value;
                else
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                end if;
            when 6 =>
                if enable_signal = '1' then
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= input_value;
                else
                    P0 <= default_value;
                    P1 <= default_value;
                    P2 <= default_value;
                    P3 <= default_value;
                    P4 <= default_value;
                    P5 <= default_value;
                end if;
            when others =>
                P0 <= default_value;
                P1 <= default_value;
                P2 <= default_value;
                P3 <= default_value;
                P5 <= default_value;
        end case;
    end process;
end arch;
    
