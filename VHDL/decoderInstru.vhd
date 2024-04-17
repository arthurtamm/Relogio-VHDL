library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port ( opcode : in std_logic_vector(3 downto 0);
			Equal : in std_logic;
			Neg : in std_logic;
         saida : out std_logic_vector(10 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

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

  begin
saida <= "00000000000" when opcode = NOP else
         "00000111010" when opcode = LDA else
         "00000101010" when opcode = SOMA else
         "00000100010" when opcode = SUB else
         "00001111000" when opcode = LDI else
         "00000000001" when opcode = STA else
			"00100000000" when 
									 (
										opcode = JMP OR 
									  (opcode = JL AND NEG = '1') OR
									  (opcode = JLE AND (NEG = '1' OR EQUAL = '1')) OR
									  (opcode = JEQ AND EQUAL = '1') OR
									  (opcode = JG AND (NEG = '0' AND EQUAL = '0'))
									 )
							  else
			"00000000110" when opcode = CEQ else
			"01100000000" when opcode = JSR else
			"00010000000" when opcode = RET else
			"00000110010" when opcode = AND1 else
			"10000000010" when opcode = CLT else
			"00000000000"; 
end architecture;