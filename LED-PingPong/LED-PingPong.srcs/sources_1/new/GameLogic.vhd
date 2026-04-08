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
    
    component bin2seg is
        Port ( bin : in STD_LOGIC_VECTOR (4 downto 0);
               seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

    -- to change the winnig score, modify this value
    constant WIN_SCORE : integer := 10;

    -- signals needed to run the game
    signal signal_seg     : STD_LOGIC_VECTOR(6 downto 0);
    signal signal_anode   : STD_LOGIC_VECTOR(7 downto 0);
    signal player_R_score : integer range 0 to WIN_SCORE;
    signal player_L_score : integer range 0 to WIN_SCORE;
    signal ball_position  : STD_LOGIC_VECTOR(15 downto 0);
    signal display_text   : STD_LOGIC;
    signal display_char   : STD_LOGIC_VECTOR(4 downto 0);
    
    -- possible states of the game
    type state_type is (IDLE, START, PLAYING, END_OF_ROUND, END_OF_GAME);
    signal game_state : state_type;

begin

    -- The amount of time that any text should be displayed
    clock0 : clk_en
        generic map ( G_MAX => 400_000_000 )    -- 4 seconds should be enough
        port map (
            clk => clk,
            rst => rst,
            ce  => display_text
        );
    
    -- Instance of the 'bin2seg' component to draw text
    display0 : bin2seg
        port map (
            bin => display_char,
            seg => seg
           );
        
    
    game: process(clk)
    begin
        
        if rising_edge(clk) then
            
            -- check if reset signal has been recieved
            if(rst = '1') then
                player_L_score  <= 0;
                player_R_score  <= 0;
                ball_position   <= b"0000_0001_1000_0000";
                game_state      <= IDLE;
                signal_seg      <= b"111_1111";
            else
                
                case game_state is
                    
                    when IDLE =>
                    -- In this state, the game is waiting for input from any player to transition to START state
                    
                        -- If input is detected from any or all players, the game will transition with the next
                        --  clock cycle to 'START' state
                        if(player_L = '1' OR player_R = '1') then
                            game_state <= START;
                        else
                            -- Display the score on 7-segment in the format of X00--00X (where X is off, and left 00
                            --  is player L score and vice versa)
                        end if;
                        
                    when START =>
                    -- In this state, decide on the direction of the ball movement (somehow), and also display the
                    --  word 'PLAY' on the the centre 4 7-segments.
                    -- After that, advace to 'PLAYING' state
                    -- Kdyz hra zacne, spusti se TIMER, ten generuje TICK o nejake f, counter bude pocitat uspesne odpaly, po X odpalech se tick zrychly a zvetsi obtiznost hry.
                        
                        if (display_text = '1') then
                            -- Letter "P"
                            anode <= b"1101_1111";
                            display_char <= b"1_0001";
                            -- Letter "L"
                            anode <= b"1110_1111";
                            display_char <= b"1_0010";
                            -- Letter "A"
                            anode <= b"1111_0111";
                            display_char <= b"1_0011";
                            -- Letter "Y"
                            anode <= b"1111_1011";
                            display_char <= b"1_0100";
                            
                         else
                         
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
