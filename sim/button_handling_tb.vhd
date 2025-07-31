library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NextStateButton_tb is
end NextStateButton_tb;

architecture Behavioral of NextStateButton_tb is
    
    -- Component declaration
    component NextStateButton
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            btn_next : in STD_LOGIC;
            next_generation : out STD_LOGIC
        );
    end component;
    
    -- Signals
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal btn_next : STD_LOGIC := '0';
    signal next_generation : STD_LOGIC;
    
    -- Clock period for 100MHz
    constant clk_period : time := 10 ns;
    
begin
    
    -- Instantiate Unit Under Test
    uut: NextStateButton 
        Port map (
            clk => clk,
            reset => reset,
            btn_next => btn_next,
            next_generation => next_generation
        );
    
    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Test stimulus
    stimulus: process
    begin
        -- Initialize
        reset <= '1';
        btn_next <= '0';
        wait for 20 ns;
        
        -- Release reset
        reset <= '0';
        wait for 50 ns;
        
        -- Test 1: Single button press
        btn_next <= '1';
        wait for 100 ns;  -- Hold button
        btn_next <= '0';
        wait for 50 ns;
        
        -- Test 2: Quick button press
        btn_next <= '1';
        wait for 30 ns;
        btn_next <= '0';
        wait for 50 ns;
        
        -- Test 3: Multiple presses
        btn_next <= '1';
        wait for 40 ns;
        btn_next <= '0';
        wait for 20 ns;
        btn_next <= '1';
        wait for 40 ns;
        btn_next <= '0';
        wait for 50 ns;
        
        report "Test completed" severity note;
        wait;
    end process;
    
end Behavioral;