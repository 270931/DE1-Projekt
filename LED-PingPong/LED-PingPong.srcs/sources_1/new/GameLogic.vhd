library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
        Port ( clk       : in STD_LOGIC;
               rst       : in STD_LOGIC;
               sig_limit : in integer; 
               ce        : out STD_LOGIC);
    end component;
    
    component display_driver is
        Port ( clk   : in STD_LOGIC;
               rst   : in STD_LOGIC;
               data  : in STD_LOGIC_VECTOR (39 downto 0);   -- For use of all 8 7-segment displays.
               seg   : out STD_LOGIC_VECTOR (6 downto 0);
               anode : out STD_LOGIC_VECTOR (7 downto 0));
    end component display_driver;
    
    component speed_controller is
        Port (
            clk          : in  STD_LOGIC;
            rst          : in  STD_LOGIC;
            hit_detected : in  STD_LOGIC;
            tick_limit   : out integer range 0 to 10_000_000
        );
    end component;

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
    signal ball_tick      : STD_LOGIC;
    
    -- Signály pro dynamickou rychlost
    signal hit_event      : STD_LOGIC := '0';
    signal speed_rst    : STD_LOGIC;
    signal dynamic_tick   : integer range 0 to 10_000_000;
    
    -- possible states of the game's FST
    type state_type is (IDLE, START, PLAYING, END_OF_ROUND, END_OF_GAME);
    signal game_state : state_type;

begin

    -- The amount of time that any text should be displayed
    -- Reset with global 'rst' OR upon request of the game
    clock0 : clk_en
        port map (
            clk       => clk,
            rst       => reset_request,
            sig_limit => 200_000_000,    -- 2 seconds should be enough
            ce        => display_text
        );
    
    -- Clock for 1 ball movement in either direction
    -- Teď používá dynamický limit místo konstanty tick_time
    clock_ball : clk_en
        port map (
            clk       => clk,
            rst       => reset_request,
            sig_limit => dynamic_tick,
            ce        => ball_tick
        );
        
    -- Instance of the speed controler
    speed_ctrl_i : speed_controller
        port map (
            clk          => clk,
            rst          => speed_rst,
            hit_detected => hit_event,
            tick_limit   => dynamic_tick
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
    
    -- update the LED playing field according to the ball position
    led <= ball_position;
    -- disable the decimal point
    dp <= '1';
    
    game: process(clk)
    begin
        
        if rising_edge(clk) then
            
            -- check if reset 'rst' signal has been recieved
            if(rst = '1') then
                player_L_score  <= 0;
                player_R_score  <= 0;
                ball_position   <= b"0000_0001_1000_0000";
                displayed_text  <= (others => '1');         -- IMPORTANT!! active low (svítí '0')
                led16_b         <= '0';
                reset_request   <= '1';
                speed_rst       <= '1';
                hit_event       <= '0';
                game_state      <= IDLE;
            else
                
                hit_event <= '0';
                speed_rst <='0';
                
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
                            --                   _         L                    player L score                          _         -         P               player R score                               _
                            displayed_text <= "10010" & "10000" & std_logic_vector(to_unsigned(player_L_score, 5)) & "11111" & "10001" & "10000" & std_logic_vector(to_unsigned(player_R_score, 5)) & "11111";
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
                    -- If sucessful, reverse the direction of ball  and repeate.
                    -- If failed, flash 'led16_b' and advance to the 'END_OF_ROUND' state.
                    
                        -- Blank the 7-segment display
                        displayed_text <= (others => '1');
                        
                        -- LED indicator of MISS is off
                        led16_b <= '1';
                        
                        -- Stop reseting the timer
                        reset_request <= '0';
                        
                        -- INDEPENDENT DETECTION of ball hit
                        -- If left player button is pressed and ball is in their teritory...
                        if (player_L = '1' and ball_position(15) = '1') then
                            -- SUCCESS:
                            -- ... reverse the ball direction ...
                            ball_direction <= '0';
                            -- ... update ball position ...
                            ball_position <= '0' & ball_position(15 downto 1);
                            hit_event <= '1'; -- +1 hit to the speed
                            -- reset the timer now
                            reset_request <= '1';
                            
                        elsif (player_R = '1' and ball_position(0) = '1') then
                            -- SUCCESS
                            ball_direction <= '1';
                            ball_position <= ball_position(14 downto 0) & '0';
                            hit_event <= '1'; -- +1 hit to the speed
                            -- reset the timer now
                            reset_request <= '1';
                        end if;

                        -- BALL MOVEMENT update and MISSED HIT
                        if (ball_tick = '1') then
                            
                            if(ball_direction = '1') then
                                -- Ball movement <- LEFT
                                if(ball_position(15) = '1') then
                                    -- MISSED
                                    -- MISSED is when, ball is in player teritory AND timer has expired a.k.a.
                                    --         ball would have gone past the playing field
                                    player_R_score <= player_R_score + 1;
                                    -- Flash led16_b upon MISSED
                                    led16_b <= '1';
                                    game_state <= END_OF_ROUND;
                                else
                                    -- Ball is not in player teritory
                                    ball_position <= ball_position(14 downto 0) & '0';
                                end if;
                                
                            elsif(ball_direction = '0') then
                                -- Ball movement -> RIGHT
                                if(ball_position(0) = '1') then
                                    -- MISSED
                                    player_L_score <= player_L_score + 1;
                                    -- Flash led16_b upon MISSED
                                    led16_b <= '1';
                                    game_state <= END_OF_ROUND;
                                else
                                    ball_position <= '0' & ball_position(15 downto 1);
                                end if;
                                
                            end if;
                        end if;
                    
                
                    
                    when END_OF_ROUND =>
                    -- In this state, reset the ball position in case of another round will take place.
                    -- If 'player_X' score if equal to 'WIN_SCORE', advace to the 'END_OF_GAME' state.
                    -- If 'palyer_X' score is less than 'WIN_SCORE' advance to the 'IDLE' state.
                    
                    -- Reset the ball position
                    ball_position   <= b"0000_0001_1000_0000";
                    
                    speed_rst <= '1';
                    
                    -- Check, if entire game should end
                    if(player_L_score = WIN_SCORE OR player_R_score = WIN_SCORE) then
                        game_state <= END_OF_GAME;
                    else
                    -- If not, start next round
                        game_state <= IDLE;
                    end if;
                    
                    when END_OF_GAME =>
                    -- In this state, flash repeatedly all playing LEDs and display either 'PLAYERX1' or 'PLAYERX2'
                    --  on the 7-segment (X meaning segment is off).
                    -- Remain in this state until manual reset.
                    
                    -- Playing LEDs flashing
                        if (ball_tick = '1') then
                            -- ball_position(15) is only used as 'memory' of sort, to know what the previous state was
                            if (ball_position(15) = '1') then
                            -- If previous state was '1', shut down all the LEDs
                                ball_position <= (others => '0'); 
                            else
                            -- If previous state was '0', light all LEDs up.
                                ball_position <= (others => '1'); -- Rozsvítit
                            end if;
                        end if;

                    -- WINNER DISPLAY
                        -- Based on whose score is equal to WIN_SCORE
                        if (player_L_score = WIN_SCORE) then
                            -- 'PLAYER 1'
                            --                    P     L     A     Y     E     r     _     1
                            displayed_text <= b"10001_10010_10011_10100_10101_10110_11111_00001";
                        else
                            -- 'PLAYER 2'
                            --                    P     L     A     Y     E     r     _     2
                            displayed_text <= b"10001_10010_10011_10100_10101_10110_11111_00010";
                        end if;
                    
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
