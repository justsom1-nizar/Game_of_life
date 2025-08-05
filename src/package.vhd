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

    constant GRID_SIZE : integer := 32;
    constant Neighbors_number_to_live : integer := 3;  -- Number of neighbors required to live
    constant Neighbors_number_to_survive : integer := 2;  -- Number of neighbors
    constant CELL_PIXEL_SIZE : integer := 15; -- Size of each cell in pixels

    type t_state is array (0 to GRID_SIZE-1, 0 to GRID_SIZE-1) of STD_LOGIC;
constant initial_state : t_state := (others => (others => '0')) ;
-- game modes
    type t_game_mode is (MANUAL, AUTOMATIC, EDITING);  -- Define game modes
    -- clock divider
    constant DIV_FACTOR_CLOCK : integer := 2; -- Adjust for desired frequency
    constant DIV_FACTOR_GAME_LOGIC : integer := 25000000; -- Adjust for game logic frequency
    -- horizontal_counter
    constant HORIZONTAL_COUNT_MAX : integer := 799; -- Horizontal count max value
    constant VERTICAL_COUNT_MAX : integer := 520; -- Vertical count max value
    constant H_PULSE_WIDTH : integer := 96; -- Horizontal sync pulse width
    constant V_PULSE_WIDTH : integer := 2; -- Vertical sync pulse width
    constant H_BACKPORCH : INTEGER := 48; -- Horizontal back porch
    constant V_BACKPORCH : INTEGER := 29; -- Vertical back porch
    constant H_FRONT_PORCH : INTEGER := 16; -- Horizontal front porch
    constant V_FRONT_PORCH : INTEGER := 10; -- Vertical front porch
    
    --vga_controller
    constant H_SYNC_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(H_PULSE_WIDTH,10)); -- Horizontal sync start
    constant H_SYNC_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(HORIZONTAL_COUNT_MAX , 10)); -- Horizontal sync end
    constant V_SYNC_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(V_PULSE_WIDTH, 10)); -- Vertical sync start
    constant V_SYNC_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(VERTICAL_COUNT_MAX, 10)); -- Vertical sync end
    
    constant H_DISPLAY_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(H_PULSE_WIDTH+H_BACKPORCH, 10)); -- Horizontal display start
    constant H_DISPLAY_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(HORIZONTAL_COUNT_MAX-H_FRONT_PORCH, 10)); -- Horizontal display end
    constant V_DISPLAY_START : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(V_PULSE_WIDTH+V_BACKPORCH, 10)); -- Vertical display start
    constant V_DISPLAY_END : STD_LOGIC_VECTOR(9 downto 0) := std_logic_vector(to_unsigned(VERTICAL_COUNT_MAX-V_FRONT_PORCH, 10)); -- Vertical display end
    
    constant x_resolution : INTEGER := 640;
    constant y_resolution : INTEGER := 480;
    constant x_margin : INTEGER := (x_resolution-y_resolution)/2;
    constant y_margin : INTEGER := 0;
    
    
end package game_of_life_pkg;
