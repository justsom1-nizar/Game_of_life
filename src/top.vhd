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
    change_mode_button : in  STD_LOGIC;          -- Button to change mode
    move_cursor_left : in  STD_LOGIC;          -- Button to move cursor left
    move_cursor_down : in  STD_LOGIC;          -- Button to move cursor down
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
    signal update_state : STD_LOGIC := '0'; -- Signal to detect button press
    signal game_clock : STD_LOGIC; -- Game clock signal
    signal change_mode_button_edge : STD_LOGIC; -- Edge detection for mode change button
    signal game_mode : t_game_mode ; -- Current game mode
    signal move_cursor_left_edge : STD_LOGIC;
    signal move_cursor_down_edge : STD_LOGIC;
    signal cursor_x : integer := 8;
    signal cursor_y : integer := 8;
    signal game_clock_edge : STD_LOGIC;
    signal move_cursor_left_latch : STD_LOGIC := '0';
    signal move_cursor_down_latch : STD_LOGIC := '0';
    signal toggle_cell_latch : STD_LOGIC := '0';
begin
process(clk)  -- Remove reset_button from sensitivity list
begin 
    if rising_edge(clk) then 
        if reset_button = '1' then 
            current_cells_state <= initial_state;
            update_state <= '0';
        else
            -- Handle button press detection
            if ((enable_game_logic = '1' and game_mode = MANUAL) or (game_clock_edge = '1' AND game_mode = AUTOMATIC)) and update_state = '0' then
                update_state <= '1';  -- Mark that button was pressed
            end if;
            if game_mode = EDITING then
                -- Handle cursor movement in EDITING mode
                if move_cursor_left_edge = '1' then
                    move_cursor_left_latch <= '1';
                elsif move_cursor_down_edge = '1' then
                    move_cursor_down_latch <= '1';
                elsif enable_game_logic = '1' then
                    toggle_cell_latch <= '1';
                end if;
            end if;
            -- Update state when display finishes and button was pressed
            if display_finished_edge = '1' then 
                if game_mode = EDITING then
                    -- Handle cursor movement in EDITING mode
                    if move_cursor_left_latch = '1' then
                        cursor_x <= (cursor_x - 1 + GRID_SIZE) mod GRID_SIZE; -- Wrap around
                    end if;
                    if move_cursor_down_latch = '1' then
                        cursor_y <= (cursor_y + 1) mod GRID_SIZE; -- Wrap around
                    end if;

                    -- Toggle cell state at cursor position
                    if toggle_cell_latch = '1' then
                        current_cells_state(cursor_y, cursor_x) <= not current_cells_state(cursor_y, cursor_x);
                    end if;
                    -- Clear latches after processing
                    move_cursor_left_latch <= '0';
                    move_cursor_down_latch <= '0';
                    toggle_cell_latch <= '0';
                elsif update_state = '1' then
                    current_cells_state <= next_cells_state;
                    update_state <= '0';  -- Clear the flag
                end if;
            end if;
        end if;
    end if; 
end process;
--game clock_edge detection
game_clock_edge_component: entity work.NextStateButton
    Port map (
        clk => clk,
        reset => reset_button,
        btn_next => game_clock,
        next_generation => game_clock_edge
    );
-- game mode signal
game_mode_component : entity work.game_mode
    Port map (
        clk => clk,
        reset => reset_button,
        game_btn => change_mode_button_edge,  
        current_mode => game_mode
    );


    -- Instantiate the edge detection for cursor movement
    move_cursor_left_edge_inst : entity work.NextStateButton
        Port map (
            clk => clk,
            reset => reset_button,
            btn_next => move_cursor_left,
            next_generation => move_cursor_left_edge
        );

    move_cursor_down_edge_inst : entity work.NextStateButton
        Port map (
            clk => clk,
            reset => reset_button,
            btn_next => move_cursor_down,
            next_generation => move_cursor_down_edge
        );    
-- mode change button handling
change_mode_button_handler: entity work.NextStateButton
    Port map (
        clk => clk,
        reset => reset_button,
        btn_next => change_mode_button,  -- Use the mode change button
        next_generation => change_mode_button_edge  -- Enable game logic on button press
    );
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
            manual_enable => enable_game_logic,
            automatic_enable => game_clock_edge,
            game_mode     => game_mode,
            next_state    => next_cells_state
        );  
    game_frequency_divider_inst: entity work.clock_divider
    generic map (
        DIV_FACTOR => DIV_FACTOR_GAME_LOGIC 
    )
    port map(
        clk_in => clk,
        reset => reset_button,
        clk_out => game_clock
    );

    clock_divider_inst: entity work.clock_divider
    generic map (
        DIV_FACTOR => DIV_FACTOR_CLOCK  -- Use the defined constant for clock division
    )
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
            game_mode => game_mode,
            cursor_x => cursor_x, 
            cursor_y => cursor_y, 
            display_finished => display_finished,
            hsync => hsync,
            vsync => vsync,
            red => red,
            green => green,
            blue => blue
        );
end Behavioral;
