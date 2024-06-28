library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SM is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           serial_in : in STD_LOGIC;
           start : in STD_LOGIC;
           leds : out STD_LOGIC_VECTOR (11 downto 0);
           wrong_pwd : out STD_LOGIC;
           state_out : out STD_LOGIC_VECTOR (1 downto 0));
end SM;

architecture Behavioral of SM is
    type state_type is (initial, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, success, error);
    signal state: state_type := initial;
    constant password: std_logic_vector(11 downto 0) := "000000100111"; 

    function state_to_std_logic_vector(state: state_type) return std_logic_vector is
    begin
        case state is
            when initial => return "00";
            when S0 => return "01";
            when S1 => return "01";
            when S2 => return "01";
            when S3 => return "01";
            when S4 => return "01";
            when S5 => return "01";
            when S6 => return "01";
            when S7 => return "01";
            when S8 => return "01";
            when S9 => return "01";
            when S10 => return "01";
            when S11 => return "01";
            when success => return "10";
            when error => return "11";
        end case;
    end function;

begin
    process(clk, reset)
    begin  
        if rising_edge(clk) then
            case state is
                when initial =>
                    leds <= (others => '0');
                    wrong_pwd <= '0';
                    if start = '1' then
                        state <= S0;
                    end if;
                when S0 =>
                    if serial_in = password(0) then
                        leds(0) <= '1';
                        state <= S1;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S1 =>
                    if serial_in = password(1) then
                        leds(1) <= '1';
                        state <= S2;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S2 =>
                    if serial_in = password(2) then
                        leds(2) <= '1';
                        state <= S3;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S3 =>
                    if serial_in = password(3) then
                        leds(3) <= '1';
                        state <= S4;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S4 =>
                    if serial_in = password(4) then
                        leds(4) <= '1';
                        state <= S5;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S5 =>
                    if serial_in = password(5) then
                        leds(5) <= '1';
                        state <= S6;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S6 =>
                    if serial_in = password(6) then
                        leds(6) <= '1';
                        state <= S7;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S7 =>
                    if serial_in = password(7) then
                        leds(7) <= '1';
                        state <= S8;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S8 =>
                    if serial_in = password(8) then
                        leds(8) <= '1';
                        state <= S9;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S9 =>
                    if serial_in = password(9) then
                        leds(9) <= '1';
                        state <= S10;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S10 =>
                    if serial_in = password(10) then
                        leds(10) <= '1';
                        state <= S11;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when S11 =>
                    if serial_in = password(11) then
                        leds(11) <= '1';
                        state <= success;
                    else
                        wrong_pwd <= '1';
                        state <= error;
                    end if;
                when success =>
                    state <= success;
                    if reset = '1' then
                    leds <= (others => '0');
                    wrong_pwd <= '0';
                    state <= initial;
                    end if;
                when error =>
                    state <= error;
                    if reset = '1' then
                    leds <= (others => '0');
                    wrong_pwd <= '0';
                    state <= initial;
                    end if;
            end case;
        end if;
    end process;

    state_out <= state_to_std_logic_vector(state);
end Behavioral;
