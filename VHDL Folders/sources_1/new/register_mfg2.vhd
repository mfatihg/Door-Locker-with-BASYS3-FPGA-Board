library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_data is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (11 downto 0);
           enable : in STD_LOGIC;
           start : in STD_LOGIC;
           serial_out : out STD_LOGIC := '0';
           reg_data_out : out STD_LOGIC_VECTOR (11 downto 0);
           shift_enable_out : out STD_LOGIC := '0';
           wrong_pwd_reg : in STD_LOGIC;
           seven_segment_out : out STD_LOGIC_VECTOR (11 downto 0));
end Register_data;

architecture Behavioral of Register_data is
    signal reg_data: std_logic_vector(11 downto 0) := (others => '0');
    signal shift_enable: std_logic := '0';
    signal bit_counter: integer range 0 to 12 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
                 if wrong_pwd_reg = '1' or bit_counter = 0 or bit_counter= 12 then
                    if reset = '1' then
                    reg_data <= (others => '0');
                    shift_enable <= '0';
                    bit_counter <= 0;
                    serial_out <= '0';
                    seven_segment_out <= (others => '0'); 
                    end if;
                 end if;
                 if bit_counter = 0 and wrong_pwd_reg = '0' then
                     if enable = '1' then
                     reg_data <= data_in;
                     seven_segment_out <= data_in;
                     end if;
                 end if;
                if start = '1' or shift_enable = '1' then
                     if bit_counter /= 12 and wrong_pwd_reg = '0' then
                        shift_enable <= '1';
                        reg_data <=  '0' & reg_data(11 downto 1);
                        bit_counter <= bit_counter + 1;  
                        serial_out <= reg_data(0);
                        
                     else 
                        shift_enable <= '0';
                        -- serial out da s f r yap lablir burada
                     end if;
                     
              end if;
                    if bit_counter = 12 then
                        shift_enable <= '0';
                        -- burada da serial_out s f rlanabilir
                    end if;
          end if;
                    

    end process;
         reg_data_out <= reg_data;
         shift_enable_out <= shift_enable;


end Behavioral;
