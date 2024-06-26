library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  --Soma (esta biblioteca =ieee)

entity subtraiConstante is
    generic
    (
        larguraDados : natural := 32;
        constante : natural := 4
    );
    port
    (
        entrada: in  STD_LOGIC_VECTOR((larguraDados-1) downto 0);
        saida:   out STD_LOGIC_VECTOR((larguraDados-1) downto 0)
    );
end entity;

architecture comportamento of subtraiConstante is
    begin
        saida <= std_logic_vector(signed(entrada) - constante);
end architecture;