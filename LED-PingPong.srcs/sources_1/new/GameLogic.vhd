----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.03.2026 09:53:52
-- Design Name: 
-- Module Name: GameLogic - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GameLogic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           player_L : in STD_LOGIC;
           player_R : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           led16_b : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0);
           dp : out STD_LOGIC);
end GameLogic;

architecture Behavioral of GameLogic is

begin

    --TODO: how will this work??


end Behavioral;
