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

    signal signal_seg  : STD_LOGIC_VECTOR(6 downto 0);
    signal signal_anode: STD_LOGIC_VECTOR(7 downto 0);

    -- Definition of precedure 'MaximumScore'
    procedure MaximumScore(
        variable player_L_score     : in integer;
        variable player_R_score     : in integer;
        variable   endOfGame          : out STD_LOGIC
        ) is
        
        begin
            if(player_L_score > 3) then
                endOfGame := '1';
                return;
            end if;
            
            if(player_R_score > 3) then
                endOfGame := '1';
                return;
            end if;
        end procedure MaximumScore;            

begin
    
    
    process(clk) is
       
       variable player_L_score  : integer;
       variable player_R_score  : integer;
       
       variable ball_position   : STD_LOGIC_VECTOR(15 downto 0);
       variable game_start      : STD_LOGIC;
       
    begin
        
        if rising_edge(clk) then
            
            -- check if reset signal has been recieved
            if(rst = '1') then
                player_L_score  := 0;
                player_R_score  := 0;
                ball_position   := b"0000_0001_1000_0000";
            end if;
            
            
            -- accual game body
            if(game_start = '1') then
                -- game
                
                -- update the ball position
                -- will need slowing down 
                led <= ball_position;
            
            
            -- for starting the game
            else
                -- TODO:
                -- Display on 7-segment 'PLAY'
                
                if( ( (player_L = '1') OR (player_R = '1') ) AND (game_start /= '1') ) then
                    game_start := '1';
                end if;   
                
            end if; 
        

        end if;
    end process;
end Behavioral;
