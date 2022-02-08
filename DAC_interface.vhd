--SPI interface for MCP4921 DAC
--12-bit digital data in parallel connected to input d
--cs_l, sck and sdi connected to corresponding pins of MCP4921
--LDAC pin tied to 0V
--VDD tied to 3.3
--Vref tied to 3.3V  (change to a value between 0 and VDD if a different output range is required
--Vss tied to 0V
--clk should be connected to 50MHz system clock
--set loadData input to logic '1' to latch new data to the DAC
--J Krabicka, Dec 2021

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DAC_interface is


	port
	(
		clk		  : in std_logic;  --connected to 50MHz system clock
		loadData	  : in std_logic;  --new data will latch to sdi_arr when this input is high
		d	  : in unsigned(11 downto 0); --connected to parallel digital data in binary format, MSB on the left
		cs_l,sck,sdi	  : out std_logic --SPI control pins on MCP4921
		
													--suggested pins:
													--cs_l:  GPIO_27 (Header Pin 32, FPGA pin AJ22)
													--sck:   GPIO_28 (Header Pin 33, FPGA pin AH22)
													--sdi:   GPIO_29 (Header Pin 34, FPGA pin AG22)
													
													--the DE1-SoC header supplies 3.3V on header pin 29
													--the DE1-SoC header supplies 0V on header pin 30
	);

end entity;

architecture rtl of DAC_interface is

constant sck_arr: std_logic_vector(0 to 34) := "00101010101010101010101010101010100";  --SPI clock edges according to timing diagram
																													--every risig edge clocks in the next bit of the 16-bit input
constant cs_l_arr: std_logic_vector(0 to 34) := "10000000000000000000000000000000001";  --cs_l according to timing diagram
signal sdi_arr: std_logic_vector(0 to 34);
begin
	process (loadData)
	begin
		if loadData = '1' then
		sdi_arr <=  "000001111" &  --first four are configuration bits (doubled to span a whole clock cycle) 
						--A/B selected 0, buf selected 0, multiplier selected 1, shdn selected 1
						 d(11)& d(11) & d(10) & d(10)&   -- 12 data bits (doubled to span a whole clock cycle)
						 d(9) & d(9) & d(8) & d(8) &
						 d(7) & d(7) & d(6) & d(6) &
						 d(5) & d(5) & d(4) & d(4) &
						 d(3) & d(3) & d(2) & d(2) &
						 d(1) & d(1) & d(0) & d(0) & 
						 "00";   --to pad out the final sck edges according to the timing diagram
		end if;
	end process;
	
	process (clk)
		variable i: integer range 0 to 34 := 0;   --35 bits to implement the timing diagram
	   begin
		if rising_edge(clk) then
			--assign the corresponding bits in the array to the MCP4921 SPI control pins:
			cs_l <= cs_l_arr(i);
			sck <= sck_arr(i);
			sdi <= sdi_arr(i);
		
		 	if i = 34 then 
			   i := 0;
			else 
		 	  i := i + 1;
			end if;
		end if;
	   end process;
end rtl;
