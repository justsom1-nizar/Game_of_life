library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.game_of_life_pkg.all;
entity vga_controller is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        pixel_state : in  t_pixel_array; 
        hsync       : out STD_LOGIC;
        vsync       : out STD_LOGIC;
        red         : out STD_LOGIC_VECTOR(3 downto 0);
        green       : out STD_LOGIC_VECTOR(3 downto 0);
        blue        : out STD_LOGIC_VECTOR(3 downto 0)
    );
end vga_controller;

architecture Behavioral of vga_controller is
    signal divided_clock : STD_LOGIC := '0';
    signal h_count : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal v_count : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal h_sync_pulse : STD_LOGIC := '0';
    signal v_sync_pulse : STD_LOGIC := '0';
    signal h_tc : STD_LOGIC := '0';
    signal is_display_region_h : STD_LOGIC := '0';
    signal is_display_region_v : STD_LOGIC := '0';
    signal is_display_region : STD_LOGIC := '0';

    begin
    -- Instantiate the clock divider directly
    clk_div_inst : entity work.clock_divider
        Port map (
            clk_in  => clk,
            reset   => rst,
            clk_out => divided_clock
        );
    -- Instantiate the horizontal counter
    horizental_counter_inst : entity work.horizental_counter
        Port map (
            clk       => divided_clock,
            reset     => rst,
            count     => h_count,
            tc        => h_tc
        );
    -- Instantiate the vertical counter
    vertical_counter_inst : entity work.vertical_counter
        Port map (
            clk         => divided_clock,
            reset       => rst,
            TC_enable   => h_tc,
            count       => v_count
        );
    -- Generate horizontal sync pulse
    interval_comparator_inst_h : entity work.interval_comparator
        Port map (
            lower_bound_first  => H_FIRST_SYNC_START, 
            upper_bound_first  => H_FIRST_SYNC_END,
            lower_bound_second => H_LAST_SYNC_START,
            upper_bound_second => H_LAST_SYNC_END,
            input_value        => h_count,
            is_within          => h_sync_pulse
        );
    hsync <= h_sync_pulse;    
    -- Generate vertical sync pulse
    interval_comparator_inst_v : entity work.interval_comparator
        Port map (
            lower_bound_first  => H_FIRST_SYNC_START, 
            upper_bound_first  => V_FIRST_SYNC_END,
            lower_bound_second => V_LAST_SYNC_START,
            upper_bound_second => V_LAST_SYNC_END,
            input_value        => v_count,
            is_within          => v_sync_pulse
        );
    vsync <= v_sync_pulse;
    -- Is it at horizental display area?
    interval_comparator_inst_display_h: entity work.interval_comparator
     port map(
        lower_bound_first  => H_FIRST_SYNC_START,
        upper_bound_first  => H_DISPLAY_END,
        lower_bound_second => H_FIRST_SYNC_START,
        upper_bound_second => H_DISPLAY_END,
        input_value        => h_count,
        is_within          => is_display_region_h
    );
    -- IS it at vertical display area?
    interval_comparator_inst_display_v: entity work.interval_comparator
        port map(
        lower_bound_first  => V_DISPLAY_START,
        upper_bound_first  => V_DISPLAY_END,
        lower_bound_second => V_DISPLAY_START,
        upper_bound_second => V_DISPLAY_END,
        input_value        => v_count,
        is_within          => is_display_region_v
        );
    is_display_region <= is_display_region_h and is_display_region_v;
    -- Set color output based on display region
    process(is_display_region, h_count, v_count, pixel_state) 
    variable x : integer ;
    variable y : integer ;
    begin
        x := to_integer(unsigned(h_count)) - to_integer(unsigned(H_DISPLAY_START));
        y := to_integer(unsigned(v_count)) - to_integer(unsigned(V_DISPLAY_START));
        if is_display_region = '1' then
            if x >= 0 and x < GRID_SIZE and y >= 0 and y < GRID_SIZE then
                if pixel_state(y, x) = '1' then
                    red   <= "1111";
                    green <= "1111";
                    blue  <= "0000";
                else
                    red   <= "0000";
                    green <= "0000";
                    blue  <= "0000";
                end if;
        end if;
        else
            red   <= "0000";
            green <= "0000";
            blue  <= "0000";
        end if;
    end process;    
end architecture Behavioral;