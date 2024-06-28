library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SM_tb is
end SM_tb;

architecture Behavioral of SM_tb is
    -- Component tanımlama
    component SM
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            serial_in : in STD_LOGIC;
            start : in STD_LOGIC;
            leds : out STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
            wrong_pwd : out STD_LOGIC := '0';
            state_out : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;

    -- testbench ıcın sinyaller
    signal clk_tb : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '0';
    signal start_tb : STD_LOGIC := '0';
    signal serial_in_tb : STD_LOGIC := '0';
    signal leds_tb : STD_LOGIC_VECTOR(11 downto 0);
    signal wrong_pwd_tb : STD_LOGIC;
    signal state_out_tb : STD_LOGIC_VECTOR (1 downto 0);

    -- clock period definition
    constant clk_period : time := 10 ns;

    -- State cesitleri SM entity icin
    type state_type is (initial, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, success, error);
    signal state_tb : state_type := initial;

    -- sabit sifre
    constant password : STD_LOGIC_VECTOR(11 downto 0) := "000000100111";

    -- state to string
    function state_to_string(state: state_type) return string is
    begin
        case state is
            when initial     => return "initial   ";
            when S0       => return "S0     ";
            when S1       => return "S1     ";
            when S2       => return "S2     ";
            when S3       => return "S3     ";
            when S4       => return "S4     ";
            when S5       => return "S5     ";
            when S6       => return "S6     ";
            when S7       => return "S7     ";
            when S8       => return "S8     ";
            when S9       => return "S9     ";
            when S10      => return "S10    ";
            when S11      => return "S11    ";
            when success  => return "success";
            when error    => return "error  ";
            when others   => return "unknown";
        end case;
    end function;

begin
    uut: SM
        Port map (
            clk => clk_tb,
            reset => reset_tb,
            serial_in => serial_in_tb,
            start => start_tb,
            leds => leds_tb,
            wrong_pwd => wrong_pwd_tb,
            state_out => state_out_tb
        );

    -- clock  
    clk_process : process
    begin
        while True loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

   -- Statei  ekranda gosterme
    state_monitor : process (clk_tb, reset_tb)
    begin
        if reset_tb = '1' then
            state_tb <= initial;
        elsif rising_edge(clk_tb) then
            case state_out_tb is
                when "00" => state_tb <= initial;
                when "01" =>
                    case state_tb is
                        when S0 => state_tb <= S1;
                        when S1 => state_tb <= S2;
                        when S2 => state_tb <= S3;
                        when S3 => state_tb <= S4;
                        when S4 => state_tb <= S5;
                        when S5 => state_tb <= S6;
                        when S6 => state_tb <= S7;
                        when S7 => state_tb <= S8;
                        when S8 => state_tb <= S9;
                        when S9 => state_tb <= S10;
                        when S10 => state_tb <= S11;
                        when S11 => state_tb <= initial;
                        when others => state_tb <= initial;
                    end case;
                 when "10" => state_tb <= success;
                when "11" => state_tb <= error;
                when others => state_tb <= initial;
            end case;
        end if;
    end process;

    -- stimulus 
    stim_proc: process
    begin
        -- Reset 
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

        -- test case 1: correct password 
        start_tb <= '1';
        wait for clk_period;
        for i in 0 to 11 loop
            serial_in_tb <= password(i);
            wait for clk_period;
            start_tb <= '0';
        end loop;
        wait for clk_period;
        wait for 50 ns;

        -- test case 2: incorrect password sistem calisirken starta basmanın onemi yok
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';
        for i in 0 to 11 loop
            start_tb <= '0';
            wait for clk_period;
            if i = 2 then
                serial_in_tb <= not password(i);
                start_tb <= '1';
            else
                serial_in_tb <= password(i);
            end if;
        end loop;
        wait for 50 ns;

        -- test case 3: incorrect password 
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

         start_tb <= '1';
        wait for clk_period;
        for i in 0 to 5 loop
            serial_in_tb <= password(i);
            wait for clk_period;
            start_tb <= '0';
        end loop;         
        reset_tb <= '1';  -- applying reset in the middle onemi yok sistem almayacak reseti
        for i in 6 to 11 loop
            wait for clk_period;
            serial_in_tb <= password(i);
            reset_tb <= '0'; 

        end loop;
        wait for 20 ns;
         
        reset_tb <= '1';  -- applying reset in the middle 
        wait for 20 ns;
        reset_tb <= '0';

        -- test case 4: correct password 
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;
        
        start_tb <= '1';
       
        for i in 0 to 11 loop
            wait for clk_period;
            serial_in_tb <= password(i);
             start_tb <= '0';
        end loop;
        wait for 50 ns;

        -- test case 5: incorrect password  reset test ve noraml sifre testi
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';
        for i in 0 to 11 loop
            wait for clk_period;
            if i = 5 then
                    reset_tb <= '1';
                serial_in_tb <= not password(i);
            else
                    reset_tb <= '0';
                serial_in_tb <= password(i);
            end if;
        end loop;
        wait for 50 ns;
       wait;
    end process;

end Behavioral;
