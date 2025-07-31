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
    signal display_finished : STD_LOGIC; -- Signal to indicate display is finished
    signal current_cells_state : t_state := initial_state; -- Initialize the game state
    signal next_cells_state : t_state; -- Variable to hold the next state
    signal enable_game_logic : STD_LOGIC ; -- Enable signal for game logic
    signal display_finished_edge : STD_LOGIC; -- Edge detection for display finished
    signal divided_clk : STD_LOGIC; -- Divided clock signal for VGA timing
    signal button_pressed : STD_LOGIC := '0'; -- Signal to detect button press
begin
process(clk)  -- Remove reset_button from sensitivity list
begin 
    if rising_edge(clk) then 
        if reset_button = '1' then 
            current_cells_state <= initial_state;
            button_pressed <= '0';
        else
            -- Handle button press detection
            if enable_game_logic = '1' and button_pressed = '0' then
                button_pressed <= '1';  -- Mark that button was pressed
            end if;
            
            -- Update state when display finishes and button was pressed
            if display_finished_edge = '1' and button_pressed = '1' then 
                current_cells_state <= next_cells_state;
                button_pressed <= '0';  -- Clear the flag
            end if;
        end if;
    end if; 
end process;
 -- Detect button press
    display_controller_inst : entity work.NextStateButton
        Port map (
            clk => clk,
            reset => reset_button,
            btn_next => display_finished,
            next_generation => display_finished_edge
        );
    -- Instantiate the Next State Button Handler
    next_state_button_handler : entity work.NextStateButton
        Port map (
            clk => clk,
            reset => reset_button,
            btn_next => next_state_button,
            next_generation => enable_game_logic
        );
    -- Instantiate the game logic
    game_logic_inst : entity work.game_logic
        Port map (
            clk => clk,
            reset => reset_button,
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
        clk_out => divided_clk
    );
    -- Instantiate the VGA controller
    vga_controller_inst : entity work.VGA_controller
        Port map (
            divided_clk => divided_clk,
            rst => reset_button,
            cell_state => current_cells_state,
            display_finished => display_finished,
            hsync => hsync,
            vsync => vsync,
            red => red,
            green => green,
            blue => blue
        );
end Behavioral;
