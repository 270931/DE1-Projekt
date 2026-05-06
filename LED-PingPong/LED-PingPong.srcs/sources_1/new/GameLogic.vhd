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
    
    -- Dynamic speed signals
    signal dynamic_tick   : integer := 10_000_000;
    signal boost_factor   : integer range 1 to 3 := 1;
    signal effective_tick : integer range 0 to 10_000_000;
    
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
    -- IMPORTANT: uses 'effective_tick', which is ratio between (dynamic_tick / boost_factor)  
    clock_ball : clk_en
        port map (
            clk       => clk,
            rst       => reset_request,
            sig_limit => effective_tick,
            ce        => ball_tick
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
    
    -- Effective tick logic, lower tick = higher frequence = ball go brrr
    effective_tick <= dynamic_tick      when boost_factor = 1 else
                      dynamic_tick / 2  when boost_factor = 2 else
                      dynamic_tick / 3;
    
    game: process(clk)
    begin
        
        if rising_edge(clk) then
            
            -- check if reset 'rst' signal has been recieved
            if(rst = '1') then
                player_L_score  <= 0;
                player_R_score  <= 0;
                ball_position   <= b"0000_0001_1000_0000";
                displayed_text  <= (others => '1');         -- IMPORTANT!! active low (sviti '0')
                led16_b         <= '0';
                reset_request   <= '1';
                boost_factor    <= 1;                       -- DEFAULT ball speed
                game_state      <= IDLE;
            else
                
                
                case game_state is
                    
                    when IDLE =>
                    -- In this state, the game is waiting for input from any player to transition to START state
                    
                        if(player_L = '1' OR player_R = '1') then
                            reset_request <= '1';
                            game_state <= START;
                        else
                            --                   _         L                    player L score                          _         -         P               player R score                               _
                            displayed_text <= "10010" & "10000" & std_logic_vector(to_unsigned(player_L_score, 5)) & "11111" & "10001" & "10000" & std_logic_vector(to_unsigned(player_R_score, 5)) & "11111";
                        end if;
                        
                        
                        
                    when START =>
                    -- Display the word 'PLAY' on the the center 4 7-segments.
                    -- After that, advace to 'PLAYING' state.
                        
                        reset_request <= '0';
                        
                                         --   _     _     P     L     A     Y     _     _
                        displayed_text <= b"11111_11111_10001_10010_10011_10100_11111_11111";
                        
                        if (display_text = '1') then
                        
                            if(player_L_score >= player_R_score) then 
                                ball_direction <= '1';
                            else 
                                ball_direction <= '0';
                            end if;
                            
                            game_state <= PLAYING;
                            
                        end if;
                    
                    
                    
                    when PLAYING =>
                    -- 3-LED hit zone on each side:
                    --   L: bit 15 (outer) = 1x, bit 14 (middle) = 2x, bit 13 (inside) = 3x
                    --   R: bit 0  (outer) = 1x, bit 1  (middle) = 2x, bit 2  (inside) = 3x
                    --
                    -- Boost only lasts on flight, until it enters the zone of opposite player 
                    -- then it returnts to 1x
                    
                        -- Blank the 7-segment display
                        displayed_text <= (others => '1');
                        
                        -- LED indicator of MISS is off
                        led16_b <= '1';
                        
                        -- Stop reseting the timer
                        reset_request <= '0';
                        
                        -- LEFT player hit detection 
                        if (player_L = '1' and ball_direction = '1' and 
                            (ball_position(15) = '1' or ball_position(14) = '1' or ball_position(13) = '1')) then
                            -- Boost selection logic
                            if ball_position(15) = '1' then
                                boost_factor <= 1;   
                            elsif ball_position(14) = '1' then
                                boost_factor <= 2;   
                            else
                                boost_factor <= 3;   -- If player hit serve, then boost the ball speed 3x
                            end if;
                            -- bounce
                            ball_direction <= '0';
                            ball_position <= '0' & ball_position(15 downto 1);
                            reset_request <= '1';        
                        
                        -- RIGHT player hit detection
                        elsif (player_R = '1' and ball_direction = '0' and
                               (ball_position(0) = '1' or ball_position(1) = '1' or ball_position(2) = '1')) then
                            -- Boost selection logic
                            if ball_position(0) = '1' then
                                boost_factor <= 1;
                            elsif ball_position(1) = '1' then
                                boost_factor <= 2;
                            else
                                boost_factor <= 3;   -- If player hit serve, then boost the ball speed 3x 
                            end if;
                            ball_direction <= '1';
                            ball_position <= ball_position(14 downto 0) & '0';
                            reset_request <= '1';
                        
                        else
                            if ball_direction = '0' and 
                               (ball_position(0) = '1' or ball_position(1) = '1' or ball_position(2) = '1') then
                                boost_factor <= 1;
                            elsif ball_direction = '1' and
                                  (ball_position(15) = '1' or ball_position(14) = '1' or ball_position(13) = '1') then
                                boost_factor <= 1;
                            end if;
                        end if;

                        -- BALL MOVEMENT update and MISSED HIT
                        if (ball_tick = '1') then
                            
                            if(ball_direction = '1') then
                                -- Ball movement <- LEFT
                                if(ball_position(15) = '1') then
                                    -- MISSED
                                    player_R_score <= player_R_score + 1;
                                    led16_b <= '1';
                                    game_state <= END_OF_ROUND;
                                else
                                    ball_position <= ball_position(14 downto 0) & '0';
                                end if;
                                
                            elsif(ball_direction = '0') then
                                -- Ball movement -> RIGHT
                                if(ball_position(0) = '1') then
                                    -- MISSED
                                    player_L_score <= player_L_score + 1;
                                    led16_b <= '1';
                                    game_state <= END_OF_ROUND;
                                else
                                    ball_position <= '0' & ball_position(15 downto 1);
                                end if;
                                
                            end if;
                        end if;
                    
                
                    
                    when END_OF_ROUND =>
                    -- Reset the ball position
                    ball_position   <= b"0000_0001_1000_0000";
                    
                    -- Boost reset between servs
                    boost_factor    <= 1;
                    
                    if(player_L_score = WIN_SCORE OR player_R_score = WIN_SCORE) then
                        game_state <= END_OF_GAME;
                    else
                        game_state <= IDLE;
                    end if;
                    
                    when END_OF_GAME =>
                    -- Flash all LEDs, display winner, wait for manual reset.
                    
                        if (ball_tick = '1') then
                            if (ball_position(15) = '1') then
                                ball_position <= (others => '0'); 
                            else
                                ball_position <= (others => '1');
                            end if;
                        end if;

                        if (player_L_score = WIN_SCORE) then
                            --                    P     L     A     Y     E     r     _     L
                            displayed_text <= b"10001_10010_10011_10100_10101_10110_11111_10010";
                        else
                            --                    P     L     A     Y     E     r     _     r
                            displayed_text <= b"10001_10010_10011_10100_10101_10110_11111_10110";
                        end if;
                    
                    when others =>
                        game_state <= IDLE;
                end case;
            
            
            end if;
        
        end if;
    
    end process;
end Behavioral;