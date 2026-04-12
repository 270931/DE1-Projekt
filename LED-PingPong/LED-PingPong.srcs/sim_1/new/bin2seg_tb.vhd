library ieee;
use ieee.std_logic_1164.all;

entity tb_bin2seg is
end tb_bin2seg;

architecture tb of tb_bin2seg is

    component bin2seg
        port (bin : in std_logic_vector (4 downto 0);
              seg : out std_logic_vector (6 downto 0));
    end component;

    signal bin : std_logic_vector (4 downto 0);
    signal seg : std_logic_vector (6 downto 0);

begin

    dut : bin2seg
    port map (bin => bin,
              seg => seg);

    stimuli : process
    begin
        
        report "[NOTE] Test of 'bin2seg' started!";
        
        bin <= b"0_0000"; wait for 5 ns;
        assert (seg = b"000_0001")
            report "[WARNING] bin2seg failed to convert '0'";

        bin <= b"0_0001"; wait for 5 ns;
        assert (seg = b"100_1111")
            report "[WARNING] bin2seg failed to convert '1'";
 
        bin <= b"0_0010"; wait for 5 ns;
        assert (seg = b"001_0010")
            report "[WARNING] bin2seg failed to convert '2'";
        
        bin <= b"0_0011"; wait for 5 ns;
        assert (seg = b"000_0110")
            report "[WARNING] bin2seg failed to convert '3'";
            
        bin <= b"0_0100"; wait for 5 ns;
        assert (seg = b"100_1100")
            report "[WARNING] bin2seg failed to convert '4'";
            
        bin <= b"0_0101"; wait for 5 ns;
        assert (seg = b"010_0100")
            report "[WARNING] bin2seg failed to convert '5'";
            
        bin <= b"0_0110"; wait for 5 ns;
        assert (seg = b"010_0000")
            report "[WARNING] bin2seg failed to convert '6'";
            
        bin <= b"0_0111"; wait for 5 ns;
        assert (seg = b"000_1111")
            report "[WARNING] bin2seg failed to convert '7'"; 
            
        bin <= b"0_1000"; wait for 5 ns;
        assert (seg = b"000_0000")
            report "[WARNING] bin2seg failed to convert '8'";
            
        bin <= b"0_1001"; wait for 5 ns;
        assert (seg = b"000_0100")
            report "[WARNING] bin2seg failed to convert '9'";  
        
        -- Letter 'P'
        bin <= b"1_0001"; wait for 5 ns;
        assert (seg = b"001_1000")
            report "[WARNING] bin2seg failed to convert 'P'";  
        
        -- Letter 'L'
        bin <= b"1_0010"; wait for 5 ns;
        assert (seg = b"111_0001")
            report "[WARNING] bin2seg failed to convert 'L'";  
        
        -- Letter 'A'
        bin <= b"1_0011"; wait for 5 ns;
        assert (seg = b"000_1000")
            report "[WARNING] bin2seg failed to convert 'A'";  
        
        -- Letter 'Y'
        bin <= b"1_0100"; wait for 5 ns;
        assert (seg = b"101_1000")
            report "[WARNING] bin2seg failed to convert 'Y'";  
        
        bin <= b"0_0000";
        wait;
        
    end process;

end tb;