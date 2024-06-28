library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ClkDiv is
    Port ( clk : in STD_LOGIC;
           clk_div : out STD_LOGIC);
end ClkDiv;

architecture Behavioral of ClkDiv is
    signal count: integer := 0;
    signal clk_tmp: std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
            if count = 50000000 then 
                clk_tmp <= not clk_tmp;
                count <= 0;
            end if;
        end if;
    end process;
    
    clk_div <= clk_tmp;
end Behavioral;