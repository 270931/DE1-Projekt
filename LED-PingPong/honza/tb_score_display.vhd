library ieee;
use ieee.std_logic_1164.all;

entity tb_score_display is
end tb_score_display;

architecture tb of tb_score_display is

    component score_display
        port (clk     : in std_logic;
              rst     : in std_logic;
              score_l : in std_logic_vector (3 downto 0);
              score_r : in std_logic_vector (3 downto 0);
              seg     : out std_logic_vector (6 downto 0);
              anode   : out std_logic_vector (7 downto 0);
              dp      : out std_logic);
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal score_l : std_logic_vector (3 downto 0);
    signal score_r : std_logic_vector (3 downto 0);
    signal seg     : std_logic_vector (6 downto 0);
    signal anode   : std_logic_vector (7 downto 0);
    signal dp      : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : score_display
    port map (clk     => clk,
              rst     => rst,
              score_l => score_l,
              score_r => score_r,
              seg     => seg,
              anode   => anode,
              dp      => dp);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    stimuli : process
    begin
        rst <= '1';
        score_l <= (others => '0');
        score_r <= (others => '0');
        wait for 100 ns;
        rst <= '0';

        -- Skore 0 : 0
        wait for 5 ms;

        -- Skore 1
        score_l <= "0001";
        wait for 5 ms;

        -- Skore 3
        score_l <= "0011";
        score_r <= "0010";
        wait for 5 ms;

        -- Skore 5
        score_l <= "0101";
        score_r <= "0100";
        wait for 5 ms;

        -- Skore 9
        score_l <= "1001";
        score_r <= "1001";
        wait for 5 ms;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_score_display of tb_score_display is
    for tb
    end for;
end cfg_tb_score_display;
