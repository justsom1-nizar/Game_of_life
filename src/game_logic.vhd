----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2025 02:13:26 PM
-- Design Name: 
-- Module Name: logic_to_pixels - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.game_of_life_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity game_logic is
 Port ( 
    clk : in STD_LOGIC; -- System clock
    reset : in STD_LOGIC; -- Reset signal
    current_state : in t_state;
    manual_enable : in STD_LOGIC;
    automatic_enable : in STD_LOGIC;
    game_mode : in t_game_mode; -- Game mode signal
    next_state : out t_state

 );
end game_logic;

architecture Behavioral of game_logic is

begin
    process(clk)
    variable number_of_neighbors : integer := 0;
    variable neighbor_x : integer :=0;
    variable neighbor_y : integer :=0;
    variable neighbor_state : integer :=0;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                next_state <= (others => (others => '0'));
            elsif (manual_enable = '1' and game_mode = MANUAL) or (game_mode = AUTOMATIC and automatic_enable = '1') then
                for pixel_y in 0 to GRID_SIZE-1 loop
                    for pixel_x in 0 to GRID_SIZE-1 loop
                    number_of_neighbors := 0;
                for dx in -1 to 1 loop
                    for dy in -1 to 1 loop
                        neighbor_x  := pixel_x+dx;
                        neighbor_y  := pixel_y+dy;
                        if neighbor_x < 0 then
                            neighbor_x := GRID_SIZE-1;
                        elsif neighbor_x >= GRID_SIZE then
                            neighbor_x := 0;
                        end if;
                        if neighbor_y < 0 then
                            neighbor_y := GRID_SIZE-1;
                        elsif neighbor_y >= GRID_SIZE then
                            neighbor_y := 0;
                        end if;
                        if NOT( dx = 0 and dy = 0 )then
                            if current_state(neighbor_y,neighbor_x) = '1' then
                                neighbor_state := 1;
                            else
                                neighbor_state := 0;
                            end if;
                            number_of_neighbors := number_of_neighbors+neighbor_state ;
                        end if;  
                    end loop;
                end loop;
                if number_of_neighbors = Neighbors_number_to_live then
                    next_state(pixel_y, pixel_x) <= '1';  
                elsif number_of_neighbors = Neighbors_number_to_survive then
                    next_state(pixel_y, pixel_x) <= current_state(pixel_y, pixel_x); 
                else
                    next_state(pixel_y, pixel_x) <= '0';
                end if;
                            
            end loop;
            end loop;
        end if;
        end if;
    end process;


end Behavioral;
