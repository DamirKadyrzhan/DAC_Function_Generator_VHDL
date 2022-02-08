-- SQUARE WAVE ModelSim 


library ieee;
use ieee.std_logic_1164.all;
USE ieee.NUMERIC_STD.all; 

entity square is

    port(
        clk      : in   std_logic;
        output   : out  unsigned(11 downto 0);
        reset    : in   std_logic
    );

end entity;

architecture rtl of square is
    

    -- Build an enumerated type for the state machine
    type state_type is (s0_high,s1_low);

    -- Register to hold the current state
    signal state   : state_type;



begin
    
    -- Logic to advance to the next state
    process (clk, reset)
        
    variable counter : integer := 0;
    
    begin
        if reset = '1' then
            state <= s0_high;
        elsif (rising_edge(clk)) then
            case state is
                when s0_high=>
                    if counter <= 250 then
                        state <= s0_high;
                        counter := counter + 1;
                    else
                        state <= s1_low;
                        --counter := 0;
                    end if;
                when s1_low=>
                    if counter <= 500 then
                        state <= s1_low;
                        counter := counter + 1;
                    else
                        state <= s0_high;
                        counter := 0; 
                    end if;
            end case;
        end if;
    end process;

     --Output depends solely on the current state
    process (state)
    begin
        case state is
            when s0_high =>
                output <= "111111111111";
            when s1_low =>
                output <= "000000000000";
        end case;
    end process;

end rtl;

