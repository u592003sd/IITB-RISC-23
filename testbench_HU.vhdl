library ieee;
use ieee.std_logic_1164.all;

entity test_tb is
end test_tb;

architecture behavior of test_tb is
    component test
        port(clk : in std_logic);
    end component;

   signal clk : std_logic := '0';
   constant clk_period : time := 1 ns;

begin:    
    Data_Hazard_Unit: test port map (clk => clk);       
    -- Clock process definitions( clock with 50% duty cycle is generated here.)
    clk_process:process()
    begin
        clk <= '0';
        wait for 10 NS;
        clk <= '1';
        wait for 10 NS;
    end process;    
end behavior;