----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2025
-- Design Name: 
-- Module Name: simple_game_logic_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Simple testbench for 4x4 Conway's Game of Life
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

entity simple_game_logic_tb is
end simple_game_logic_tb;

architecture Behavioral of simple_game_logic_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component game_logic
        Port (
            current_state : in t_state;
            enable        : in STD_LOGIC;
            next_state    : out t_state
        );
    end component;

    -- Inputs
    signal current_state : t_state := (others => (others => '0'));
    signal enable        : STD_LOGIC := '0';

    -- Outputs
    signal next_state : t_state := (others => (others => '0'));

    -- Helper procedure to print the 4x4 grid
    procedure print_grid(state : t_state; name : string) is
        variable line : string(1 to 8); -- 4 chars + 3 spaces + null
    begin
        report "=== " & name & " ===" severity note;
        for row in 0 to 3 loop
            line := "        "; -- Initialize with spaces
            for col in 0 to 3 loop
                if state(row, col) = '1' then
                    line(col*2 + 1) := 'X';
                else
                    line(col*2 + 1) := '.';
                end if;
                if col < 3 then
                    line(col*2 + 2) := ' ';
                end if;
            end loop;
            report line(1 to 7) severity note;
        end loop;
        report "=================" severity note;
    end procedure;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: game_logic 
        Port map (
            current_state => current_state,
            enable        => enable,
            next_state    => next_state
        );

    -- Stimulus process
    stim_proc: process
    begin		
        report "Starting Simple 4x4 Game of Life Test" severity note;
        
        -- Wait for initialization
        wait for 5 ns;
        
        -- Manually set up initial state
        -- You can modify this pattern as needed
        -- Example: Creating a simple blinker pattern in 4x4 grid
        current_state <= (
            0 => ('1', '1', '1', '1'),  -- Row 0: . X . .
            1 => ('0', '0', '0', '0'),  -- Row 1: . X . .
            2 => ('0', '0', '0', '0'),  -- Row 2: . X . .
            3 => ('0', '0', '0', '0')   -- Row 3: . . . .
        );
        
        -- Print initial state
        print_grid(current_state, "INITIAL STATE");
        
        -- Wait a bit for signals to settle
        wait for 10 ns;
        
        -- Apply enable pulse
        enable <= '1';
        wait for 10 ns;
        enable <= '0';
        
        -- Wait for computation to complete
        wait for 20 ns;
        
        -- Print result
        print_grid(next_state, "NEXT STATE");
        
        -- Count live cells in result
        report "Evolution complete. Check the output above." severity note;
        
        wait;
    end process;

end Behavioral;