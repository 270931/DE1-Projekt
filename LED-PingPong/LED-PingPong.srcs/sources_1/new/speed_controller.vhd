library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity speed_controller is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        hit_detected : in  STD_LOGIC; -- Puls, když hráč úspěšně odpálí
        tick_limit   : out integer range 0 to 25_000_000
    );
end speed_controller;

architecture Behavioral of speed_controller is
    signal hit_count : integer range 0 to 15 := 0;
    constant ODPALY_PRO_ZRYCHLENI : integer := 1;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                hit_count <= 0;
                tick_limit <= 25_000_000; -- Základní rychlost 150ms
            elsif hit_detected = '1' then
                if hit_count < (3 * ODPALY_PRO_ZRYCHLENI) - 1 then
                    hit_count <= hit_count + 1;
                end if;
            end if;

            -- Logika výběru limitu podle počtu odpalů
            if hit_count < ODPALY_PRO_ZRYCHLENI then
                tick_limit <= 10_000_000; -- Úroveň 0: 100ms
            elsif hit_count < (2 * ODPALY_PRO_ZRYCHLENI) then
                tick_limit <= 7_500_000;  -- Úroveň 1: 75ms
            else
                tick_limit <= 5_000_000;  -- Úroveň 2: 50ms
            end if;
        end if;
    end process;
end Behavioral;