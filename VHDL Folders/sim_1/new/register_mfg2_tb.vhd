
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Register_data is
end tb_Register_data;

architecture Behavioral of tb_Register_data is
    component Register_data
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable : in STD_LOGIC;
               start : in STD_LOGIC;
               data_in : in STD_LOGIC_VECTOR (11 downto 0);
               serial_out : out STD_LOGIC;
               reg_data_out : out STD_LOGIC_VECTOR (11 downto 0);
               shift_enable_out : out STD_LOGIC;
               wrong_pwd_reg : in STD_LOGIC);
    end component;

    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal data_in : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    signal serial_out : STD_LOGIC := '0';
    signal reg_data_out : STD_LOGIC_VECTOR (11 downto 0);
    signal shift_enable_out : STD_LOGIC := '0';
    signal wrong_pwd_reg : STD_LOGIC := '0';

    constant clk_period : time := 10 ns;



    -- Function to convert std_logic_vector to string
    function to_string(slv: std_logic_vector) return string is
        variable result: string(1 to slv'length);
    begin
        for i in slv'range loop
            if slv(i) = '1' then
                result(result'length - i) := '1';
            else
                result(result'length - i) := '0';
            end if;
        end loop;
        return result;
    end function;

begin


    uut: Register_data
    Port map (
        clk => clk,
        reset => reset,
        data_in => data_in,
        enable => enable,
        start => start,
        serial_out => serial_out,
        reg_data_out => reg_data_out,
        shift_enable_out => shift_enable_out,
        wrong_pwd_reg => wrong_pwd_reg  
    );

    
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;


    stim_proc: process
    begin
        --  reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        wait for clk_period*2;
        
        -- test1 
        data_in <= "101010101010";
        enable <= '1';
        wait for clk_period;
        enable <= '0';
     
        wait for clk_period*2;
        
        reset <= '1';   -- enableden hemen sorna reset testi
        wait for 20 ns;
        reset <= '0';

        start <= '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period*12;  
        
        wait for clk_period*2;

        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        wait for clk_period;  
        data_in <= "000000000000";
        wait for clk_period;

        -- test 3:  yanl s sifre durumunda gozlemleme
        data_in <= "010011001101";
        enable <= '1';
        wait for clk_period;
        enable <= '0';
        
        wait for clk_period*2;
        
        start <= '1';
        wait for clk_period*2;
        wrong_pwd_reg <= '1';  -- yanlis sifre
        start <= '0';
        wait for clk_period*4;
        start <= '1';
        wait for clk_period;
        start <= '0';
        enable <= '1';
        wait for clk_period;
        enable <= '0';
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for clk_period;
        wrong_pwd_reg <= '0';
                
        wait for clk_period;  
        data_in <= "000000000000";
        wait for clk_period;

        -- test 4:  sistem calisirken start enable veya resete basma testi (islevsiz olacaklar)
        data_in <= "011100001110";
        enable <= '1';
        wait for clk_period;
        enable <= '0';
               
        start <= '1';
        wait for clk_period*2;
        start <= '0';
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        wait for clk_period*10;  
        data_in <= "000000000000";
        wait for clk_period*5;

        -- test 5: tam shiftten sonra yani dogru sifreden sonra reset yapmadan veri alamazs n testi
        data_in <= "000011110000";
        enable <= '1';
        wait for clk_period;
        enable <= '0';
        
        start <= '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period*15;  
        wait for clk_period*2;
       
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for clk_period*2; 


        wait for clk_period;  
        data_in <= "000000000000";
        wait for clk_period;

        -- test 6: enable 1ken reset high
        data_in <= "000000100111";
        enable <= '1';
        wait for clk_period;
        enable <= '0';
        start <= '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period*12;
       

        wait;
    end process;

    monitor_proc: process
    begin
        while true loop
            wait for clk_period;
            report "reg_data = " & to_string(reg_data_out) & 
                   ", serial_out = " & std_logic'IMAGE(serial_out) &
                   ", shift_enable = " & std_logic'IMAGE(shift_enable_out);
        end loop;
    end process;

end Behavioral;
