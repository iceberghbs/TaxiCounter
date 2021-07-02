
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity MainTaxiCounter is
  Port (clk : in std_logic;  -- in 100Mhz
        sw : in std_logic;
        sw_rst : in std_logic;
        segs_money : out std_logic_vector(6 downto 0);
        segs2 : out std_logic_vector(6 downto 0);
        dp1, dp2 : out std_logic;
        an1, an2 : out std_logic_vector(3 downto 0)
         );
end MainTaxiCounter;

architecture Behavioral of MainTaxiCounter is

component CounterCore
  Port (rst : in std_logic;
        clk1hz : in std_logic;
        speed100hz : in std_logic;
        sel : in std_logic;
        d33, d32, d31, d30 : out std_logic_vector(3 downto 0);
        d23, d22, d21, d20 : out std_logic_vector(3 downto 0);
        d13, d12, d11, d10 : out std_logic_vector(3 downto 0));
end component;

component frq_div
    generic(n:integer:=2);  -- frq_div_coefficient
    Port (  clkin : in STD_LOGIC;
            clkout : out std_logic);
end component;

component mux21
  Port (sel : in std_logic;
        d23, d22, d21, d20 : in std_logic_vector(3 downto 0);
        d13, d12, d11, d10 : in std_logic_vector(3 downto 0);
        d3, d2, d1, d0 : out std_logic_vector(3 downto 0) );
end component;

signal clk1hz, speed100hz, clk1000hz : std_logic;
signal d33, d32, d31, d30 : std_logic_vector(3 downto 0);
signal d23, d22, d21, d20 : std_logic_vector(3 downto 0);
signal d13, d12, d11, d10 : std_logic_vector(3 downto 0);
signal d3, d2, d1, d0 : std_logic_vector(3 downto 0);
signal dp11 : std_logic;
signal dp22 : std_logic;

begin
    inst:CounterCore
        port map(rst=>sw_rst, clk1hz=>clk1hz, speed100hz=>speed100hz, sel=>sw, 
                    d33=>d33, d32=>d32, d31=>d31, d30=>d30,
                    d23=>d23, d22=>d22, d21=>d21, d20=>d20,
                    d13=>d13, d12=>d12, d11=>d11, d10=>d10);
                   
    inst_mux:mux21 
        port map(sel=>sw,
                    d23=>d23, d22=>d22, d21=>d21, d20=>d20,
                    d13=>d13, d12=>d12, d11=>d11, d10=>d10,
                    d3=>d3, d2=>d2, d1=>d1, d0=>d0);
                    
    div_1hz:frq_div
        generic map(n=>100000000)  -- 100000000
        port map(clkin=>clk, clkout=>clk1hz);
        
    div_100hz:frq_div
        generic map(n=>1000000)  -- 1000000
        port map(clkin=>clk, clkout=>speed100hz);
        
    div_1000hz:frq_div
        generic map(n=>100000)  -- 100000
        port map(clkin=>clk, clkout=>clk1000hz);
        
    four_digits_money : entity work.four_digits(Behavioral)
            port map (d3=>d33, d2=>d32, d1=>d31, d0=>d30, ck=>clk1000hz, 
                        seg=>segs_money, an=>an1, dp=>dp11);
                        
    four_digits2 : entity work.four_digits(Behavioral2)
            port map (d3=>d3, d2=>d2, d1=>d1, d0=>d0, ck=>clk1000hz, 
                        seg=>segs2, an=>an2, dp=>dp22);
             
    dp1 <= dp11;           
    dp2 <= dp22 when sw='0' else dp11;
            
end Behavioral;
