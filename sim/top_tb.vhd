----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/29/2025
-- Design Name: 
-- Module Name: top_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Simple testbench for Game of Life with VGA output
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

entity top_tb is
end top_tb;

architecture Behavioral of top_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component top
        Port (
            clk               : in  STD_LOGIC;
            reset_button      : in  STD_LOGIC;
            next_state_button : in  STD_LOGIC;
            hsync             : out STD_LOGIC;
            vsync             : out STD_LOGIC;
            red               : out STD_LOGIC_VECTOR(3 downto 0);
            green             : out STD_LOGIC_VECTOR(3 downto 0);
            blue              : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Inputs
    signal clk               : STD_LOGIC := '0';
    signal reset_button      : STD_LOGIC := '0';
    signal next_state_button : STD_LOGIC := '0';

    -- Outputs
    signal hsync  : STD_LOGIC;
    signal vsync  : STD_LOGIC;
    signal red    : STD_LOGIC_VECTOR(3 downto 0);
    signal green  : STD_LOGIC_VECTOR(3 downto 0);
    signal blue   : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns; -- 100 MHz clock

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: top 
        Port map (
            clk               => clk,
            reset_button      => reset_button,
            next_state_button => next_state_button,
            hsync             => hsync,
            vsync             => vsync,
            red               => red,
            green             => green,
            blue              => blue
        );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Simple stimulus process
    stim_proc: process
    begin		
        -- Initialize inputs
        reset_button <= '0';
        next_state_button <= '0';
        
        report "Starting simple Game of Life testbench" severity note;
        
        -- Apply reset
        wait for 100 ns;
        reset_button <= '1';
        wait for 50 ns;
        reset_button <= '0';
        report "Reset applied" severity note;
        
        -- Wait 1 second for system to stabilize
        wait for 30 ms;
        report "System stabilized - ready for button press" severity note;
        
        -- Press next state button
        next_state_button <= '1';
        wait for 20 ms;  -- Hold button for 20ms (realistic button press)
        next_state_button <= '0';
        report "Next state button pressed" severity note;
        
        -- Wait and observe
        wait for 30 ms;
        
        -- Press button again
        next_state_button <= '1';
        wait for 20 ms;
        next_state_button <= '0';
        report "Second button press" severity note;
        
        -- Wait and finish
        wait for 1 sec;
        report "Testbench completed" severity note;
        
        wait; -- End simulation
    end process;

end Behavioral;