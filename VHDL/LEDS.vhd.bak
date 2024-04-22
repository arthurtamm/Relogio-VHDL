library ieee;
use ieee.std_logic_1164.all;

entity LEDS is
  port (
	Wr : in std_logic;
	DataIn : in std_logic_vector(7 downto 0);
	Habilita : in std_logic;
	Endereco : in std_logic_vector(2 downto 0);
	CLK : in std_logic;
	A5 : in std_logic;
	LED1 : out std_logic;
	LED2 : out std_logic;
	LEDR : out std_logic_vector(7 downto 0)
);
end entity;

architecture comportamento of LEDS is

  signal SaidaRLEDR : std_logic_vector (7 downto 0);
  signal SaidaRLED1 : std_logic;
  signal SaidaRLED2 : std_logic;
  signal HabilitaLEDR : std_logic;
  signal HabilitaLED1 : std_logic;
  signal HabilitaLED2 : std_logic;
  
  begin
	REGLEDR : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => DataIn, DOUT => SaidaRLEDR, ENABLE => HabilitaLEDR, CLK => CLK, RST => '0');
			 
	REGLED1 : entity work.registradorBinario 
				port map (DIN => DataIn(0), DOUT => SaidaRLED1, ENABLE => HabilitaLED1, CLK => CLK, RST => '0');
			
	REGLED2 : entity work.registradorBinario 
				port map (DIN => DataIn(0), DOUT => SaidaRLED2, ENABLE => HabilitaLED2, CLK => CLK, RST => '0');
				
	HabilitaLEDR <= Wr AND Endereco(0) AND Habilita AND A5;
	HabilitaLED1 <= Wr AND Endereco(1) AND Habilita AND A5;
	HabilitaLED2 <= Wr AND Endereco(2) AND Habilita AND A5;
	
	LEDR <= SaidaRLEDR;
	LED1 <= SaidaRLED1;
	LED2 <= SaidaRLED2;

end architecture;