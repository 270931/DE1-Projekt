library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clk_en is
generic ( G_MAX : positive :=5);  -- Default number of clock cycles
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : out STD_LOGIC);
end clk_en;

architecture Behavioral of clk_en is

    -- Internal counter
    signal sig_cnt : integer range 0 to G_MAX-1;
    
begin

   syn_proc : process (clk) is
    begin
    
        if rising_edge(clk) then
            if rst = '1' then
                sig_cnt <= 0;
                ce <= '0';
                
            elsif sig_cnt = G_MAX-1 then
                sig_cnt <= 0;
                ce <= '1';
                
            else 
                sig_cnt <= sig_cnt + 1;
                ce <= '0';
            end if;
            
        end if; 
        
    end process;
      

end Behavioral;