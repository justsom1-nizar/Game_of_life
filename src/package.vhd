----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2025 03:04:54 PM
-- Design Name: 
-- Module Name: package - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
package game_of_life_pkg is
    -- game_logic

    constant Size : integer := 8;  -- Size of the state vector
    constant GRID_SIZE : integer := 16;
    constant Neighbors_number_to_live : integer := 3;  -- Number of neighbors required to live
    constant Neighbors_number_to_survive : integer := 2;  -- Number of neighbors
    constant CELL_PIXEL_SIZE : integer := 5; -- Size of each cell in pixels
    type t_state is array (0 to GRID_SIZE-1, 0 to GRID_SIZE-1) of STD_LOGIC;
    constant initial_state : t_state := (
        others => (others => '0')
    );
    type t_pixel_array is array (0 to (GRID_SIZE * CELL_PIXEL_SIZE) - 1, 0 to (GRID_SIZE * CELL_PIXEL_SIZE) - 1) of STD_LOGIC;
    -- clock divider
    constant DIV_FACTOR : integer := 2; -- Adjust for desired frequency
    -- horizontal_counter
    constant HORIZONTAL_COUNT_MAX : integer := 799; -- Horizontal count max value
    constant VERTICAL_COUNT_MAX : integer := 524; -- Vertical count max value
    --vga_controller
    constant H_FIRST_SYNC_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(0,10)); -- Horizontal sync start
    constant H_FIRST_SYNC_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(96 , 10)); -- Horizontal sync end
    constant V_FIRST_SYNC_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(0, 10)); -- Vertical sync start
    constant V_FIRST_SYNC_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(2, 10)); -- Vertical sync end
    
    constant H_DISPLAY_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(144, 10)); -- Horizontal display start
    constant H_DISPLAY_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(784, 10)); -- Horizontal display end
    constant V_DISPLAY_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(35, 10)); -- Vertical display start
    constant V_DISPLAY_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(515, 10)); -- Vertical display end
    
    constant H_LAST_SYNC_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(144, 10)); -- Horizontal sync start
    constant H_LAST_SYNC_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(784, 10)); -- Horizontal sync end
    constant V_LAST_SYNC_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(35, 10)); -- Vertical sync start
    constant V_LAST_SYNC_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(515, 10)); -- Vertical sync end
end package game_of_life_pkg;
