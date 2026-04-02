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
           clk      : in STD_LOGIC;     -- system clock signal (the 10 ns one)
           btnc     : in STD_LOGIC;     -- system reset button (center button)
           btnl     : in STD_LOGIC;     -- left player button
           btnr     : in STD_LOGIC;     -- right player button
           
           -- OUT facing ports
           seg      : out STD_LOGIC_VECTOR (6 downto 0);    -- current 7-segment display data
           led      : out STD_LOGIC_VECTOR (15 downto 0);   -- player hir registered LED
           led16_b  : out STD_LOGIC;                        -- playing field LEDs
           anode    : out STD_LOGIC_VECTOR (7 downto 0);    -- current 7-segment active (active low)
           dp       : out STD_LOGIC                         -- no decimal point
           );
end LED_PingPong_top;



architecture Behavioral of LED_PingPong_top is

    --Internal signals for connecting components
    signal sig_player_L_press : STD_LOGIC;
    signal sig_player_R_press : STD_LOGIC;
    
    
    -- component "Debouce" declaration
    component debounce is
        Port ( clk       : in STD_LOGIC;
               rst       : in STD_LOGIC;
               btn_in    : in STD_LOGIC;
               btn_state : out STD_LOGIC;
               btn_press : out STD_LOGIC
             );
    end component debounce;
    
    
    -- component "GameLogic" declaration
    component GameLogic is
        Port ( 
               -- IN facing ports
               clk      : in STD_LOGIC;
               rst      : in STD_LOGIC;
               player_L : in STD_LOGIC;
               player_R : in STD_LOGIC;
               
               -- OUT facing ports
               seg      : out STD_LOGIC_VECTOR (6 downto 0);
               led      : out STD_LOGIC_VECTOR (15 downto 0);
               led16_b  : out STD_LOGIC;
               anode    : out STD_LOGIC_VECTOR (7 downto 0);
               dp       : out STD_LOGIC);
    end component GameLogic;


begin
    
    -- debounce for PlayerL input button
    debounceL: debounce
        port map(
            clk       => clk,
            rst       => btnc,
            btn_in    => btnl,
            btn_press => sig_player_L_press,
            btn_state => open
        );
    
    -- debounce for PlayerR input button
    debounceR: debounce
        port map(
            clk       => clk,
            rst       => btnc,
            btn_in    => btnr,
            btn_press => sig_player_R_press,
            btn_state => open
        );
    
    -- instance of main GameLogic component
    game: GameLogic
        port map(
            clk => clk,
            rst => btnc,
            player_L => sig_player_L_press,
            player_R => sig_player_R_press,
            
            seg => seg,
            led => led,
            led16_b => led16_b,
            anode => anode,
            dp => dp
        );
        
     -- probbably need to add clk_en somewhere


end Behavioral;
