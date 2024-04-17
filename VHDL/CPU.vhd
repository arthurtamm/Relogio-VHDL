library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
		  larguraAddr: natural := 9;
		  larguraInst : natural := 15
  );
  port   (
	 CLK : in std_logic;
	 Rd : out std_logic;
	 Wd : out std_logic;
	 Reset : in std_logic;
	 ROM_Address : out std_logic_vector(larguraAddr-1 downto 0);
	 Instruction_N : in std_logic_vector(larguraInst-1 downto 0);
	 Data_In : in std_logic_vector(larguraDados-1 downto 0);
	 Data_Out : out std_logic_vector(larguraDados-1 downto 0);
	 Data_Address : out std_logic_vector(larguraAddr-1 downto 0)
	 );
end entity;


architecture arquitetura of CPU is
	
  signal DataIn : std_logic_vector (larguraDados-1 downto 0);
  signal saidaMux : std_logic_vector (larguraDados-1 downto 0);
  signal saidaRegA : std_logic_vector (larguraDados-1 downto 0);
  signal saidaRegB : std_logic_vector (larguraDados-1 downto 0);
  signal saidaRegC : std_logic_vector (larguraDados-1 downto 0);
  signal saidaRegD : std_logic_vector (larguraDados-1 downto 0);
  signal saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  signal Sinais_Controle : std_logic_vector (9 downto 0);
  signal regSel : std_logic_vector(1 downto 0);
  signal saidaReg : std_logic_vector(larguraDados-1 downto 0);
  signal Habilita_A : std_logic;
  signal Habilita_B : std_logic;
  signal Habilita_C : std_logic;
  signal Habilita_D : std_logic;
  
  signal HabilitaEscritaRetorno : std_logic;
  signal JMP : std_logic;
  signal RET : std_logic;
  signal SelMUX : std_logic;
  signal Habilita : std_logic;
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal Habilita_Flag : std_logic;
  
  signal ULA_Equal : std_logic;
  signal SaidaRegEqual : std_logic;
  signal SaidaRegNeg : std_logic;
  
  signal SelMuxJMP : std_logic_vector (2 downto 0);
  signal MuxJMPout : std_logic_vector (LarguraAddr-1 downto 0);
  signal proxPC : std_logic_vector (LarguraAddr-1 downto 0);
  signal RomAddress : std_logic_vector (LarguraAddr-1 downto 0);
  
  signal habA : std_logic;
  signal habB : std_logic;
  signal habC : std_logic;
  signal habD : std_logic;
  signal RethabA : std_logic;
  signal RethabB : std_logic;
  signal RethabC : std_logic;
  signal RethabD : std_logic;

  signal EndRetorno1 : std_logic_vector (LarguraAddr-1 downto 0);
  signal EndRetorno2 : std_logic_vector (LarguraAddr-1 downto 0);
  signal EndRetorno3 : std_logic_vector (LarguraAddr-1 downto 0);
  signal EndRetorno4 : std_logic_vector (LarguraAddr-1 downto 0);
  
  signal subOut : std_logic_vector(larguraDados-1 downto 0);
  signal subCounter : std_logic_vector (larguraDados-1 downto 0);
  signal subCounterDec : std_logic_vector(larguraDados-1 downto 0);
  signal subCounterInc : std_logic_vector(larguraDados-1 downto 0);

begin

MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => DataIn,
                 entradaB_MUX =>  Instruction_N(7 downto 0),
                 seletor_MUX => SelMux,
                 saida_MUX => saidaMux);
				
MUX2 :  entity work.muxGenerico8x1  generic map (larguraDados => LarguraAddr)
        port map(entradaA_MUX => ProxPC,
                 entradaB_MUX => Instruction_N(8 downto 0),
					  entradaC_MUX => EndRetorno1,
					  entradaD_MUX => EndRetorno2,
					  entradaE_MUX => EndRetorno3,
					  entradaF_MUX => EndRetorno4,
					  entradaG_MUX => "000000000",
					  entradaH_MUX => "000000000",
                 seletor_MUX => SelMuxJMP,
                 saida_MUX => MuxJMPout);

REGA : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => SaidaRegA, ENABLE => Habilita_A, CLK => CLK, RST => Reset);
			 
REGB : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => SaidaRegB, ENABLE => Habilita_B, CLK => CLK, RST => Reset);
			 
REGC : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => SaidaRegC, ENABLE => Habilita_C, CLK => CLK, RST => Reset);
			 
REGD : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => SaidaRegD, ENABLE => Habilita_D, CLK => CLK, RST => Reset);
			 
Habilita_A <= '1' when regSel="00" AND Habilita='1' else
				  '0';
		  
Habilita_B <= '1' when regSel="01" AND Habilita='1' else
				  '0';

Habilita_C <= '1' when regSel="10" AND Habilita='1' else
				  '0';
				  
Habilita_D <= '1' when regSel="11" AND Habilita='1' else
				  '0';
				  
