library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 13;
          addrWidth: natural := 8
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);
  
  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI : std_logic_vector(3 downto 0) := "0100";
  constant STA : std_logic_vector(3 downto 0) := "0101";
  constant JMP : std_logic_vector(3 downto 0) := "0110";
  constant JLE : std_logic_vector(3 downto 0) := "0111";
  constant JEQ : std_logic_vector(3 downto 0) := "1000";
  constant CEQ : std_logic_vector(3 downto 0) := "1001";
  constant JSR : std_logic_vector(3 downto 0) := "1010";
  constant RET : std_logic_vector(3 downto 0) := "1011";
  constant AND1 : std_logic_vector(3 downto 0) := "1100";
  constant CLT : std_logic_vector(3 downto 0) := "1101";
  constant JL : std_logic_vector(3 downto 0) := "1110";
  constant JG : std_logic_vector(3 downto 0) := "1111";

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
tmp(0) := LDI & "00" & '0' & x"09";	-- LDI $3 	#Carrega o acumulador com  valor 0
tmp(1) := STA & "00" & '0' & x"01";	-- STA @1
tmp(2) := LDI & "00" & '0' & x"05";	-- LDI $5
tmp(3) := CLT & "00" & '0' & x"01";	-- CLT @1
tmp(4) := JL & "00" & '0' & x"06";	-- JL @6
tmp(5) := JMP & "00" & '0' & x"08";	-- JMP @8
tmp(6) := LDI & "00" & '0' & x"01";	-- LDI $1
tmp(7) := STA & "00" & '1' & x"00";	-- STA @256
tmp(8) := NOP & "00" & '0' & x"00";	-- NOP

		  return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;