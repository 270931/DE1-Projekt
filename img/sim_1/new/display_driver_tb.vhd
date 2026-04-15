library ieee;
use ieee.std_logic_1164.all;

entity tb_display_driver is
end tb_display_driver;

architecture tb of tb_display_driver is

    component display_driver
        port (clk   : in std_logic;
              rst   : in std_logic;
              data  : in std_logic_vector (39 downto 0);
              seg   : out std_logic_vector (6 downto 0);
              anode : out std_logic_vector (7 downto 0));
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal data  : std_logic_vector (39 downto 0);
    signal seg   : std_logic_vector (6 downto 0);
    signal anode : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver
    port map (clk   => clk,
              rst   => rst,
              data  => data,
              seg   => seg,
              anode => anode);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
    
        rst <= '1'; 
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        data <= b"11111_11111_10001_10010_10011_10100_11111_11111"; 
        wait for 800 ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;