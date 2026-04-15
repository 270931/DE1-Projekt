library ieee;
use ieee.std_logic_1164.all;

entity tb_speed_controller is
end tb_speed_controller;

architecture tb of tb_speed_controller is

    component speed_controller
        port (clk          : in std_logic;
              rst          : in std_logic;
              hit_detected : in std_logic;
              tick_limit   : out integer);
    end component;

    signal clk          : std_logic;
    signal rst          : std_logic;
    signal hit_detected : std_logic;
    signal tick_limit   : integer;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : speed_controller
    port map (clk          => clk,
              rst          => rst,
              hit_detected => hit_detected,
              tick_limit   => tick_limit);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    
   stimuli : process
    begin
        -- Inicializace
        hit_detected <= '0';
        rst <= '1';
        wait for 10 * TbPeriod;
        
        -- Konec resetu
        rst <= '0';
        wait for 10 * TbPeriod;
        -- Teď by tick_limit měl být 10_000_000 (Základní rychlost)

        -- Simulace 5 zásahů (první zrychlení)
        -- Použijeme loop, abychom nemuseli kód kopírovat
        for i in 1 to 5 loop
            hit_detected <= '1'; -- Generujeme puls
            wait for TbPeriod;   -- Trvá jeden takt
            hit_detected <= '0';
            wait for 5 * TbPeriod; -- Pauza mezi hity
        end loop;
        -- Teď by se tick_limit měl změnit na 7_500_000

        wait for 20 * TbPeriod;

        -- Simulace dalších 5 zásahů (druhé zrychlení)
        for i in 1 to 5 loop
            hit_detected <= '1';
            wait for TbPeriod;
            hit_detected <= '0';
            wait for 5 * TbPeriod;
        end loop;
        -- Teď by se tick_limit měl změnit na 5_000_000

        wait for 50 * TbPeriod;

        -- Test resetu během hry (rychlost se musí vrátit na maximum)
        rst <= '1';
        wait for 5 * TbPeriod;
        rst <= '0';
        
        wait for 20 * TbPeriod;

        -- Konec simulace
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
