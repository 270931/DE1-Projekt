library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity score_display is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;
    score_l : in    std_logic_vector(3 downto 0);
    score_r : in    std_logic_vector(3 downto 0);
    seg     : out   std_logic_vector(6 downto 0);
    anode   : out   std_logic_vector(7 downto 0);
    dp      : out   std_logic
  );
end entity score_display;

architecture behavioral of score_display is

  signal sig_cnt : unsigned(16 downto 0) := (others => '0');
  signal sig_sel : std_logic;
  signal sig_bin : std_logic_vector(3 downto 0);

begin

  p_counter : process (clk) is
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sig_cnt <= (others => '0');
      else
        sig_cnt <= sig_cnt + 1;
      end if;
    end if;
  end process p_counter;

  sig_sel <= std_logic(sig_cnt(16));

  p_mux : process (sig_sel, score_l, score_r) is
  begin
    case sig_sel is
      when '0' =>
        anode   <= "01111111"; -- AN7 aktivni (levy hrac)
        sig_bin <= score_l;
      when '1' =>
        anode   <= "11111110"; -- AN0 aktivni (pravy hrac)
        sig_bin <= score_r;
      when others =>
        anode   <= "11111111";
        sig_bin <= "0000";
    end case;
  end process p_mux;

  dp <= '1';

  decoder_inst : entity work.bin2seg
    port map (
      clear => rst,
      bin   => sig_bin,
      seg   => seg
    );

end architecture behavioral;
