library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
    Port ( clk   : in STD_LOGIC;
           rst   : in STD_LOGIC;
           data  : in STD_LOGIC_VECTOR (39 downto 0);   -- For use of all 8 7-segment displays.
           seg   : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0));
end display_driver;

architecture Behavioral of display_driver is

    component clk_en is
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            sig_limit : in  integer;
            ce        : out std_logic
        );
    end component clk_en;

    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;

    component bin2seg is
        port (
            bin : in STD_LOGIC_VECTOR (4 downto 0);
            seg : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component bin2seg;

    signal sig_en    : std_logic;
    signal sig_bin   : std_logic_vector(4 downto 0); 
    signal sig_digit : std_logic_vector(2 downto 0);

begin

    clock_0 : clk_en    --Refreshing the display with period of 1 ms. (100_000)
        port map (                          -- For testbench changed to 100 ns. (10)
            clk => clk,             
            rst => rst,
            sig_limit => 100_000,
            ce  => sig_en
        );


    counter_0 : counter
        generic map ( G_BITS => 3 ) -- 8 possible combinations
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

 
    sig_bin <= data(4  downto 0)   when sig_digit = "000" else  -- 1. 7-segment
               data(9  downto 5)   when sig_digit = "001" else  -- 2. 7-segment
               data(14 downto 10)  when sig_digit = "010" else  -- 3. 7-segment
               data(19 downto 15)  when sig_digit = "011" else  -- 4. 7-segment
               data(24 downto 20)  when sig_digit = "100" else  -- 5. 7-segment
               data(29 downto 25)  when sig_digit = "101" else  -- 6. 7-segment
               data(34 downto 30)  when sig_digit = "110" else  -- 7. 7-segment
               data(39 downto 35);                              -- 8. 7-segment


    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg
        );

    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "000" => anode <= "11111110";  -- 1. 7-segment
            when "001" => anode <= "11111101";  -- 2. 7-segment
            when "010" => anode <= "11111011";  -- 3. 7-segment
            when "011" => anode <= "11110111";  -- 4. 7-segment
            when "100" => anode <= "11101111";  -- 5. 7-segment
            when "101" => anode <= "11011111";  -- 6. 7-segment
            when "110" => anode <= "10111111";  -- 7. 7-segment
            when "111" => anode <= "01111111";  -- 8. 7-segment
            when others => anode <= "11111111"; -- Invalid input
        end case;
    end process;

end Behavioral;