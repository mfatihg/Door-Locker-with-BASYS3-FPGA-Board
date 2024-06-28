library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pulse_extender is
    port(
        clk : in std_logic;
        pulse_in : in std_logic;
        pulse_out : out std_logic
    );
end pulse_extender;

architecture behavioural of pulse_extender is
    constant pulse_duration : integer := 100000000; 
    signal count : integer := 0;
    signal extended_pulse : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if pulse_in = '1' then
                extended_pulse <= '1';
                count <= 0;
            elsif count < pulse_duration then
                count <= count + 1;
            else
                extended_pulse <= '0';
            end if;
        end if;
    end process;
    pulse_out <= extended_pulse;
end behavioural;
