library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.game_of_life_pkg.all; 

entity game_mode is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        game_btn   : in std_logic;
        current_mode   : out t_game_mode
    );
end entity;

architecture Behavioral of game_mode is
 signal mode_out : t_game_mode;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            mode_out <= MANUAL; 
        elsif rising_edge(clk) then
            if game_btn = '1' then
                case mode_out is
                    when MANUAL =>
                        mode_out <= AUTOMATIC;
                    when AUTOMATIC =>
                        mode_out <= EDITING;
                    when EDITING =>
                        mode_out <= MANUAL;
                end case;
            end if;
        end if;
    end process;
    current_mode<=mode_out;
end architecture;