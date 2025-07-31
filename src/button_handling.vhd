-- Simple Next State Button Handler
-- Handles a single button to advance to next generation

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NextStateButton is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        btn_next : in STD_LOGIC;           -- Physical button input
        next_generation : out STD_LOGIC    -- Pulse to advance one generation
    );
end NextStateButton;

architecture Behavioral of NextStateButton is
    
    -- Button synchronization register (for debouncing)
    signal btn_sync : STD_LOGIC_VECTOR(2 downto 0) := "000";
    
begin

    -- Button synchronization and debouncing process
    button_process: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                btn_sync <= "000";
            else
                -- Shift register: shifts left and adds new button state
                btn_sync <= btn_sync(1 downto 0) & btn_next;
            end if;
        end if;
    end process;
    
    -- Generate pulse on rising edge (button press)
    -- Rising edge detected when pattern is "011" (was 0, now 1, stable)
    next_generation <= '1' when btn_sync = "011" else '0';

end Behavioral;