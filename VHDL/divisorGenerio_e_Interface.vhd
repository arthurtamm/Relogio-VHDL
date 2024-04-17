LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
   port(clk      :   in std_logic;
      habilitaLeitura : in std_logic;
      limpaLeitura : in std_logic;
      leituraUmSegundo :   out std_logic;
		acelera : in std_logic;
		acelera2 : in std_logic
   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo : std_logic;
  signal saidaclk_reg1seg : std_logic;
  signal saidaclk_regPoucosseg : std_logic;
  signal saidaclk_regMinimosseg : std_logic;
  signal saidaclk_regMizerosseg : std_logic;
  signal seletor : std_logic_vector(1 downto 0);
  signal base_tempo_finale : std_logic;
begin

baseTempo: entity work.divisorGenerico
           generic map (divisor => 25000000) 
           port map (clk => clk, saida_clk => saidaclk_reg1seg);
			  
baseTempo2: entity work.divisorGenerico
           generic map (divisor => 2500000)   
           port map (clk => clk, saida_clk => saidaclk_regPoucosseg);
			  
baseTempo3: entity work.divisorGenerico
           generic map (divisor => 250000)   
           port map (clk => clk, saida_clk => saidaclk_regMinimosseg);
			  
baseTempo4: entity work.divisorGenerico
           generic map (divisor => 2500)   
           port map (clk => clk, saida_clk => saidaclk_regMizerosseg);
			  
seletor <= "00" when acelera = '0' AND acelera2 = '0' else
			  "01" when acelera = '0' AND acelera2 = '1' else
			  "10" when acelera = '1' AND acelera2 = '0' else
			  "11";
			  
MUX1 :  entity work.muxBinario
        port map( entradaA_MUX => saidaclk_reg1seg,
                 entradaB_MUX =>  saidaclk_regPoucosseg,
					  entradaC_MUX => saidaclk_regMinimosseg,
					  entradaD_MUX => saidaclk_regMizerosseg,
                 seletor_MUX => seletor,
                 saida_MUX => base_tempo_finale);

registraUmSegundo: entity work.registradorBinario
   port map (DIN => '1', DOUT => sinalUmSegundo,
         ENABLE => '1', CLK => base_tempo_finale,
         RST => limpaLeitura);

-- Faz o tristate de saida:
leituraUmSegundo <= sinalUmSegundo when habilitaLeitura = '1' else 'Z';

end architecture interface;