library ieee;
use ieee.std_logic_1164.all;

entity logicaDesvio is
  port (
	 RET : in std_logic;
	 JMP : in std_logic;
	 habA, habB, habC, habD : in std_logic;
	 saida : out std_logic_vector(2 downto 0)
  );
end entity;

architecture comportamento of logicaDesvio is
  begin
    saida <= "001" when JMP = '1' else
				 "010" when (RET = '1' AND habA = '1') else
				 "011" when (RET = '1' AND habB = '1') else
				 "100" when (RET = '1' AND habC = '1') else
				 "101" when (RET = '1' AND habD = '1') else
				 "000";
end architecture;