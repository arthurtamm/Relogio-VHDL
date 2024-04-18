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
  constant STADDR : std_logic_vector(3 downto 0) := "0111";
  constant JEQ : std_logic_vector(3 downto 0) := "1000";
  constant CEQ : std_logic_vector(3 downto 0) := "1001";
  constant JSR : std_logic_vector(3 downto 0) := "1010";
  constant RET : std_logic_vector(3 downto 0) := "1011";
  constant AND1 : std_logic_vector(3 downto 0) := "1100";
  constant CLT : std_logic_vector(3 downto 0) := "1101";
  constant JL : std_logic_vector(3 downto 0) := "1110";
  constant LDIDDR : std_logic_vector(3 downto 0) := "1111";

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
tmp(0) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(1) := JSR & "00" & '0' & x"E6";	-- JSR @230	#Limpa o display
tmp(2) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(3) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(4) := STA & "00" & '0' & x"0B";	-- STA @11 	#Zera o valor das unidades
tmp(5) := STA & "00" & '0' & x"0C";	-- STA @12 	#Zera o valor das dezenas
tmp(6) := STA & "00" & '0' & x"0D";	-- STA @13 	#Zera o valor das centenas
tmp(7) := STA & "00" & '0' & x"0E";	-- STA @14 	#Zera o valor das unidades de milhar
tmp(8) := STA & "00" & '0' & x"0F";	-- STA @15 	#Zera o valor das dezenas de milhar
tmp(9) := STA & "00" & '0' & x"10";	-- STA @16 	#Zera o valor das centenas de milhar
tmp(10) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(11) := STA & "00" & '0' & x"11";	-- STA @17 	#Zera a flag de inibir contagem
tmp(12) := STA & "00" & '1' & x"FF";	-- STA @KEY0 	#Limpa a leitura de KEY0
tmp(13) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(14) := STA & "00" & '1' & x"FD";	-- STA @KEY2 	#Limpa a leitura de KEY2
tmp(15) := STA & "00" & '1' & x"FC";	-- STA @FPGA_RESET 	#Limpa a leitura de FPGA_RESET
tmp(16) := STA & "00" & '0' & x"00";	-- STA @0 	#Criando a constante 0
tmp(17) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(18) := STA & "00" & '0' & x"01";	-- STA @1 	#Criando a constante 1
tmp(19) := LDI & "00" & '0' & x"02";	-- LDI $2 	#Carrega o acumulador com  valor 2
tmp(20) := STA & "00" & '0' & x"02";	-- STA @2 	#Criando a constante 2
tmp(21) := LDI & "00" & '0' & x"04";	-- LDI $4 	#Carrega o acumulador com  valor 4
tmp(22) := STA & "00" & '0' & x"04";	-- STA @4 	#Criando a constante 4
tmp(23) := LDI & "00" & '0' & x"05";	-- LDI $5 	#Carrega o acumulador com  valor 5
tmp(24) := STA & "00" & '0' & x"05";	-- STA @5 	#Criando a constante 5
tmp(25) := LDI & "00" & '0' & x"06";	-- LDI $6 	#Carrega o acumulador com  valor 6
tmp(26) := STA & "00" & '0' & x"06";	-- STA @6 	#Criando a constante 6
tmp(27) := LDI & "00" & '0' & x"09";	-- LDI $9 	#Carrega o acumulador com  valor 9
tmp(28) := STA & "00" & '0' & x"09";	-- STA @9 	#Criando a constante 9
tmp(29) := LDI & "00" & '0' & x"0A";	-- LDI $10 	#Carrega o acumulador com  valor 10
tmp(30) := STA & "00" & '0' & x"0A";	-- STA @10 	#Criando a constante 10
tmp(31) := LDI & "00" & '0' & x"0F";	-- LDI $15 	#Carrega o acumulador com  valor 15
tmp(32) := STA & "00" & '0' & x"73";	-- STA @115 	#Criando a constante 15
tmp(33) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(34) := STA & "00" & '0' & x"15";	-- STA @21 	#Maximo valor das unidades do limite
tmp(35) := STA & "00" & '0' & x"16";	-- STA @22 	#Maximo valor das dezenas do limite
tmp(36) := STA & "00" & '0' & x"17";	-- STA @23 	#Maximo valor das centenas do limite
tmp(37) := STA & "00" & '0' & x"18";	-- STA @24 	#Maximo valor das unidades de milhar do limite
tmp(38) := STA & "00" & '0' & x"19";	-- STA @25 	#Maximo valor das dezenas de milhar do limite
tmp(39) := LDI & "00" & '0' & x"0A";	-- LDI $10 	#Carrega o acumulador com  valor 10
tmp(40) := STA & "00" & '0' & x"1A";	-- STA @26 	#Maximo valor das centenas de milhar do limite
tmp(41) := LDA & "00" & '1' & x"60";	-- LDA @352 	#Lê KEY0
tmp(42) := AND1 & "00" & '0' & x"01";	-- AND1 @1 	#Mask
tmp(43) := CEQ & "00" & '0' & x"00";	-- CEQ @0 	#Verifica se KEY0 não foi pressionado
tmp(44) := JEQ & "00" & '0' & x"2E";	-- JEQ @46	#Se não foi, pula a chamada da subrotina de incremento
tmp(45) := JSR & "00" & '0' & x"3A";	-- JSR @58	#Chama a subrotina de incremento
tmp(46) := JSR & "00" & '0' & x"7A";	-- JSR @122	#Atualiza o display
tmp(47) := LDA & "00" & '1' & x"61";	-- LDA @353 	#Lê KEY1
tmp(48) := AND1 & "00" & '0' & x"01";	-- AND1 @1 	#Mask
tmp(49) := CEQ & "00" & '0' & x"00";	-- CEQ @0 	#Verifica se KEY1 não foi pressionado
tmp(50) := JEQ & "00" & '0' & x"34";	-- JEQ @52	#Se não foi, pula a chamada da subrotina de configuracao do limite
tmp(51) := JSR & "00" & '0' & x"87";	-- JSR @135	#Chama a subrotina de configuracao do limite
tmp(52) := LDA & "00" & '1' & x"64";	-- LDA @356 	#Lê FPGA_RESET
tmp(53) := AND1 & "00" & '0' & x"01";	-- AND1 @1 	#Mask
tmp(54) := CEQ & "00" & '0' & x"00";	-- CEQ @0 	#Verifica se FPGA_RESET não foi pressionado
tmp(55) := JEQ & "00" & '0' & x"39";	-- JEQ @57	#Se não foi, pula a chamada da subrotina de reiniciar contagem
tmp(56) := JSR & "00" & '0' & x"DA";	-- JSR @218	#Chama a subrotina de reiniciar contagem
tmp(57) := JMP & "00" & '0' & x"29";	-- JMP @41	#Retorna ao inicio do loop
tmp(58) := STA & "00" & '1' & x"FF";	-- STA @KEY0 	#Limpa a leitura de KEY0
tmp(59) := LDA & "00" & '0' & x"11";	-- LDA @17 	#Lê a flag de inibir contagem
tmp(60) := CEQ & "00" & '0' & x"00";	-- CEQ @0 	#Verifica se a contagem não está inibida
tmp(61) := JEQ & "00" & '0' & x"3F";	-- JEQ @63	#Se não estiver, continua a contagem
tmp(62) := RET & "00" & '0' & x"00";	-- RET 	#Se estiver inibida, retorna ao loop principal
tmp(63) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(64) := SOMA & "00" & '0' & x"0B";	-- SOMA @11 	#Soma o valor das unidades dos segundos com 1
tmp(65) := CEQ & "00" & '0' & x"0A";	-- CEQ @10 	#Verifica se o valor das unidades dos segundos é igual a 10
tmp(66) := JEQ & "00" & '0' & x"45";	-- JEQ @69	#Se sim, incremente a dezena
tmp(67) := STA & "00" & '0' & x"0B";	-- STA @11 	#Armazena o valor das unidades dos segundos
tmp(68) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(69) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(70) := STA & "00" & '0' & x"0B";	-- STA @11 	#Zera o valor das unidades dos segundos
tmp(71) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(72) := SOMA & "00" & '0' & x"0C";	-- SOMA @12 	#Soma o valor das dezenas dos segundos com 1
tmp(73) := CEQ & "00" & '0' & x"06";	-- CEQ @6 	#Verifica se o valor das dezenas dos segundos é igual a 6
tmp(74) := JEQ & "00" & '0' & x"4D";	-- JEQ @77	#Se sim, incremente a unidades dos minutos
tmp(75) := STA & "00" & '0' & x"0C";	-- STA @12 	#Armazena o valor das dezenas dos segundos
tmp(76) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(77) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(78) := STA & "00" & '0' & x"0C";	-- STA @12 	#Zera o valor das dezenas dos segundos
tmp(79) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(80) := SOMA & "00" & '0' & x"0D";	-- SOMA @13 	#Soma o valor das unidades dos minutos com 1
tmp(81) := CEQ & "00" & '0' & x"0A";	-- CEQ @10 	#Verifica se o valor das unidades dos minutos é igual a 10
tmp(82) := JEQ & "00" & '0' & x"55";	-- JEQ @85	#Se sim, incremente as dezenas dos minutos
tmp(83) := STA & "00" & '0' & x"0D";	-- STA @13 	#Armazena o valor das unidades dos minutos
tmp(84) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(85) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(86) := STA & "00" & '0' & x"0D";	-- STA @13 	#Zera o valor das unidades dos minutos
tmp(87) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(88) := SOMA & "00" & '0' & x"0E";	-- SOMA @14 	#Soma o valor das dezenas dos minutos com 1
tmp(89) := CEQ & "00" & '0' & x"06";	-- CEQ @6 	#Verifica se o valor das dezenas dos minutos é igual a 6
tmp(90) := JEQ & "00" & '0' & x"5D";	-- JEQ @93	#Se sim, incremente as unidades das horas
tmp(91) := STA & "00" & '0' & x"0E";	-- STA @14 	#Armazena o valor das unidades de milhar
tmp(92) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(93) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(94) := STA & "00" & '0' & x"0E";	-- STA @14 	#Zera o valor das dezenas dos minutos
tmp(95) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(96) := SOMA & "00" & '0' & x"0F";	-- SOMA @15 	#Soma o valor das unidades das horas com 1
tmp(97) := CEQ & "00" & '0' & x"0A";	-- CEQ @10 	#Verifica se o valor das unidades das horas é igual a 10
tmp(98) := JEQ & "00" & '0' & x"67";	-- JEQ @103	#Se sim, incremente as unidades das horas
tmp(99) := CEQ & "00" & '0' & x"04";	-- CEQ @4 	#Verifica se o valor das unidades das horas é igual a 4
tmp(100) := JEQ & "00" & '0' & x"6D";	-- JEQ @109	#Se sim, cheque se o valor das dezenas de horas é igual a 2
tmp(101) := STA & "00" & '0' & x"0F";	-- STA @15 	#Armazena o valor das unidades das horas
tmp(102) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(103) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(104) := STA & "00" & '0' & x"0F";	-- STA @15 	#Zera o valor das unidades das horas
tmp(105) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(106) := SOMA & "00" & '0' & x"10";	-- SOMA @16 	#Soma o valor das dezenas das horas com 1
tmp(107) := STA & "00" & '0' & x"10";	-- STA @16 	#Armazena o valor das dezenas das horas
tmp(108) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(109) := LDA & "01" & '0' & x"10";	-- LDA R1, 16 	#Carrega o registrador 1 com o valor das dezenas de horas
tmp(110) := CEQ & "01" & '0' & x"02";	-- CEQ R1, 2 	#Verifica se o valor das dezenas de horas é igual a 2
tmp(111) := JEQ & "00" & '0' & x"72";	-- JEQ @114	#Se sim, reinicie a contagem
tmp(112) := STA & "00" & '0' & x"0F";	-- STA R0, 15 	#Armazena o valor das unidades de horas
tmp(113) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(114) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(115) := STA & "00" & '0' & x"0B";	-- STA @11 	#Armazena o valor das unidades
tmp(116) := STA & "00" & '0' & x"0C";	-- STA @12 	#Armazena o valor das dezenas
tmp(117) := STA & "00" & '0' & x"0D";	-- STA @13 	#Armazena o valor das centenas
tmp(118) := STA & "00" & '0' & x"0E";	-- STA @14 	#Armazena o valor das unidades de milhar
tmp(119) := STA & "00" & '0' & x"0F";	-- STA @15 	#Armazena o valor das dezenas de milhar
tmp(120) := STA & "00" & '0' & x"10";	-- STA @16 	#Armazena o valor das centenas de milhar
tmp(121) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(122) := LDA & "00" & '0' & x"0B";	-- LDA @11 	#Lê o valor das unidades
tmp(123) := STA & "00" & '1' & x"20";	-- STA @288 	#Escreve o valor das unidades em HEX0
tmp(124) := LDA & "00" & '0' & x"0C";	-- LDA @12 	#Lê o valor das dezenas
tmp(125) := STA & "00" & '1' & x"21";	-- STA @289 	#Escreve o valor das dezenas em HEX1
tmp(126) := LDA & "00" & '0' & x"0D";	-- LDA @13 	#Lê o valor das centenas
tmp(127) := STA & "00" & '1' & x"22";	-- STA @290 	#Escreve o valor das centenas em HEX2
tmp(128) := LDA & "00" & '0' & x"0E";	-- LDA @14 	#Lê o valor das unidades de milhar
tmp(129) := STA & "00" & '1' & x"23";	-- STA @291 	#Escreve o valor das unidades de milhar em HEX3
tmp(130) := LDA & "00" & '0' & x"0F";	-- LDA @15 	#Lê o valor das dezenas de milhar
tmp(131) := STA & "00" & '1' & x"24";	-- STA @292 	#Escreve o valor das dezenas de milhar em HEX4
tmp(132) := LDA & "00" & '0' & x"10";	-- LDA @16 	#Lê o valor das centenas de milhar
tmp(133) := STA & "00" & '1' & x"25";	-- STA @293 	#Escreve o valor das centenas de milhar em HEX5
tmp(134) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(135) := JSR & "00" & '0' & x"E6";	-- JSR @230	#Limpa o display
tmp(136) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(137) := STA & "00" & '0' & x"0B";	-- STA @11 	#Zera o valor das unidades de segundos
tmp(138) := STA & "00" & '0' & x"0C";	-- STA @12 	#Zera o valor das dezenas de segundos
tmp(139) := STA & "00" & '0' & x"0D";	-- STA @13 	#Zera o valor das unidades de minutos
tmp(140) := STA & "00" & '0' & x"0E";	-- STA @14 	#Zera o valor das dezenas de minutos
tmp(141) := STA & "00" & '0' & x"0F";	-- STA @15 	#Zera o valor das unidades de horas
tmp(142) := STA & "00" & '0' & x"10";	-- STA @16 	#Zera o valor das dezenas de horas
tmp(143) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(144) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(145) := LDI & "00" & '0' & x"20";	-- LDI $32 	#Carrega o acumulador com  valor 32
tmp(146) := STA & "00" & '1' & x"00";	-- STA @256 	#Acende o LEDR5 para indicar que está configurando as dezenas de hora
tmp(147) := LDI & "00" & '0' & x"02";	-- LDI $2 	#Carrega o acumulador com  valor 2
tmp(148) := STA & "00" & '0' & x"32";	-- STA @50 	#Salva o limite de dezenas de hora
tmp(149) := LDIDDR & "00" & '1' & x"25";	-- LDIDDR $293 	#Salva posição da memória do display
tmp(150) := JSR & "00" & '0' & x"D2";	-- JSR @210	#Aguarda a leitura de KEY1
tmp(151) := STA & "00" & '0' & x"10";	-- STA @16 	#Armazena o valor das dezenas de horas
tmp(152) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(153) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(154) := LDI & "00" & '0' & x"10";	-- LDI $16 	#Carrega o acumulador com  valor 16
tmp(155) := STA & "00" & '1' & x"00";	-- STA @256 	#Acende o LEDR4 para indicar que está configurando as dezenas do limite
tmp(156) := LDA & "00" & '1' & x"40";	-- LDA @320 	#Lê SW0-SW7
tmp(157) := CLT & "00" & '0' & x"04";	-- CLT @4 	#Compara com o valor 4
tmp(158) := JL & "00" & '0' & x"A7";	-- JL @167	#Se for menor do que 4, armazena o valor
tmp(159) := LDA & "01" & '0' & x"10";	-- LDA R1, 16 	#Se não for, checa se o valor das dezenas de horas é igual a 2
tmp(160) := CLT & "01" & '0' & x"02";	-- CLT R1, 2 	#Compara com o valor 2
tmp(161) := JL & "00" & '0' & x"A4";	-- JL @164	#Se dezenas de hora for menor do que 2, checa se unidades de hora é menor do que 9
tmp(162) := LDI & "00" & '0' & x"03";	-- LDI $3 	#Se não for, carrega o acumulador com  valor 3
tmp(163) := JMP & "00" & '0' & x"A7";	-- JMP @167	#Se dezenas de hora for igual a 2, armazena o valor 3
tmp(164) := CLT & "00" & '0' & x"09";	-- CLT @9 	#Compara com o valor 9
tmp(165) := JL & "00" & '0' & x"A7";	-- JL @167	#Se for menor do que 9, armazena o valor
tmp(166) := LDI & "00" & '0' & x"09";	-- LDI $9 	#Se não for, carrega o acumulador com  valor 9
tmp(167) := STA & "00" & '1' & x"24";	-- STA @292 	#Escreve o valor das unidades em HEX4
tmp(168) := JSR & "00" & '0' & x"F3";	-- JSR @243	#Chama a subrotina de comparação de KEY1
tmp(169) := JEQ & "00" & '0' & x"9C";	-- JEQ @156	#Se não foi, continue aguardando
tmp(170) := STA & "00" & '0' & x"0F";	-- STA @15 	#Armazena o valor das unidades de hora
tmp(171) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(172) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(173) := LDI & "00" & '0' & x"08";	-- LDI $8 	#Carrega o acumulador com  valor 8
tmp(174) := STA & "00" & '1' & x"00";	-- STA @256 	#Acende o LEDR3 para indicar que está configurando as dezenas de minuto
tmp(175) := LDI & "00" & '0' & x"05";	-- LDI $5 	#Carrega o acumulador com  valor 5
tmp(176) := STA & "00" & '0' & x"32";	-- STA @50 	#Salva o limite de dezenas de hora
tmp(177) := LDIDDR & "00" & '1' & x"23";	-- LDIDDR $291 	#Salva posição da memória do display
tmp(178) := JSR & "00" & '0' & x"D2";	-- JSR @210	#Aguarda a leitura de KEY1
tmp(179) := STA & "00" & '0' & x"0E";	-- STA @14 	#Armazena o valor das dezenas de minuto
tmp(180) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(181) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(182) := LDI & "00" & '0' & x"04";	-- LDI $4 	#Carrega o acumulador com  valor 4
tmp(183) := STA & "00" & '1' & x"00";	-- STA @256 	#Acende o LEDR2 para indicar que está configurando as unidades de minuto
tmp(184) := LDI & "00" & '0' & x"09";	-- LDI $9 	#Carrega o acumulador com  valor 9
tmp(185) := STA & "00" & '0' & x"32";	-- STA @50 	#Salva o limite de dezenas de hora
tmp(186) := LDIDDR & "00" & '1' & x"22";	-- LDIDDR $290 	#Salva posição da memória do display
tmp(187) := JSR & "00" & '0' & x"D2";	-- JSR @210	#Aguarda a leitura de KEY1
tmp(188) := STA & "00" & '0' & x"0D";	-- STA @13 	#Armazena o valor das unidades de minuto
tmp(189) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(190) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(191) := LDI & "00" & '0' & x"02";	-- LDI $2 	#Carrega o acumulador com  valor 2
tmp(192) := STA & "00" & '1' & x"00";	-- STA @256 	#Acende o LEDR1 para indicar que está configurando as dezenas de segundos
tmp(193) := LDI & "00" & '0' & x"05";	-- LDI $5 	#Carrega o acumulador com  valor 5
tmp(194) := STA & "00" & '0' & x"32";	-- STA @50 	#Salva o limite de dezenas de hora
tmp(195) := LDIDDR & "00" & '1' & x"21";	-- LDIDDR $289 	#Salva posição da memória do display
tmp(196) := JSR & "00" & '0' & x"D2";	-- JSR @210	#Aguarda a leitura de KEY1
tmp(197) := STA & "00" & '0' & x"0C";	-- STA @12 	#Armazena o valor das dezenas de segundos
tmp(198) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(199) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(200) := LDI & "00" & '0' & x"01";	-- LDI $1 	#Carrega o acumulador com  valor 1
tmp(201) := STA & "00" & '1' & x"00";	-- STA @256 	#Acende o LEDR0 para indicar que está configurando as unidades de segundos
tmp(202) := LDI & "00" & '0' & x"09";	-- LDI $9 	#Carrega o acumulador com  valor 9
tmp(203) := STA & "00" & '0' & x"32";	-- STA @50 	#Salva o limite de dezenas de hora
tmp(204) := LDIDDR & "00" & '1' & x"20";	-- LDIDDR $288 	#Salva posição da memória do display
tmp(205) := JSR & "00" & '0' & x"D2";	-- JSR @210	#Aguarda a leitura de KEY1
tmp(206) := STA & "00" & '0' & x"0B";	-- STA @11 	#Armazena o valor das unidades de segundo
tmp(207) := JSR & "00" & '0' & x"EE";	-- JSR @238	#Limpa os LEDs
tmp(208) := STA & "00" & '1' & x"FE";	-- STA @KEY1 	#Limpa a leitura de KEY1
tmp(209) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(210) := LDA & "00" & '1' & x"40";	-- LDA @320 	#Lê SW0-SW7
tmp(211) := CLT & "00" & '0' & x"32";	-- CLT @50 	#Compara com o limite da casa
tmp(212) := JL & "00" & '0' & x"D6";	-- JL @214	#Se for menor do que 2, armazena o valor
tmp(213) := LDA & "00" & '0' & x"32";	-- LDA @50 	#Se não for, carrega o acumulador com o limite da casa
tmp(214) := STADDR & "00" & '0' & x"00";	-- STADDR 	#Escreve o valor da casa em seu respectivo display
tmp(215) := JSR & "00" & '0' & x"F3";	-- JSR @243	#Chama a subrotina de comparação de KEY1
tmp(216) := JEQ & "00" & '0' & x"D2";	-- JEQ @210	#Se não foi, continue aguardando
tmp(217) := RET & "00" & '0' & x"00";	-- RET 	#Retorna
tmp(218) := STA & "00" & '1' & x"FC";	-- STA @FPGA_RESET 	#Limpa a leitura de FPGA_RESET
tmp(219) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(220) := STA & "00" & '0' & x"0B";	-- STA @11 	#Zera o valor das unidades
tmp(221) := STA & "00" & '0' & x"0C";	-- STA @12 	#Zera o valor das dezenas
tmp(222) := STA & "00" & '0' & x"0D";	-- STA @13 	#Zera o valor das centenas
tmp(223) := STA & "00" & '0' & x"0E";	-- STA @14 	#Zera o valor das unidades de milhar
tmp(224) := STA & "00" & '0' & x"0F";	-- STA @15 	#Zera o valor das dezenas de milhar
tmp(225) := STA & "00" & '0' & x"10";	-- STA @16 	#Zera o valor das centenas de milhar
tmp(226) := STA & "00" & '0' & x"11";	-- STA @17 	#Zera a flag de inibir contagem
tmp(227) := STA & "00" & '1' & x"02";	-- STA @258 	#Apaga o LED de overflow
tmp(228) := STA & "00" & '1' & x"01";	-- STA @257 	#Apaga o LED de limite atingido
tmp(229) := RET & "00" & '0' & x"00";	-- RET 	#Retorna ao loop principal
tmp(230) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(231) := STA & "00" & '1' & x"20";	-- STA @288 	#Zera HEX0
tmp(232) := STA & "00" & '1' & x"21";	-- STA @289 	#Zera HEX1
tmp(233) := STA & "00" & '1' & x"22";	-- STA @290 	#Zera HEX2
tmp(234) := STA & "00" & '1' & x"23";	-- STA @291 	#Zera HEX3
tmp(235) := STA & "00" & '1' & x"24";	-- STA @292 	#Zera HEX4
tmp(236) := STA & "00" & '1' & x"25";	-- STA @293 	#Zera HEX5
tmp(237) := RET & "00" & '0' & x"00";	-- RET 	#Retorna
tmp(238) := LDI & "00" & '0' & x"00";	-- LDI $0 	#Carrega o acumulador com  valor 0
tmp(239) := STA & "00" & '1' & x"00";	-- STA @256 	#Zera dos LDR0-LDR7
tmp(240) := STA & "00" & '1' & x"01";	-- STA @257 	#Zera dos LDR8
tmp(241) := STA & "00" & '1' & x"02";	-- STA @258 	#Zera dos LDR9
tmp(242) := RET & "00" & '0' & x"00";	-- RET 	#Retorna
tmp(243) := LDA & "10" & '1' & x"61";	-- LDA R2, 353 	#Lê KEY1
tmp(244) := AND1 & "10" & '0' & x"01";	-- AND1 R2, 1 	#Mask
tmp(245) := CEQ & "10" & '0' & x"00";	-- CEQ R2, 0 	#Verifica se KEY1 não foi pressionado
tmp(246) := RET & "00" & '0' & x"00";	-- RET 	#Se Retorna


		  return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;