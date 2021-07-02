
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity MainTaxiCounter_tb is
--  Port ( );
end MainTaxiCounter_tb;

architecture Behavioral of MainTaxiCounter_tb is

component MainTaxiCounter
  Port (clk : in std_logic;  -- in 100Mhz
        sw : in std_logic;
        sw_rst : in std_logic;
        segs_money : out std_logic_vector(6 downto 0);
        segs2 : out std_logic_vector(6 downto 0);
        dp1, dp2 : out std_logic;
        an1, an2 : out std_logic_vector(3 downto 0)
         );
end component;

signal clk_in : std_logic := '0';
signal sw_in : std_logic;
signal sw_in2 : std_logic;
signal seg_out : STD_LOGIC_VECTOR(6 downto 0); 
signal seg_out2 : STD_LOGIC_VECTOR(6 downto 0); 
signal dp_out : STD_LOGIC;
signal an_out : STD_LOGIC_VECTOR(3 downto 0);
signal dp_out2 : STD_LOGIC;
signal an_out2 : STD_LOGIC_VECTOR(3 downto 0);
signal Seg_output_money : integer;  -- decimal output
signal Seg_output2 : integer;  -- decimal output2

constant clk_period : time := 10 ns;  -- 100Mhz

  function Seg_2_Dec (
    Seg : in std_logic_vector(6 downto 0))
    return integer is
    variable v_TEMP : integer;
  begin
    if (Seg = "1000000") then
      v_TEMP := 0;
    elsif (Seg = "1111001" ) then
      v_TEMP := 1;
    elsif (Seg = "0100100" ) then
      v_TEMP := 2;
    elsif (Seg = "0110000" ) then
      v_TEMP := 3;
    elsif (Seg = "0011001" ) then
      v_TEMP := 4;
    elsif (Seg = "0010010" ) then
      v_TEMP := 5;
    elsif (Seg = "0000010" ) then
      v_TEMP := 6;
    elsif (Seg = "1111000" ) then
      v_TEMP := 7;
    elsif (Seg = "0000000" ) then
      v_TEMP := 8;
    elsif (Seg = "0010000" ) then
      v_TEMP := 9;
    elsif (Seg = "0000110" ) then
      v_TEMP := 99;
    end if;
    return (v_TEMP);
  end;


begin

uut: MainTaxiCounter PORT MAP (
        sw => sw_in,
        sw_rst => sw_in2,
        clk => clk_in,
        segs_money => seg_out,
        dp1 => dp_out,
        an1 => an_out,
        segs2 => seg_out2,
        dp2 => dp_out2,
        an2 => an_out2
       );
 Seg_output_money <= Seg_2_Dec(seg_out);   
 Seg_output2 <= Seg_2_Dec(seg_out2);  

clk_process :process
    begin
        clk_in <= '0';
        wait for clk_period/2;
        clk_in <= '1';
        wait for clk_period/2;
    end process;

stim_proc: process
    begin
        sw_in2 <= '1';  -- rst
        wait for 20ns;
        sw_in2 <= '0';
       
       sw_in <= '1';
       wait for 1ms;
       sw_in <= '0';
    wait;
    end process;
    
    
    
end Behavioral;
