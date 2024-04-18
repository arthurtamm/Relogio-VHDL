library ieee;
use ieee.std_logic_1164.all;

entity Contador2 is
  -- Total de bits das entradas e saidas
  generic (
		  larguraDados : natural := 8;
		  larguraRAM : natural := 6;
		  larguraAddr: natural := 9;
		  larguraInst : natural := 15
  );
  port   (
    CLOCK_50 : in std_logic;
	 SW : in std_logic_vector(9 downto 0);
	 LEDR : out std_logic_vector(9 downto 0);
    KEY: in std_logic_vector(3 downto 0);
	 PC_OUT : out std_logic_vector(8 downto 0);
	 FPGA_RESET_N : in std_logic;
	 HEX0 : out std_logic_vector(6 downto 0);
	 HEX1 : out std_logic_vector(6 downto 0);
	 HEX2 : out std_logic_vector(6 downto 0);
	 HEX3 : out std_logic_vector(6 downto 0);
	 HEX4 : out std_logic_vector(6 downto 0);
	 HEX5 : out std_logic_vector(6 downto 0)
  );
end entity;


architecture arquitetura of Contador2 is

  signal LeituraDados : std_logic_vector (larguraDados-1 downto 0);
  signal Rom_Address : std_logic_vector (LarguraAddr-1 downto 0);
  signal CLK : std_logic;
  signal Wd : std_logic;
  signal Rd : std_logic;
  signal Instruction : std_logic_vector(larguraInst-1 downto 0);
  signal Saida_Acumulador : std_logic_vector(larguraDados-1 downto 0);
  signal Ram_Address : std_logic_vector(larguraAddr-1 downto 0);
  signal Bloco: std_logic_vector(larguraDados-1 downto 0);
  signal EnderecoDec : std_logic_vector(larguraDados-1 downto 0);
  signal RSTkey : std_logic;
  signal CPUreset : std_logic;
  signal RSTsec : std_logic;
  signal RSTtempo : std_logic;
  signal RSTkey0 : std_logic;
  signal RSTkey1 : std_logic;
  signal RSTkey2 : std_logic;
  signal RST_FPGA : std_logic;
  signal HabilitaTempo : std_logic;
  
begin

CLK <= CLOCK_50;

HabilitaTempo <= Rd AND EnderecoDec(0) AND Bloco(5) AND Ram_Address(5);

RSTtempo <= '1' when (Ram_Address = "111111111") else
			 '0';
	
interfaceBaseTempo : entity work.divisorGenerico_e_Interface
              port map (clk => CLK,
              habilitaLeitura => HabilitaTempo,
              limpaLeitura => RSTtempo,
              leituraUmSegundo => LeituraDados(0),
				  acelera => SW(9),
				  acelera2 => SW(8));

ROM1 : entity work.memoriaROM generic map (dataWidth => larguraInst, addrWidth => LarguraAddr)
          port map (Endereco => Rom_Address, Dado => Instruction);			 
			 
RAM : entity work.memoriaRAM  generic map (dataWidth => larguraDados, addrWidth => larguraRam)
			 port map (addr => Ram_Address(5 downto 0), we => Wd, re => Rd,
			 habilita => Bloco(0), dado_in => Saida_Acumulador, dado_out => LeituraDados, clk => CLK);
			 
CPU : entity work.CPU generic map(larguraDados => larguraDados, larguraAddr => larguraAddr)
			 port map (CLK => CLK, Rd => Rd, Wd => Wd, ROM_Address => Rom_Address, Instruction_N => Instruction,
			 Data_In => LeituraDados, Data_Out => Saida_Acumulador, Data_Address => Ram_Address, Reset => CPUreset);
			 
LEDS : entity work.LEDS 
			 port map (CLK => CLK, Wr => Wd, DataIn => Saida_Acumulador, Habilita => Bloco(4), Endereco => EnderecoDec(2 downto 0),
			 LEDR => LEDR(7 downto 0), LED1 => LEDR(8), LED2 => LEDR(9), A5 => NOT Ram_Address(5));
			 
Displays : entity work.Displays
			 port map(CLK => CLK, Wr => Wd, DataIn => Saida_Acumulador(3 downto 0), habilita => Bloco(4), Endereco => EnderecoDec(5 downto 0),
			 D0 => HEX0, D1 => HEX1, D2 => HEX2, D3 => HEX3, D4 => HEX4, D5 => HEX5, A5 => Ram_Address(5));
			 
Switchs : entity work.Switchs
			 port map(Rr => Rd, DataOut => LeituraDados, habilita => Bloco(5), Endereco => EnderecoDec(2 downto 0), A5 => NOT Ram_Address(5),
			 SW1 => SW(8), SW2 => SW(9), SW8 => SW(7 downto 0));
			 
Keys : entity work.Keys
			 port map(Rr => Rd, DataOut => LeituraDados, habilita => Bloco(5), Endereco => EnderecoDec(4 downto 0), A5 => Ram_Address(5),
			 Key0 => KEY(0), Key1 => KEY(1), Key2 => Key(2), FPGAR => FPGA_RESET_N, CLK => CLK, RST0 => RSTkey0 and Wd,
			 RST1 => RSTkey1 and Wd, RST2 => RSTkey2 and Wd, RST_FPGA => RST_FPGA and Wd);
			 
DecBloco : entity work.decoder3x8
			 port map (entrada => Ram_Address(8 downto 6), saida => Bloco);
			 
DecEnd : entity work.decoder3x8
			 port map (entrada => Ram_Address(2 downto 0), saida => EnderecoDec);
			 
PC_OUT <= Rom_Address;

RSTkey2 <= '1' when (Ram_Address = "111111011") else
			 '0';
			 
RSTkey1 <= '1' when (Ram_Address = "111111110") else
			 '0';
			 
RSTkey0 <= '1' when (Ram_Address = "111111101") else
			 '0';
	
RST_FPGA <= '1' when (Ram_Address = "111111100") else
			 '0';
			 
CPUreset <= NOT KEY(3);
			 
end architecture;