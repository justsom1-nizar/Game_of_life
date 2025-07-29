library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.game_of_life_pkg.all;
entity horizental_counter is
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        count : out STD_LOGIC_VECTOR(9 downto 0); -- 10-bit counter to count up to 799
        tc    : out STD_LOGIC             -- Terminal count, high when count reaches 799
    );
end horizental_counter;

architecture Behavioral of horizental_counter is
    signal counter_reg : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter_reg <= (others => '0');
        elsif rising_edge(clk) then
            if to_integer(unsigned(counter_reg)) = HORIZONTAL_COUNT_MAX then
                counter_reg <= (others => '0');
            else
                counter_reg <= std_logic_vector(unsigned(counter_reg) + 1);
            end if;
        end if;
    end process;

    count <= counter_reg;
    tc <= '1' when to_integer(unsigned(counter_reg)) = HORIZONTAL_COUNT_MAX else '0';
end Behavioral;