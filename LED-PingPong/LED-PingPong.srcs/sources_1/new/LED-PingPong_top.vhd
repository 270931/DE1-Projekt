library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------
--  Declaration of ports used as input and output by the whole
--   program
----------------------------------------------------------------
entity LED_PingPong_top is
--  TODO: might need to be expanded
    Port ( 
           -- IN facing ports
           clk      : in STD_LOGIC;
           btnc     : in STD_LOGIC;
           btnl     : in STD_LOGIC;
           btnr     : in STD_LOGIC;
           
           -- OUT facing ports
           seg      : out STD_LOGIC_VECTOR (6 downto 0);
           led      : out STD_LOGIC_VECTOR (15 downto 0);
           led16_b  : out STD_LOGIC;
           anode    : out STD_LOGIC_VECTOR (7 downto 0);
           dp       : out STD_LOGIC
           );
end LED_PingPong_top;

architecture Behavioral of LED_PingPong_top is

begin
    
    -- TODO: connect the instances according to schematic


end Behavioral;
