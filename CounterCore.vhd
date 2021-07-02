
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CounterCore is
  Port (rst : in std_logic;
        clk1hz : in std_logic;
        speed100hz : in std_logic;
        sel : in std_logic;
        d33, d32, d31, d30 : out std_logic_vector(3 downto 0);
        d23, d22, d21, d20 : out std_logic_vector(3 downto 0);
        d13, d12, d11, d10 : out std_logic_vector(3 downto 0));
end CounterCore;

architecture Behavioral of CounterCore is
signal min : integer range 0 to 99 := 0;
signal sec : integer range 0 to 59 := 0;
signal go_stop : std_logic:='0';
signal distance : integer range 0 to 9999 := 0;  -- hundred meters
signal money_distance : integer range 0 to 99999 := 0;  -- scaled
signal money_wait : integer range 0 to 99999 := 0;  -- scaled
signal money : integer range 0 to 99999 := 0;  -- scaled
begin

    go_stop <= sel;
    
    process(clk1hz, rst, go_stop)
    begin
--        set_go: represents the modes of the timer. '1': counting mode; 
        if rst='1' then
            min <= 0;
            sec <= 0;
        elsif rising_edge(clk1hz) and go_stop ='0' then
            if sec=59 then  -- this minute is over
                sec <= 0;  -- from 59 second jump to 00
                min <= min + 1;  -- min changes
            else
                sec <= sec + 1;  -- count
            end if;     
        end if;
    end process;
    -- conver to digits: for example, 12:34 will convers to '0001', '0010', '0011', '0100'. sent to decoder to display.
    d13 <= std_logic_vector(to_unsigned (min/10, 4));
    d12 <= std_logic_vector(to_unsigned (min rem 10, 4));
    d11 <= std_logic_vector(to_unsigned (sec/10, 4));
    d10 <= std_logic_vector(to_unsigned (sec rem 10, 4)); 
    
    process(speed100hz, rst, go_stop)
    begin     
        if rst='1' then
            distance <= 0;
        elsif rising_edge(speed100hz) and go_stop='1' then
            distance <= distance + 1;
        end if;
    end process;
    d23 <= std_logic_vector(to_unsigned (distance/1000, 4));
    d22 <= std_logic_vector(to_unsigned ((distance/100) rem 10, 4));
    d21 <= std_logic_vector(to_unsigned ((distance/10) rem 10, 4));
    d20 <= std_logic_vector(to_unsigned (distance rem 10, 4)); 
    
    money_wait <= (sec*10)/4 + min*150;
    money_distance <= 1000 when distance < 30 else
                        1000 + (distance-30)*18 when (distance>=30 and distance<50) else
                        1360 + (distance-50)*27 when distance>=50;
    money <= money_wait + money_distance;
    d33 <= std_logic_vector(to_unsigned (money/10000, 4));
    d32 <= std_logic_vector(to_unsigned ((money/1000) rem 10, 4));
    d31 <= std_logic_vector(to_unsigned ((money/100) rem 10, 4));
    d30 <= std_logic_vector(to_unsigned ((money/10) rem 10, 4)); 
    
end Behavioral;
