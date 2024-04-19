library ieee;
use ieee.std_logic_1164.all;

entity logicaDesvio is
  port (
	 RET : in std_logic;
	 JMP : in std_logic;
	 saida : out std_logic_vector(1 downto 0)
  );
end entity;

architecture comportamento of logicaDesvio is
  begin
    saida <= "01" when JMP = '1' else
				 "10" when RET = '1' else
				 "00";
end architecture;