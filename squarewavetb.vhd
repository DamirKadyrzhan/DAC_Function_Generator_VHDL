-- SQUARE WAVE ModelSim TEST BENCH


LIBRARY ieee; 
LIBRARY std ; 
USE ieee.NUMERIC_STD.all; 
USE ieee.std_logic_1164.all ; 
USE ieee.std_logic_textio.all; 
USE ieee.std_logic_unsigned.all ; 

entity squarewavetb is
end entity;

architecture sim of squarewavetb is
    signal reset : std_logic; -- reset 
    signal output : unsigned(11 downto 0); -- output
    constant ClockFrequency : integer := 50e6; -- Clock Frequency
    constant ClockPeriod    : time    := 1000 ms / ClockFrequency; -- Clock Period T = 1 second / Clock Frequency
    
    signal Clk : std_logic := '1'; -- assign clock value as 1 
    
begin
    -- Square Wave DUT 
    i_square : entity work.square(rtl)
        port map( -- specify ports in Model Sim
            clk => clk,
            reset => reset,
            output => output
        );
    
    
    Clk <= not Clk after ClockPeriod / 2; -- Clock signal will alternate between 1 and 0
    

    
end architecture;

    


