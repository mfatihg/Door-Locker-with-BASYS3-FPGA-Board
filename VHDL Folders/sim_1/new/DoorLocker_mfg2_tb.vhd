library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel_tb is
end TopLevel_tb;

architecture Behavioral of TopLevel_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal BTNR : std_logic := '0';
    signal BTNL : std_logic := '0';
    signal serial_out_dummy : std_logic;
    signal sw : std_logic_vector(11 downto 0) := (others => '0');
    signal leds : std_logic_vector(11 downto 0);
    signal wrong_pwd : std_logic;
    signal clk_div : std_logic;
    constant clk_period : time := 10 ns;

    component TopLevel
        Port (
            clk : in std_logic;
            reset : in std_logic;
            sw : in std_logic_vector(11 downto 0);
            BTNR : in std_logic;
            BTNL : in std_logic;
            leds : out std_logic_vector(11 downto 0);
            wrong_pwd : out std_logic;
            clk_div : out std_logic;
            serial_out_dummy : out std_logic
        );
    end component;

begin
        -- uut

    uut: TopLevel
        Port map (
            clk => clk,
            reset => reset,
            sw => sw,
            BTNR => BTNR,
            BTNL => BTNL,
            leds => leds,
            wrong_pwd => wrong_pwd,
            clk_div => clk_div,
            serial_out_dummy => serial_out_dummy
        );


    clk_process :process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus 
    stim_proc: process
    begin

        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        --  correct password
        sw <= "000000100111"; 
        BTNR <= '1';
        wait for clk_period ;
        BTNR <= '0';
        wait for clk_period;
        BTNL <= '1';
        wait for clk_period ; 
        BTNL <= '0';
        wait for clk_period;
        
        -- Check expected results
        assert (leds = "111111111111") report "LEDs do not match expected value after correct password." severity error;
        assert (wrong_pwd = '0') report "wrong_pwd should be 0 after correct password." severity error;
        -- Observe internal signals
        assert (serial_out_dummy = '0') report "serial_out does not match expected value." severity error; -- Adjust the expected value as needed
        wait for clk_period*12;

        -- Reset 
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        --  incorrect password
        sw <= "111111111111"; 
        BTNR <= '1';
        wait for clk_period * 2;
        BTNR <= '0';
        wait for clk_period;
        BTNL <= '1';
        wait for clk_period; 
        BTNL <= '0';
        wait for clk_period*12;

        -- Check expected results
        assert (leds /= "111111111111") report "LEDs should not match expected value after incorrect password." severity error;
        assert (wrong_pwd = '1') report "wrong_pwd should be 1 after incorrect password." severity error;

        -- Reset 
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        --  correct password check ederken resete enable veya starta basman n onemi yok ignore edilecek
        sw <= "000000100111"; 
        BTNR <= '1';
        wait for clk_period * 2;
        BTNR <= '0';
        wait for clk_period;
        BTNL <= '1';
        wait for clk_period; 
        BTNL <= '0';
        wait for clk_period*12; 
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Check expected results
        assert (leds /= "001010101001") report "LEDs should not match expected value after incorrect password." severity error;
        assert (wrong_pwd = '1') report "wrong_pwd should be 1 after incorrect password." severity error;

        -- Reset 
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        --  incorrect password sistem chech ederken resete enable veya starta basman n onemi yok ignore edilecek
        sw <= "000001100111"; 
        BTNR <= '1';
        wait for clk_period * 2;
        BTNR <= '0';
        wait for clk_period;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        BTNL <= '1';
        wait for clk_period; 
        BTNL <= '0';
        BTNR <= '1';
        wait for clk_period;
        BTNR <= '0';
        wait for clk_period*12;

        -- Check expected results
        assert (leds /= "000001100111") report "LEDs should not match expected value after incorrect password." severity error;
        assert (wrong_pwd = '1') report "wrong_pwd should be 1 after incorrect password." severity error;

        wait;
    end process;

end Behavioral;