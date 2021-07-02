
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux21 is
  Port (sel : in std_logic;
        d23, d22, d21, d20 : in std_logic_vector(3 downto 0);
        d13, d12, d11, d10 : in std_logic_vector(3 downto 0);
        d3, d2, d1, d0 : out std_logic_vector(3 downto 0) );
end mux21;

architecture Behavioral of mux21 is

begin
d3 <= d23 when sel='1' else d13;
d2 <= d22 when sel='1' else d12;
d1 <= d21 when sel='1' else d11;
d0 <= d20 when sel='1' else d10;

end Behavioral;
