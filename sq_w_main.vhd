-- SQUARE WAVE to FPGA using DAC Interface 


library ieee;
use ieee.std_logic_1164.all;
USE ieee.NUMERIC_STD.all; 

entity sq_w_main is

    port(
        clk             : in   std_logic;
        d               : out  unsigned(11 downto 0);
        reset           : in   std_logic;
        cs_l, sck,sdi   : out std_logic;
        loadData        : in std_logic
        
        -- 3 ports 
    );

end entity;

architecture rtl of sq_w_main is
    

    -- Build an enumerated type for the state machine
    type state_type is (s0_high,s1_low);

    -- Register to hold the current state
    signal state   : state_type;
    
    signal loadData1 : std_logic := '1';
    signal cs_l1, sck1, sdi1 : std_logic; 
    signal d1 : unsigned(11 downto 0);
    signal clk1 : std_logic; 
    signal reset1 : std_logic;
    

-- components 
component DAC_interface1
port (
    loadData : std_logic;
    cs_l     : std_logic;
    sck      : std_logic;
    sdi      : std_logic;
    d        : unsigned(11 downto 0);
    clk      : std_logic;
    reset    : std_logic
);
end component;



begin
    
    -- portmap 
    i_DAC : entity work.DAC_interface(rtl)
    port map(
        loadData => loadData1,
        cs_l     => cs_l1,
        sck      => sck1,
        sdi      => sdi1,
        d        => d1,
        clk      => clk1
        --reset    => reset1
    );
    
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

    process (state)
    begin
        case state is
            when s0_high =>
                d1 <= "111111111111";
            when s1_low =>
                d1 <= "000000000000";
        end case;
    end process;

end rtl;

