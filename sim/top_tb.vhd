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
-- Description: Testbench for top entity (Game of Life with VGA output)
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
    
    -- Helper procedure to wait for a certain number of clock cycles
    procedure wait_cycles(cycles : integer) is
    begin
        for i in 1 to cycles loop
            wait until rising_edge(clk);
        end loop;
    end procedure;

    -- Helper procedure to pulse a signal for one clock cycle
    procedure pulse_signal(signal sig : out STD_LOGIC) is
    begin
        wait until rising_edge(clk);
        sig <= '1';
        wait until rising_edge(clk);
        sig <= '0';
    end procedure;

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

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Print start message
        report "Starting testbench for top entity" severity note;
        
        -- Initialize Inputs
        reset_button <= '0';
        next_state_button <= '0';
        
        -- Wait for global reset
        wait for 100 ns;
        
        -- Test 1: Reset functionality
        report "Test 1: Testing reset functionality" severity note;
        pulse_signal(reset_button);
        wait_cycles(10);
        
        -- Test 2: Normal operation - trigger next state
        report "Test 2: Testing next state button functionality" severity note;
        pulse_signal(next_state_button);
        wait_cycles(20);
        
        -- Test 3: Multiple state transitions
        report "Test 3: Testing multiple state transitions" severity note;
        for i in 1 to 5 loop
            pulse_signal(next_state_button);
            wait_cycles(20);
            report "Completed state transition " & integer'image(i) severity note;
        end loop;
        
        -- Test 4: Reset during operation
        report "Test 4: Testing reset during operation" severity note;
        pulse_signal(next_state_button);
        wait_cycles(10);
        pulse_signal(reset_button);
        wait_cycles(20);
        
        -- Test 5: Rapid button presses
        report "Test 5: Testing rapid button presses" severity note;
        for i in 1 to 3 loop
            pulse_signal(next_state_button);
            wait_cycles(2);
        end loop;
        wait_cycles(20);
        
        -- Test 6: VGA timing observation
        report "Test 6: Observing VGA timing signals" severity note;
        -- Wait for several VGA frames to observe hsync and vsync behavior
        wait_cycles(1000);
        
        -- Test 7: Extended operation
        report "Test 7: Extended operation test" severity note;
        for i in 1 to 10 loop
            pulse_signal(next_state_button);
            wait_cycles(50);
            
            -- Check that VGA signals are active
            assert hsync = '0' or hsync = '1' 
                report "hsync signal appears to be undefined" severity warning;
            assert vsync = '0' or vsync = '1' 
                report "vsync signal appears to be undefined" severity warning;
                
            -- Report color output (just for observation)
            if i mod 3 = 0 then
                report "Color output - Red: " & integer'image(to_integer(unsigned(red))) &
                       ", Green: " & integer'image(to_integer(unsigned(green))) &
                       ", Blue: " & integer'image(to_integer(unsigned(blue))) 
                       severity note;
            end if;
        end loop;
        
        -- Test 8: Hold buttons for extended time
        report "Test 8: Testing extended button hold" severity note;
        next_state_button <= '1';
        wait_cycles(50);
        next_state_button <= '0';
        wait_cycles(20);
        
        reset_button <= '1';
        wait_cycles(50);
        reset_button <= '0';
        wait_cycles(20);
        
        -- Final test: Let system run freely
        report "Test 9: Free running system observation" severity note;
        wait_cycles(500);
        
        -- End simulation
        report "Testbench completed successfully" severity note;
        wait;
    end process;

    -- Monitor process to observe key signals
    monitor_proc: process
        variable frame_count : integer := 0;
        variable last_vsync : STD_LOGIC := '0';
    begin
        wait until rising_edge(clk);
        
        -- Count VGA frames
        if vsync = '1' and last_vsync = '0' then
            frame_count := frame_count + 1;
            if frame_count mod 100 = 0 then
                report "VGA Frame count: " & integer'image(frame_count) severity note;
            end if;
        end if;
        last_vsync := vsync;
        
        -- Monitor for any undefined outputs
        if red = "UUUU" then
            report "Red output is undefined" severity warning;
        end if;
        if green = "UUUU" then
            report "Green output is undefined" severity warning;
        end if;
        if blue = "UUUU" then
            report "Blue output is undefined" severity warning;
        end if;
    end process;

end Behavioral;