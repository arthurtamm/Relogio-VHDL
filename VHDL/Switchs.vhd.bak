library ieee;
use ieee.std_logic_1164.all;

entity Switchs is
  port (
	Rr : in std_logic;
	DataOut : out std_logic_vector(7 downto 0);
	Habilita : in std_logic;
	Endereco : in std_logic_vector(2 downto 0);
	A5 : in std_logic;
	SW1 : in std_logic;
	SW2 : in std_logic;
	SW8 : in std_logic_vector(7 downto 0)
);
end entity;

architecture comportamento of Switchs is

  signal HabilitaSW1 : std_logic;
  signal HabilitaSW2 : std_logic;
  signal HabilitaSW8 : std_logic;
  
  begin
	
	HabilitaSW8 <= Rr AND Endereco(0) AND Habilita AND A5;	
	HabilitaSW1 <= Rr AND Endereco(1) AND Habilita AND A5;
	HabilitaSW2 <= Rr AND Endereco(2) AND Habilita AND A5;
	
	DataOut(7 downto 1) <= SW8(7 downto 1) when habilitaSW8='1' else
								  "ZZZZZZZ";
								  
	DataOut(0) <= SW1 when HabilitaSW1='1' else
				  SW2 when HabilitaSW2='1' else
				  SW8(0) when HabilitaSW8='1' else
				  'Z';
end architecture;