saidaReg <= SaidaRegA when regSel="00" else
				SaidaRegB when regSel="01" else
				SaidaRegC when regSel="10" else
				SaidaRegD when regSel="11";
	
decrementaSUB :  entity work.subtraiConstante  generic map (larguraDados => LarguraDados, constante => 1)
        port map( entrada => SubOut, saida => subCounterDec);

incrementaSUB :  entity work.somaConstante  generic map (larguraDados => LarguraDados, constante => 1)
        port map( entrada => SubOut, saida => subCounterInc);
		  
MUXSUB :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => subCounterDec,
                 entradaB_MUX =>  subCounterInc,
                 seletor_MUX => HabilitaEscritaRetorno,
                 saida_MUX => subCounter);
		  
REGSUB : entity work.registradorGenerico generic map (larguraDados => larguraDados)
			 port map (DIN => subCounter, DOUT => SubOut, ENABLE => HabilitaEscritaRetorno OR RET, CLK => CLK, RST => Reset);
			 
REGRA : entity work.registradorGenerico   generic map (larguraDados => larguraAddr)
          port map (DIN => proxPC, DOUT => EndRetorno1, ENABLE => HabilitaEscritaRetorno AND habA, CLK => CLK, RST => Reset);
			 
REGRB : entity work.registradorGenerico   generic map (larguraDados => larguraAddr)
          port map (DIN => proxPC, DOUT => EndRetorno2, ENABLE => HabilitaEscritaRetorno AND habB, CLK => CLK, RST => Reset);
			 
REGRC : entity work.registradorGenerico   generic map (larguraDados => larguraAddr)
          port map (DIN => proxPC, DOUT => EndRetorno3, ENABLE => HabilitaEscritaRetorno AND habC, CLK => CLK, RST => Reset);
	
REGRD : entity work.registradorGenerico   generic map (larguraDados => larguraAddr)
          port map (DIN => proxPC, DOUT => EndRetorno4, ENABLE => HabilitaEscritaRetorno AND habD, CLK => CLK, RST => Reset);
			 	 
REGequal : entity work.registradorBinario 
			port map (DIN => ULA_Equal, DOUT => SaidaRegEqual, ENABLE => Habilita_Flag, CLK => CLK, RST => Reset);
			
REGneg : entity work.registradorBinario 
			port map (DIN => saida_ULA(7), DOUT => SaidaRegNeg, ENABLE => Habilita_Flag, CLK => CLK, RST => Reset);

-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => LarguraAddr)
          port map (DIN => MuxJMPout, DOUT => RomAddress, ENABLE => '1', CLK => CLK, RST => Reset);

incrementaPC :  entity work.somaConstante  generic map (larguraDados => LarguraAddr, constante => 1)
        port map(entrada => RomAddress, saida => proxPC);

-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA => SaidaReg, entradaB => saidaMux, saida => Saida_ULA, seletor => Operacao_ULA);
			 
DECODER : entity work.decoderInstru
			 port map (opcode => Instruction_N(14 downto 11), saida => Sinais_Controle, Equal => SaidaRegEqual, Neg => SaidaRegNeg);	  

DESVIO : entity work.logicaDesvio
			 port map(RET => RET, JMP => JMP, saida => SelMuxJMP,
			 habA => RethabA, habB => RethabB, habC => RethabC, habD => RethabD);
			 
HabilitaEscritaRetorno <= Sinais_Controle(9);
JMP <= Sinais_Controle(8);
RET <= Sinais_Controle(7);
SelMux <= Sinais_Controle(6);
Habilita <= Sinais_Controle(5);
Operacao_ULA(1) <= Sinais_Controle(4);
Operacao_ULA(0) <= Sinais_Controle(3);
Habilita_Flag <= Sinais_Controle(2);

ULA_Equal <= NOT (saida_ULA(7) OR saida_ULA(6) OR saida_ULA(5) OR saida_ULA(4) OR saida_ULA(3)
OR saida_ULA(2) OR saida_ULA(1) OR saida_ULA(0));

habA <= '1' when SubOut="00000000" else
		  '0';
		  
habB <= '1' when SubOut="00000001" else
		  '0';
		  
habC <= '1' when SubOut="00000010" else
		  '0';
		  
habD <= '1' when SubOut="00000011" else
		  '0';
		  
RethabA <= '1' when SubOut="00000001" else
			'0';
			
RethabB <= '1' when SubOut="00000010" else
			'0';
			
RethabC <= '1' when SubOut="00000011" else
			'0';
			
RethabD <= '1' when SubOut="00000100" else
			'0';

Rd <= Sinais_Controle(1);
Wd <= Sinais_controle(0);
ROM_Address <= RomAddress;
DataIn <= Data_In;
Data_Out <= saidaReg;
Data_Address <= Instruction_N(8 downto 0);
regSel <= Instruction_N(10 downto 9);

end architecture;