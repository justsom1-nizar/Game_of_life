library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.game_of_life_pkg.all;
entity vertical_counter is
    Port (
        clk : in STD_LOGIC;         -- Clock signal
        reset : in STD_LOGIC;       -- Reset signal
        TC_enable : in STD_LOGIC;      -- Enable signal (tc from horizontal counter)
        count : out STD_LOGIC_VECTOR(9 downto 0)-- 10-bit vertical count
    );
end vertical_counter;

architecture Behavioral of vertical_counter is
    signal counter : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            if TC_enable = '1' then
                if counter = VERTICAL_COUNT_MAX then
                    counter <= (others => '0');
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;

    count <= counter;
end Behavioral;