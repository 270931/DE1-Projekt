library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------
--  Declaration of ports used as input and output by the whole
--   program
----------------------------------------------------------------
entity LED_PingPong_top is
--  TODO: might need to be expanded
    Port ( LED_play : out STD_LOGIC_VECTOR (15 downto 0);
           dp : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC);
end LED_PingPong_top;

architecture Behavioral of LED_PingPong_top is

begin


end Behavioral;
