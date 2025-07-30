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

entity logic_to_pixels is
    port (
        current_state : in t_state; -- Input game state
        pixel_array   : out t_state -- Output pixel array
    );
end logic_to_pixels;

architecture Behavioral of logic_to_pixels is
begin
    process(current_state)
        -- Calculate grid size based on SIZE
        variable cell_x : integer;
        variable cell_y : integer;
    begin
        for pixel_y in GRID_SIZE*CELL_PIXEL_SIZE - 1 downto 0 loop
            for pixel_x in GRID_SIZE*CELL_PIXEL_SIZE - 1 downto 0 loop
                -- Calculate the corresponding cell in the game state
                cell_x := pixel_x / CELL_PIXEL_SIZE;
                cell_y := pixel_y / CELL_PIXEL_SIZE;
                -- Determine the pixel value based on the game state
                if current_state(cell_y, cell_x) = '1' then
                    pixel_array(pixel_y, pixel_x) <= '1'; -- Cell is alive
                else
                    pixel_array(pixel_y, pixel_x) <= '0'; -- Cell is dead
                end if;
            end loop;
        end loop;
    end process;
end Behavioral;
