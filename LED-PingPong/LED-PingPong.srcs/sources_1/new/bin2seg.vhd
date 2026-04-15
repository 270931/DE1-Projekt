
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
            when b"0_0000" =>
                seg <= b"100_0000";
            -- b"0_0001"
            when b"0_0001" =>
                seg <= b"111_1001";
            -- b"0_0010"
            when b"0_0010" =>
                seg <= b"010_0100";
            -- b"0_0011"
            when b"0_0011" =>
                seg <= b"011_0000";
            -- b"0_0100"
            when b"0_0100" =>
                seg <= b"001_1001";
            -- b"0_0101"
            when b"0_0101" =>
                seg <= b"001_0010";
            -- b"0_0110"
            when b"0_0110" =>
                seg <= b"000_0010";
            -- b"0_0111"
            when b"0_0111" =>
                seg <= b"111_1000";
            -- b"0_1000"
            when b"0_1000" =>
                seg <= b"000_0000";
            -- b"0_1001"
            when b"0_1001" =>
                seg <= b"001_0000";
            
            -- Displaying text
            -- "P"
            when b"1_0001" =>
                seg <= b"000_1100";
            -- "L"
            when b"1_0010" =>
                seg <= b"100_0111";
            -- "A"
            when b"1_0011" =>
                seg <= b"000_1000";
            -- "Y"
            when b"1_0100" =>
                seg <= b"001_1001";
                
            -- "-"
            when b"1_0000" =>
                seg <= b"011_1111";
                
            when others =>
                seg <= b"111_1111";  -- All segments off
        end case;
    end process p_7seg_decoder;

end Behavioral;
