-- TRIANGLE WAVE ModelSim TEST BENCH


LIBRARY ieee; 
LIBRARY std ; 
USE ieee.NUMERIC_STD.all; 
USE ieee.std_logic_1164.all ; 
USE ieee.std_logic_textio.all; 
USE ieee.std_logic_unsigned.all ; 

entity trianglewavetb is
end entity;

architecture sim of trianglewavetb is
    signal reset : std_logic;
    signal output : std_logic_vector(11 downto 0);
    constant ClockFrequency : integer := 50e6;
    constant ClockPeriod    : time    := 1000 ms / ClockFrequency;
    
    signal Clk : std_logic := '1';
    
begin
    
    i_triangle : entity work.triangle(rtl)
        port map(
            clk => clk,
            reset => reset,
            output => output
        );
    
    
    Clk <= not Clk after ClockPeriod / 2; -- Clock signal will alternate between 1 and 0
    
end architecture;

    


