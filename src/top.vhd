----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2025 02:17:04 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
 Port (
    clk   : in  STD_LOGIC;          -- System clock
    reset_button : in  STD_LOGIC;          -- Reset signal
    next_state_button : in  STD_LOGIC;          -- Button to trigger next state
    hsync : out STD_LOGIC;          -- Horizontal sync signal for VGA
    vsync : out STD_LOGIC;          -- Vertical sync signal for VGA
    red   : out STD_LOGIC_VECTOR(3 downto 0); -- Red
    green : out STD_LOGIC_VECTOR(3 downto 0); -- Green
    blue  : out STD_LOGIC_VECTOR(3 downto 0)  -- Blue
  );
end top;

architecture Behavioral of top is
    
    signal current_cells_state : t_state := initial_state; -- Initialize the game state
    signal next_cells_state : t_state; -- Variable to hold the next state

    signal enable_game_logic : STD_LOGIC := '0'; -- Enable signal for game logic

    signal divided_clock : STD_LOGIC; -- Divided clock signal for VGA timing

begin
    process(clk, reset_button)
    begin
        if rising_edge(clk) then
            if reset_button = '1' then
                current_cells_state <= initial_state; -- Reset the game state
                enable_game_logic <= '0'; -- Disable game logic
            elsif next_state_button = '1' then
                enable_game_logic <= '1'; -- Enable game logic to compute the next state
            else
                enable_game_logic <= '0'; -- Disable game logic if no button is pressed
            end if;
        end if;
    end process;
    
    -- Instantiate the game logic
    game_logic_inst : entity work.game_logic
        Port map (
            current_state => current_cells_state,
            enable        => enable_game_logic,
            next_state    => next_cells_state
        );  
    -- -- Game logic process
    -- logic_to_pixels_inst: entity work.logic_to_pixels
    --  port map(
    --     current_state => current_cells_state,
    --     pixel_array => pixel_array
    -- );
    clock_divider_inst: entity work.clock_divider
     port map(
        clk_in => clk,
        reset => reset_button,
        clk_out => divided_clock
    );
    -- Instantiate the VGA controller
    vga_controller_inst : entity work.VGA_controller
        Port map (
            clk => divided_clock,
            rst => reset_button,
            cell_state => current_cells_state,
            hsync => hsync,
            vsync => vsync,
            red => red,
            green => green,
            blue => blue
        );
end Behavioral;
