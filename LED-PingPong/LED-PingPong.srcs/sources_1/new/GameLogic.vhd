library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity GameLogic is
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
end GameLogic;

architecture Behavioral of GameLogic is 

    -- some clock enable will be needed in order to slow down the ball
    component clk_en is
        generic ( G_MAX : positive :=5);  -- Default number of clock cycles
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               ce  : out STD_LOGIC);
    end component;
    
    component display_driver is
        Port ( clk   : in STD_LOGIC;
               rst   : in STD_LOGIC;
               data  : in STD_LOGIC_VECTOR (39 downto 0);   -- For use of all 8 7-segment displays.
               seg   : out STD_LOGIC_VECTOR (6 downto 0);
               anode : out STD_LOGIC_VECTOR (7 downto 0));
    end component display_driver;

    -- to change the winnig score, modify this value
    constant WIN_SCORE : integer := 10;

    -- signals needed to run the game
    signal reset_request  : STD_LOGIC;
    signal player_R_score : integer range 0 to WIN_SCORE;
    signal player_L_score : integer range 0 to WIN_SCORE;
    signal ball_position  : STD_LOGIC_VECTOR(15 downto 0);
    signal display_text   : STD_LOGIC;
    signal displayed_text : STD_LOGIC_VECTOR(39 downto 0);
    
    -- If '1' ball is moving <- LEFT; if '0' ball is moving -> RIGHT
    signal ball_direction : STD_LOGIC;
    
    -- possible states of the game
    type state_type is (IDLE, START, PLAYING, END_OF_ROUND, END_OF_GAME);
    signal game_state : state_type;

begin

    -- The amount of time that any text should be displayed
    -- Reset with global 'rst' OR upon request of the game
    clock0 : clk_en
        generic map ( G_MAX => 400_000_000 )    -- 4 seconds should be enough
        port map (
            clk => clk,
            rst => reset_request,
            ce  => display_text
        );
           
    -- Instance of the 'display_driver' component for text display
    display0 : display_driver
        port map (
            clk => clk,
            rst => rst,
            data => displayed_text,
            seg => seg,
            anode => anode
        );
    
    game: process(clk)
    begin
        
        if rising_edge(clk) then
            
            -- check if reset 'rst' signal has been recieved
            if(rst = '1') then
                player_L_score  <= 0;
                player_R_score  <= 0;
                ball_position   <= b"0000_0001_1000_0000";
                displayed_text  <= (others => '1');         -- IMPORTANT!! active low (svítí '0')
                reset_request   <= '1';
                game_state      <= IDLE;
            else
                
                case game_state is
                    
                    
                    
                    when IDLE =>
                    -- In this state, the game is waiting for input from any player to transition to START state
                    
                        -- If input is detected from any or all players, the game will transition with the next
                        --  clock cycle to 'START' state                                        DONE
                        if(player_L = '1' OR player_R = '1') then
                        
                            -- reset_request for counter in the next game state                 DONE
                            reset_request <= '1';
                            -- advance gamestate
                            game_state <= START;
                        else
                            -- Display the score on 7-segment in the format of X00--00X (where X is off, and left 00
                            --  is player L score and vice versa)
                        end if;
                        
                        
                        
                    when START =>
                    -- In this state, decide on the direction of the ball movement (somehow)    DONE
                    -- Display the word 'PLAY' on the the center 4 7-segments.                  DONE
                    -- After that, advace to 'PLAYING' state                                    DONE
                    -- Kdyz hra zacne, spusti se TIMER, ten generuje TICK o nejake f, counter bude pocitat uspesne odpaly, po X odpalech se tick zrychly a zvetsi obtiznost hry.
                        
                        -- Start the clk_en
                        reset_request <= '0';
                        
                                         --   _     _     P     L     A     Y     _     _
                        displayed_text <= b"11111_11111_10001_10010_10011_10100_11111_11111";
                        
                        -- Once 4 secs is up, decide on the direction and continue
                        if (display_text = '1') then
                        
                        -- Decide on the ball direction
                            if(player_L_score >= player_R_score) then 
                                ball_direction <= '1';
                            else 
                                ball_direction <= '0';
                            end if;
                            
                            -- Advance the next game state
                            game_state <= PLAYING;
                            
                        end if;
                    
                    
                    
                    when PLAYING =>
                    -- In this state, advance the ball according to slowed clock signal in the decided direction
                    -- When ball is in the player teritory (for the left player LED15 is on, for right LED0 is on)
                    --  check for the 'player_X' signal within time of one ball advancement.
                    -- If succesful, reverse the direction of ball, flash 'led16_b' and repeate.
                    -- If failed, advance to the 'END_OF_ROUND' state.
                    
                    
                    
                    when END_OF_ROUND =>
                    -- In this state, on the basis of the ball position, recalculate the coresponding player score.
                    -- If 'player_X' score if equal to 'WIN_SCORE', advace to the 'END_OF_GAME' state.
                    -- If 'palyer_X' score is less than 'WIN_SCORE' advance to the 'IDLE' state.
                    
                    when END_OF_GAME =>
                    -- In this state, flash repeatedly all playing LEDs and display either 'PLAYERX1' or 'PLAYERX2'
                    --  on the 7-segment (X meaning segment is off).
                    -- Remain in this state until manual reset.
                    
                    when others =>
                    -- If something unexpected happens, go to 'IDLE' state.
                        game_state <= IDLE;
                end case;
            
            
            -- reset 'if'
            end if;
        
        -- rising_edge 'if'
        end if;
    
    -- 'game' process
    end process;
end Behavioral;
