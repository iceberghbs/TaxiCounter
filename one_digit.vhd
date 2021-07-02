
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_digit is
  PORT(
      digit:in std_logic_vector(3 downto 0);
      seg: out std_logic_vector(6 downto 0)
      );
end one_digit;

architecture Behavioral of one_digit is

begin

   process(digit)
   begin
      case digit is  -- a decoder for sigal 7_seg LED
      when "0000"=> seg<="1000000" ;
      when "0001"=> seg<="1111001" ;
      when "0010"=> seg<="0100100" ;
      when "0011"=> seg<="0110000" ;
      when "0100"=> seg<="0011001" ;
      when "0101"=> seg<="0010010" ;
      when "0110"=> seg<="0000010" ;
      when "0111"=> seg<="1111000" ;
      when "1000"=> seg<="0000000" ;
      when "1001"=> seg<="0010000" ;
      when others=>  seg<="1111111";
      end case;

   end process;

end Behavioral;
