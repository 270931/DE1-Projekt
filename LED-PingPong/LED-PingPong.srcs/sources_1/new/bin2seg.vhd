
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2seg is
    Port ( bin : in STD_LOGIC_VECTOR (4 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end bin2seg;

architecture Behavioral of bin2seg is

begin

    p_7seg_decoder : process (bin) is
    begin
        case bin is
        
            -- b"0_0000"
            when x"0" =>
                seg <= b"000_0001";
            -- b"0_0001"
            when x"1" =>
                seg <= b"100_1111";
            -- b"0_0010"
            when x"2" =>
                seg <= b"001_0010";
            -- b"0_0011"
            when x"3" =>
                seg <= b"000_0110";
            -- b"0_0100"
            when x"4" =>
                seg <= b"100_1100";
            -- b"0_0101"
            when x"5" =>
                seg <= b"010_0100";
            -- b"0_0110"
            when x"6" =>
                seg <= b"010_0000";
            -- b"0_0111"
            when x"7" =>
                seg <= b"000_1111";
            -- b"0_1000"
            when x"8" =>
                seg <= b"000_0000";
            -- b"0_1001"
            when x"9" =>
                seg <= b"000_0100";
            
            -- Displaying text
            -- "P"
            when b"1_0001" =>
                seg <= b"001_1000";
            -- "L"
            when b"1_0010" =>
                seg <= b"111_0001";
            -- "A"
            when b"1_0011" =>
                seg <= b"000_1000";
            -- "Y"
            when b"1_0100" =>
                seg <= b"101_1000";
                
            when others =>
                seg <= b"111_1111";  -- All segments off
        end case;
    end process p_7seg_decoder;

end Behavioral;
