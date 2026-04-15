library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_en is
    Port ( 
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        sig_limit : in  integer; -- Tvůj dynamický limit ze speed_controlleru
        ce        : out STD_LOGIC
    );
end clk_en;

architecture Behavioral of clk_en is

    -- Musíme definovat pevný rozsah, který pokryje tvých 100ms (10_000_000 taktů)
    signal sig_cnt : integer range 0 to 10000000 := 0;
    
begin

   syn_proc : process (clk) is
    begin
    
        if rising_edge(clk) then
            if rst = '1' then
                sig_cnt <= 0;
                ce <= '0';
                
            -- Změna: Porovnáváme s dynamickým vstupem sig_limit
            elsif sig_cnt >= sig_limit - 1 then 
                sig_cnt <= 0;
                ce <= '1';
                
            else 
                sig_cnt <= sig_cnt + 1;
                ce <= '0';
            end if;
            
        end if; 
        
    end process;

end Behavioral;