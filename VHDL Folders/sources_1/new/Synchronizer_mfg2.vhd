library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    port(
        clk : in std_logic;
        btn : in std_logic;
        btn_clr : out std_logic
    );
end debouncer;

architecture behavioural of debouncer is
    constant delay : integer := 650000; -- 6.5ms debounce for 100 MHz clock
    signal count : integer := 0;
    signal btn_tmp : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (btn /= btn_tmp) then
                btn_tmp <= btn;
                count <= 0;
            elsif (count = delay) then
                btn_clr <= btn_tmp;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end behavioural;
