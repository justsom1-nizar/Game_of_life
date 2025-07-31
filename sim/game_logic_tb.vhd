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
            clk           : in  STD_LOGIC;    -- ADD THIS
            reset         : in  STD_LOGIC;    -- ADD THIS
            current_state : in  t_state;
            enable        : in  STD_LOGIC;
            next_state    : out t_state
        );
    end component;

    -- Clock and reset signals
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    
    -- Inputs
    signal current_state : t_state := (others => (others => '0'));
    signal enable        : STD_LOGIC := '0';
    
    -- Outputs
    signal next_state : t_state := (others => (others => '0'));
    
    -- Clock period definition
    constant clk_period : time := 10 ns; -- 100MHz

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: game_logic 
        Port map (
            clk           => clk,
            reset         => reset,
            current_state => current_state,
            enable        => enable,
            next_state    => next_state
        );

    -- ADD THIS: Clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        report "Starting Simple 4x4 Game of Life Test" severity note;
        
        -- Wait for initialization
        wait for 5 ns;
        
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;
        
        -- Set up initial state
        current_state <= (
            0  => (others => '0'),
            1  => (others => '0'),
            2  => (others => '0'),
            3  => (others => '1'),
            4  => (others => '0'),
            5  => (others => '0'),
            6  => (others => '0'),
            7  => (others => '0'),
            8  => (others => '0'),
            9  => (others => '0'),
            10 => (others => '0'),
            11 => (others => '0'),
            12 => (others => '0'),
            13 => (others => '0'),
            14 => (others => '0'),
            15 => (others => '0')
        );
        
        wait for 20 ns;
        
        -- Apply enable pulse and wait for rising edge
        wait until rising_edge(clk);
        enable <= '1';
        wait until rising_edge(clk);
        enable <= '0';
        
        -- Wait for computation to complete
        wait for 50 ns;
        
        report "Evolution complete. Check the output above." severity note;
        
        wait;
    end process;

end Behavioral;