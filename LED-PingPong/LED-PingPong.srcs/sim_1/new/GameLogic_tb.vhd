library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_GameLogic is
end tb_GameLogic;

architecture Behavioral of tb_GameLogic is

    component GameLogic
        Port ( 
            clk      : in STD_LOGIC;
            rst      : in STD_LOGIC;
            player_L : in STD_LOGIC;
            player_R : in STD_LOGIC;
            
            seg      : out STD_LOGIC_VECTOR (6 downto 0);
            led      : out STD_LOGIC_VECTOR (15 downto 0);
            led16_b  : out STD_LOGIC;
            anode    : out STD_LOGIC_VECTOR (7 downto 0);
            dp       : out STD_LOGIC
        );
    end component;

    signal tb_clk      : STD_LOGIC := '0';
    signal tb_rst      : STD_LOGIC := '1';
    signal tb_player_L : STD_LOGIC := '0';
    signal tb_player_R : STD_LOGIC := '0';
    
    signal tb_seg      : STD_LOGIC_VECTOR (6 downto 0);
    signal tb_led      : STD_LOGIC_VECTOR (15 downto 0);
    signal tb_led16_b  : STD_LOGIC;
    signal tb_anode    : STD_LOGIC_VECTOR (7 downto 0);
    signal tb_dp       : STD_LOGIC;

    constant clk_period : time := 10 ns;

begin

    uut: GameLogic 
        port map (
            clk      => tb_clk,
            rst      => tb_rst,
            player_L => tb_player_L,
            player_R => tb_player_R,
            seg      => tb_seg,
            led      => tb_led,
            led16_b  => tb_led16_b,
            anode    => tb_anode,
            dp       => tb_dp
        );

    clk_process :process
    begin
        tb_clk <= '0';
        wait for clk_period/2;
        tb_clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
    
        -- Simulating pressing RESET button
        tb_rst <= '1';
        tb_dp <= '0';
        tb_player_L <= '0';
        tb_player_R <= '0';
        wait for 50 ns;
        
        -- Simulating releasing RESET button
        tb_rst <= '0';
        wait for 100 ns;
        -- Game is in IDLE sate

        -- Left player presses their button
        tb_player_L <= '1';
        wait for clk_period * 2;
        tb_player_L <= '0';
        
        -- Game should be in START state
        wait for 500 ns;
        
        -- Game should be in PLAYING state
        
        wait for 600 ns;
        
        -- Player L hits the ball
        tb_player_L <= '1';
        wait for clk_period * 5; 
        tb_player_L <= '0';

        
        wait for 2000 ns;
        wait;
    end process;

end Behavioral;