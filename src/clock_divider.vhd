library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.game_of_life_pkg.all;

entity clock_divider is
    generic (
            DIV_FACTOR : integer  -- Declaring a generic integer constant
        );
    Port (
        clk_in  : in  STD_LOGIC;  -- Input clock
        reset   : in  STD_LOGIC;  -- Reset signal
        clk_out : out STD_LOGIC   -- Divided clock output
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal counter : unsigned(31 downto 0) := (others => '0'); -- 32-bit counter
    signal clk_reg : STD_LOGIC := '0';

begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
            clk_reg <= '0';
        elsif rising_edge(clk_in) then
            if counter = DIV_FACTOR - 1 then
                counter <= (others => '0');
                clk_reg <= not clk_reg;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_reg;
end Behavioral;
