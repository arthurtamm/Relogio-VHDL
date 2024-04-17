library ieee;
use ieee.std_logic_1164.all;

entity Displays is
  port (
	Wr : in std_logic;
	DataIn : in std_logic_vector(3 downto 0);
	Habilita : in std_logic;
	Endereco : in std_logic_vector(5 downto 0);
	CLK : in std_logic;
	A5 : in std_logic;
	D0 : out std_logic_vector(6 downto 0);	
	D1 : out std_logic_vector(6 downto 0);
	D2 : out std_logic_vector(6 downto 0);
	D3 : out std_logic_vector(6 downto 0);
	D4 : out std_logic_vector(6 downto 0);
	D5 : out std_logic_vector(6 downto 0)
);
end entity;

architecture comportamento of Displays is

  signal SaidaD0 : std_logic_vector (3 downto 0);
  signal SaidaD1 : std_logic_vector (3 downto 0);
  signal SaidaD2 : std_logic_vector (3 downto 0);
  signal SaidaD3 : std_logic_vector (3 downto 0);
  signal SaidaD4 : std_logic_vector (3 downto 0);
  signal SaidaD5 : std_logic_vector (3 downto 0);

  signal HabilitaD0 : std_logic;
  signal HabilitaD1 : std_logic;
  signal HabilitaD2 : std_logic;
  signal HabilitaD3 : std_logic;
  signal HabilitaD4 : std_logic;
  signal HabilitaD5 : std_logic;
  
  begin
  
 	REGD0 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => DataIn, DOUT => SaidaD0, ENABLE => HabilitaD0, CLK => CLK, RST => '0');
	REGD1 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => DataIn, DOUT => SaidaD1, ENABLE => HabilitaD1, CLK => CLK,RST => '0');
	REGD2 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => DataIn, DOUT => SaidaD2, ENABLE => HabilitaD2, CLK => CLK,RST => '0');
	REGD3 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => DataIn, DOUT => SaidaD3, ENABLE => HabilitaD3, CLK => CLK,RST => '0');
	REGD4 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => DataIn, DOUT => SaidaD4, ENABLE => HabilitaD4, CLK => CLK,RST => '0');
	REGD5 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => DataIn, DOUT => SaidaD5, ENABLE => HabilitaD5, CLK => CLK,RST => '0');
			 
	HabilitaD0 <= Wr AND Endereco(0) AND Habilita AND A5;
	HabilitaD1 <= Wr AND Endereco(1) AND Habilita AND A5;
	HabilitaD2 <= Wr AND Endereco(2) AND Habilita AND A5;
	HabilitaD3 <= Wr AND Endereco(3) AND Habilita AND A5;
	HabilitaD4 <= Wr AND Endereco(4) AND Habilita AND A5;
	HabilitaD5 <= Wr AND Endereco(5) AND Habilita AND A5;
	
	DECD0 : entity work.conversorHex7Seg
			 port map(dadoHex => SaidaD0, saida7seg => D0);
	DECD1 : entity work.conversorHex7Seg
			 port map(dadoHex => SaidaD1, saida7seg => D1);
	DECD2 : entity work.conversorHex7Seg
			 port map(dadoHex => SaidaD2, saida7seg => D2);
	DECD3 : entity work.conversorHex7Seg
			 port map(dadoHex => SaidaD3, saida7seg => D3);
	DECD4 : entity work.conversorHex7Seg
			 port map(dadoHex => SaidaD4, saida7seg => D4);
	DECD5 : entity work.conversorHex7Seg
			 port map(dadoHex => SaidaD5, saida7seg => D5);

end architecture;