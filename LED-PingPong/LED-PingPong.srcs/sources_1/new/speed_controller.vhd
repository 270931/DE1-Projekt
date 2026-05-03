library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity speed_controller is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        hit_detected : in  STD_LOGIC;
        tick_limit   : out integer range 0 to 10_000_000
    );
end speed_controller;

architecture Behavioral of speed_controller is
    constant ODPALY_PRO_ZRYCHLENI : integer := 5;
    constant MAX_COUNT            : integer := (3 * ODPALY_PRO_ZRYCHLENI) - 1;  -- 14

    signal hit_count : integer range 0 to MAX_COUNT := 0;
begin

    -- Hit counter
    counter_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                hit_count <= 0;
            elsif hit_detected = '1' then
                if hit_count < MAX_COUNT then
                    hit_count <= hit_count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Speeding up the game depending on the number of successful hits
    tick_limit <= 10_000_000 when hit_count < ODPALY_PRO_ZRYCHLENI       -- Default: 100 ms
             else 7_500_000  when hit_count < (2 * ODPALY_PRO_ZRYCHLENI) -- Level 1: 75 ms
             else 5_000_000;                                             -- Level 2: 50 ms

end Behavioral;