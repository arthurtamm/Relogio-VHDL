library ieee;
use ieee.std_logic_1164.all;

entity muxBinario is
  -- Total de bits das entradas e saidas
  port (
    entradaA_MUX, entradaB_MUX, entradaC_MUX, entradaD_MUX : in std_logic;
    seletor_MUX : in std_logic_vector(1 downto 0);
    saida_MUX : out std_logic
  );
end entity;

architecture comportamento of muxBinario is
  begin
    saida_MUX <= entradaB_MUX when (seletor_MUX = "01") else 
					  entradaC_MUX when (seletor_MUX = "10") else
					  entradaD_MUX when (seletor_MUX = "11") else
					  entradaA_MUX;
end architecture;