library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity interval_comparator is
    Port (
        lower_bound_first : in  STD_LOGIC_VECTOR(9 downto 0); -- 10-bit lower bound
        upper_bound_first : in  STD_LOGIC_VECTOR(9 downto 0); -- 10-bit upper bound
        lower_bound_second : in  STD_LOGIC_VECTOR(9 downto 0); -- 10-bit lower bound (not used)
        upper_bound_second : in  STD_LOGIC_VECTOR(9 downto 0);

        input_value : in  STD_LOGIC_VECTOR(9 downto 0); -- 10-bit input value
        is_within   : out STD_LOGIC                  -- Output: '1' if within interval, '0' otherwise
    );
end interval_comparator;

architecture Behavioral of interval_comparator is
begin
    process(input_value, lower_bound_first, upper_bound_first, lower_bound_second, upper_bound_second)
        variable lower_bound_first_int : integer;
        variable upper_bound_first_int : integer;
        variable lower_bound_second_int : integer;
        variable upper_bound_second_int : integer;
        variable input_value_int : integer;
    begin
        -- Convert STD_LOGIC_VECTOR to integer
        lower_bound_first_int := to_integer(unsigned(lower_bound_first));
        upper_bound_first_int := to_integer(unsigned(upper_bound_first));
        lower_bound_second_int := to_integer(unsigned(lower_bound_second));
        upper_bound_second_int := to_integer(unsigned(upper_bound_second));
        input_value_int := to_integer(unsigned(input_value));

        -- Check if input_value is within the interval
        if ((input_value_int >= lower_bound_first_int) and (input_value_int <= upper_bound_first_int)) or
           (input_value_int >= lower_bound_second_int and input_value_int <= upper_bound_second_int) then
            is_within <= '1';
        else
            is_within <= '0';
        end if;
    end process;
end Behavioral;