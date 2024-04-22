library ieee;
use ieee.std_logic_1164.all;

entity Keys is
  port (
	CLK : in std_logic;
	Rr : in std_logic;
	DataOut : out std_logic_vector(7 downto 0);
	Habilita : in std_logic;
	Endereco : in std_logic_vector(4 downto 0);
	A5 : in std_logic;
	RST0 : in std_logic;
	RST1 : in std_logic;
	RST2 : in std_logic;
	RST_FPGA : in std_logic;
	Key0 : in std_logic;
	Key1 : in std_logic;
	Key2 : in std_logic;
	FPGAR : in std_logic
);
end entity;

architecture comportamento of Keys is

  signal HabilitaK0 : std_logic;
  signal HabilitaK1 : std_logic;
  signal HabilitaK2 : std_logic;
  signal HabilitaFPGAR : std_logic;
  
  signal SigK0 : std_logic;
  signal SigK1 : std_logic;
  signal SigK2 : std_logic;
  signal SigFPGAR : std_logic;
  
  signal saidaK0 : std_logic;
  signal saidaK1 : std_logic;
  signal saidaK2 : std_logic;
  signal saidaFPGAR : std_logic;
  
  begin
				
	HabilitaK0 <= Rr AND Endereco(0) AND Habilita AND A5;
	HabilitaK1 <= Rr AND Endereco(1) AND Habilita AND A5;
	HabilitaK2 <= Rr AND Endereco(2) AND Habilita AND A5;
	HabilitaFPGAR <= Rr AND Endereco(4) AND Habilita AND A5;
	
	detectorK0: work.edgeDetector(bordaSubida)
			  port map (clk => CLK, entrada => NOT (Key0), saida => SigK0);
	detectorK1: work.edgeDetector(bordaSubida)
			  port map (clk => CLK, entrada => NOT (Key1), saida => SigK1);
	detectorK2: work.edgeDetector(bordaSubida)
			  port map (clk => CLK, entrada => NOT (Key2), saida => SigK2);
	detectorFPGAR: work.edgeDetector(bordaSubida)
			  port map (clk => CLK, entrada => NOT (FPGAR), saida => SigFPGAR);
			  
	ffk0 : work.registradorBinario
			port map (DIN => '1', DOUT => SaidaK0, ENABLE => '1', CLK => SigK0, RST => RST0);
	ffk1 : work.registradorBinario
			port map (DIN => '1', DOUT => SaidaK1, ENABLE => '1', CLK => SigK1, RST => RST1);
	ffk2 : work.registradorBinario
			port map (DIN => '1', DOUT => SaidaK2, ENABLE => '1', CLK => SigK2, RST => RST2);
	ffkfpgar : work.registradorBinario
			port map (DIN => '1', DOUT => SaidaFPGAR, ENABLE => '1', CLK => SigFPGAR, RST => RST_FPGA);
								  
	DataOut(0) <= SaidaK0 when HabilitaK0='1' else
					  SaidaK1 when HabilitaK1='1' else
					  SaidaK2 when HabilitaK2='1' else
					  SaidaFPGAR when HabilitaFPGAR='1' else
					  'Z';
					  
	DataOut(7 downto 1) <= "ZZZZZZZ";
					  
end architecture;