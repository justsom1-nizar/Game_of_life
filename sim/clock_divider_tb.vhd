----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/31/2025
-- Design Name: 
-- Module Name: clock_divider_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for clock_divider entity
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

entity clock_divider_tb is
end clock_divider_tb;

architecture Behavioral of clock_divider_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component clock_divider
        Port (
            clk_in  : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

    -- Inputs
    signal clk_in  : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '0';
    
    -- Outputs
    signal clk_out : STD_LOGIC;
    
    -- Clock period for 100MHz input clock
    constant CLK_PERIOD : time := 10 ns;  -- 100MHz = 10ns period
    
    -- Variables for monitoring
    signal clk_out_prev : STD_LOGIC := '0';
    signal toggle_count : integer := 0;
    signal input_cycles : integer := 0;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: clock_divider 
        Port map (
            clk_in  => clk_in,
            reset   => reset,
            clk_out => clk_out
        );

    -- Clock generation process (100MHz)
    clk_process: process
    begin
        clk_in <= '0';
        wait for CLK_PERIOD/2;
        clk_in <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Count input clock cycles
    cycle_counter: process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                input_cycles <= 0;
            else
                input_cycles <= input_cycles + 1;
            end if;
        end if;
    end process;
    
    -- Monitor output clock toggles
    toggle_monitor: process(clk_out)
    begin
        clk_out_prev <= clk_out;
        if clk_out /= clk_out_prev then
            toggle_count <= toggle_count + 1;
            report "Output clock toggled at input cycle: " & integer'image(input_cycles) 
                   & ", toggle count: " & integer'image(toggle_count) severity note;
        end if;
    end process;

    -- Stimulus process
    stim_proc: process
        variable expected_toggles : integer;
    begin		
        report "Starting Clock Divider Testbench" severity note;
        report "Input Clock: 100MHz (10ns period)" severity note;
        report "Division Factor: " & integer'image(DIV_FACTOR) severity note;
        
        -- Initialize
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        
        report "Reset released, starting clock division test..." severity note;
        
        -- Let it run for enough cycles to see several output toggles
        -- Each output toggle should occur every DIV_FACTOR input cycles
        wait for CLK_PERIOD * DIV_FACTOR * 4;  -- Wait for 4 complete output cycles
        
        -- Check if we got expected number of toggles
        expected_toggles := 4;  -- Should have 4 toggles in 4 complete cycles
        
        report "Test completed after " & integer'image(input_cycles) & " input cycles" severity note;
        report "Expected toggles: " & integer'image(expected_toggles) severity note;
        report "Actual toggles: " & integer'image(toggle_count) severity note;
        
        if toggle_count >= expected_toggles - 1 and toggle_count <= expected_toggles + 1 then
            report "PASS: Clock division working correctly" severity note;
        else
            report "FAIL: Unexpected number of output toggles" severity error;
        end if;
        
        -- Test reset functionality
        report "Testing reset functionality..." severity note;
        reset <= '1';
        wait for 50 ns;
        
        assert clk_out = '0' 
            report "FAIL: Output should be '0' during reset" 
            severity error;
        
        reset <= '0';
        wait for 100 ns;
        
        report "Reset test completed" severity note;
        
        -- Calculate actual output frequency
        report "=== FREQUENCY ANALYSIS ===" severity note;
        report "Input frequency: 100 MHz" severity note;
        report "Expected output frequency: " & 
               integer'image(100000000 / (DIV_FACTOR * 2)) & " Hz" severity note;
        report "Each output toggle should occur every " & 
               integer'image(DIV_FACTOR) & " input cycles" severity note;
        
        wait;
    end process;

end Behavioral;