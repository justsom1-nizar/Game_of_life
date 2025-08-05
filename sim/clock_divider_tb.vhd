library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.game_of_life_pkg.all;

entity clock_divider_tb is
end clock_divider_tb;

architecture Behavioral of clock_divider_tb is
    component clock_divider
        generic (
            DIV_FACTOR : integer
        );
        Port (
            clk_in  : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

    signal clk_in  : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '0';
    signal clk_out : STD_LOGIC;

    constant clk_period : time := 10 ns; -- 100 MHz clock (1/100MHz = 10ns)
    constant DIV_FACTOR : integer := 28;

begin
    uut: clock_divider 
        generic map (
            DIV_FACTOR => DIV_FACTOR
        )
        port map (
            clk_in  => clk_in,
            reset   => reset,
            clk_out => clk_out
        );

    clk_process : process
    begin
        clk_in <= '0';
        wait for clk_period/2;
        clk_in <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        
        wait for 1000 ns; -- Let it run for multiple cycles
        
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        
        wait for 2000 ns; -- Run more cycles after reset
        
        wait;
    end process;

end Behavioral;