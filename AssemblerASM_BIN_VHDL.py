"""
- Criado em 07/Fevereiro/2022
- Atualizado em 19/04/2023

@autor: Marco Mello e Paulo Santos


Regras:

1) O Arquivo ASM.txt não pode conter linhas iniciadas com caracteres ' ' ou '\n')
2) Linhas somente com comentários são excluídas 
3) Instruções sem comentário no arquivo ASM receberão como comentário no arquivo BIN a própria instrução
4) Exemplo de codigo invalido:
                            0.___JSR @14 #comentario1
                            1.___#comentario2           << Invalido ( Linha somente com comentário )
                            2.___                       << Invalido ( Linha vazia )
                            3.___JMP @5  #comentario3
                            4.___JEQ @9
                            5.___NOP
                            6.___NOP
                            7.___                       << Invalido ( Linha vazia )
                            8.___LDI $5                 << Invalido ( Linha iniciada com espaço (' ') )
                            9.___ STA $0
                            10.__CEQ @0
                            11.__JMP @2  #comentario4
                            12.__NOP
                            13.__ LDI $4                << Invalido ( Linha iniciada com espaço (' ') )
                            14.__CEQ @0
                            15.__JEQ @3
                            16.__#comentario5           << Invalido ( Linha somente com comentário )
                            17.__JMP @13
                            18.__NOP
                            19.__RET
                                
5) Exemplo de código válido (Arquivo ASM.txt):
                            0.___JSR @14 #comentario1
                            1.___JMP @5  #comentario3
                            2.___JEQ @9
                            3.___NOP
                            4.___NOP
                            5.___LDI $5
                            6.___STA $0
                            7.___CEQ @0
                            8.___JMP @2  #comentario4
                            9.___NOP
                            10.__LDI $4
                            11.__CEQ @0
                            12.__JEQ @3
                            13.__JMP @13
                            14.__NOP
                            15.__RET
                            
6) Resultado do código válido (Arquivo BIN.txt):
                            0.__tmp(0) := x"90E"; -- comentario1
                            1.__tmp(1) := x"605"; -- comentario3
                            2.__tmp(2) := x"709"; -- JEQ @9
                            3.__tmp(3) := x"000"; -- NOP
                            4.__tmp(4) := x"000"; -- NOP
                            5.__tmp(5) := x"405"; -- LDI $5
                            6.__tmp(6) := x"500"; -- STA $0
                            7.__tmp(7) := x"800"; -- CEQ @0
                            8.__tmp(8) := x"602"; -- comentario4
                            9.__tmp(9) := x"000"; -- NOP
                            10._tmp(10) := x"404"; -- LDI $4
                            11._tmp(11) := x"800"; -- CEQ @0
                            12._tmp(12) := x"703"; -- JEQ @3
                            13._tmp(13) := x"60D"; -- JMP @13
                            14._tmp(14) := x"000"; -- NOP
                            15._tmp(15) := x"A00"; -- RET

"""



inputASM = 'entrada.txt' #Arquivo de entrada de contém o assembly
outputBIN = 'saida.txt' #Arquivo de saída que contém o binário formatado para VHDL
outputMIF = 'initROM.mif' #Arquivo de saída que contém o binário formatado para .mif

noveBits = True

#definição dos mnemônicos e seus
#respectivo OPCODEs (em Hexadecimal)
mne =	{ 
       "NOP":   "0",
       "LDA":   "1",
       "SOMA":  "2",
       "SUB":   "3",
       "LDI":   "4",
       "STA":   "5",
       "JMP":   "6",
       "JEQ":   "7",
       "CEQ":   "8",
       "JSR":   "9",
       "RET":   "A",
}

keys = {
    "KEY0": 511,
    "KEY1": 510,
    "KEY2": 509,
    "FPGA_RESET": 508,
}

#Converte o valor após o caractere arroba '@'
#em um valor hexadecimal de 2 dígitos (8 bits)
def  converteArroba(line):
    line = line.split('@')
    line[1] = hex(int(line[1]))[2:].upper().zfill(2)
    line = ''.join(line)
    return line
    
#Converte o valor após o caractere arroba '@'
#em um valor hexadecimal de 2 dígitos (8 bits) e...
#concatena com o bit de habilita 
# def  converteArroba9bits(line):
#     line = line.split('@')
#     if(int(line[1]) > 255 ):
#         line[1] = str(int(line[1]) - 256)
#         line[1] = hex(int(line[1]))[2:].upper().zfill(2)
#         line[1] = " & \"00\" & '1' & x\"" + line[1]
#     else:
#         line[1] = hex(int(line[1]))[2:].upper().zfill(2)
#         line[1] = " & \"00\" & '0' & x\"" + line[1]
#     line = ''.join(line)
#     return line

def converteArroba9bits(line):
    # Verifica se há algum label na linha
    line_parts = line.split('@')
    label = line_parts[1].split()[0]  # Separa o label dos possíveis comentários

    # Verifica se o label é uma das chaves no dicionário e substitui pelo valor correspondente
    if label in keys:
        value = keys[label]
    else:
        value = int(label)  # Caso contrário, trata como um número normal

    # Converte o valor para hexadecimal e prepara a string com ou sem o bit de habilita
    if value > 255:
        adjusted_value = value - 256
        hex_value = hex(adjusted_value)[2:].upper().zfill(2)
        formatted_value = f" & \"00\" & '1' & x\"{hex_value}"
    else:
        hex_value = hex(value)[2:].upper().zfill(2)
        formatted_value = f" & \"00\" & '0' & x\"{hex_value}"
    
    line = line_parts[0] + formatted_value
    return line


#Converte o valor após o caractere cifrão'$'
#em um valor hexadecimal de 2 dígitos (8 bits) 
def  converteCifrao(line):
    line = line.split('$')
    line[1] = hex(int(line[1]))[2:].upper().zfill(2)
    line = ''.join(line)
    return line

#Converte o valor após o caractere arroba '$'
#em um valor hexadecimal de 2 dígitos (8 bits) e...
#concatena com o bit de habilita 
def  converteCifrao9bits(line):
    line = line.split('$')
    if(int(line[1]) > 255 ):
        line[1] = str(int(line[1]) - 256)
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = " & \"00\" & '1' & x\"" + line[1]
    else:
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = " & \"00\" & '0' & x\"" + line[1]
    line = ''.join(line)
    return line

def converte_virgula(line):
    line = line.split(',')
    mem = line[1]
    # if '@' in line[1]:
    #     mem = line[1].split('@')[1]
    # else:
    #     mem = line[1].split('$')[1]

    opcode, reg_number = line[0].split('R')
    end_reg = bin(int(reg_number))[2:].zfill(2)

    if(int(mem) > 255 ):
        mem = str(int(mem) - 256)
        mem = hex(int(mem))[2:].upper().zfill(2)
        line = opcode + " & " + "\"" + end_reg + "\"" + " & '1'" + " & x\"" + mem
    else:
        mem = hex(int(mem))[2:].upper().zfill(2)
        line = opcode + " & " + "\"" + end_reg + "\"" + " & '0'" + " & x\"" + mem
    return line
       
#Define a string que representa o comentário
#a partir do caractere cerquilha '#'
def defineComentario(line):
    if '#' in line:
        line = line.split('#')
        line = line[0] + "\t#" + line[1]
        return line
    else:
        return line

#Remove o comentário a partir do caractere cerquilha '#',
#deixando apenas a instrução
def defineInstrucao(line):
    line = line.split('#')
    line = line[0]
    return line
    
#Consulta o dicionário e "converte" o mnemônico em
#seu respectivo valor em hexadecimal
def trataMnemonico(line):
    line = line.replace("\n", "") #Remove o caracter de final de linha
    line = line.replace("\t", "") #Remove o caracter de tabulacao
    line = line.split(' ')
    # line[0] = mne[line[0]]
    line = "".join(line)
    return line
    
def coletar_labels(lines):
    labels = {}
    linha_atual = 0
    for line in lines:
        if line.strip().endswith(':'):  # Detecta um label
            label_name = line.strip()[:-1]  # Remove o ':' do final
            labels[label_name] = linha_atual  # Associa o label ao número da linha atual
        else:
            # Apenas linhas que não são labels ou linhas vazias/comentários contam
            if not (line.strip().startswith('#') or not line.strip()):
                linha_atual += 1
    return labels

def substitui_labels(lines, labels):
    nova_lista_de_linhas = []
    for line in lines:
        if "@" in line:  # Possui um possível label
            partes = line.split('@')
            instrucao, pos_label = partes[0], partes[1].split()[0]  # Assume que o label está logo após o '@'
            if pos_label in labels:  # Se o label existe no dicionário
                # Substitui o label pelo seu número de linha correspondente
                nova_linha = f"{instrucao}@{labels[pos_label]}" + " ".join(partes[1].split()[1:])
                nova_lista_de_linhas.append(nova_linha)
            else:
                nova_lista_de_linhas.append(line)  # Mantém a linha como está se não for um label
        else:
            nova_lista_de_linhas.append(line)
    return nova_lista_de_linhas

with open(inputASM, "r") as f: #Abre o arquivo ASM
    lines = f.readlines() #Verifica a quantidade de linhas

labels = coletar_labels(lines)
lines = substitui_labels(lines, labels)
    
with open(outputBIN, "w+") as f:  #Abre o destino BIN

    cont = 0 #Cria uma variável para contagem
    
    for line in lines:        
        if line.strip().endswith(':'):  # Pula linhas que são declarações de labels
            continue
        #Verifica se a linha começa com alguns caracteres invalidos ('\n' ou ' ' ou '#')
        elif (line.startswith('\n') or line.startswith(' ') or line.startswith('#')):
            line = line.replace("\n", "")
            print("-- Sintaxe invalida" + ' na Linha: ' + ' --> (' + line + ')') #Print apenas para debug
        
        #Se a linha for válida para conversão, executa
        else:
            
            #Exemplo de linha => 1. JSR @14 #comentario1
            comentarioLine = defineComentario(line).replace("\n","") #Define o comentário da linha. Ex: #comentario1
            instrucaoLine = defineInstrucao(line).replace("\n","") #Define a instrução. Ex: JSR @14
            
            instrucaoLine = trataMnemonico(instrucaoLine) #Trata o mnemonico. Ex(JSR @14): x"9" @14
            # print("instrucao line: ", instrucaoLine)
            if ',' in instrucaoLine: #Se encontrar o caractere vírgula ','
                instrucaoLine = converte_virgula(instrucaoLine)
                
            elif '@' in instrucaoLine: #Se encontrar o caractere arroba '@' 
                if noveBits == False:
                    instrucaoLine = converteArroba(instrucaoLine) #converte o número após o caractere Ex(JSR @14): x"9" x"0E"
                else:
                    instrucaoLine = converteArroba9bits(instrucaoLine) #converte o número após o caractere Ex(JSR @14): x"9" x"0E"
                    print("instrucao line: ", instrucaoLine)
                    
            elif '$' in instrucaoLine: #Se encontrar o caractere cifrao '$'
                if noveBits == False:
                    instrucaoLine = converteCifrao(instrucaoLine) #converte o número após o caractere Ex(LDI $5): x"4" x"05"
                else:
                    instrucaoLine = converteCifrao9bits(instrucaoLine) #converte o número após o caractere Ex(LDI $5): x"4" x"05"                    
                    
            else: #Senão, se a instrução nao possuir nenhum imediato, ou seja, nao conter '@' ou '$'
                instrucaoLine = instrucaoLine.replace("\n", "") #Remove a quebra de linha
                if noveBits == False:
                    instrucaoLine = instrucaoLine + '00' #Acrescenta o valor x"00". Ex(RET): x"A" x"00"
                else:
                    instrucaoLine = instrucaoLine + " & " + "\"00\" & " + "\'0\' & " + "x\"00" #Acrescenta o valor x"00". Ex(RET): x"A" x"00"
            # print("instrucao line: ", instrucaoLine)
            line = 'tmp(' + str(cont) + ') := ' + instrucaoLine + '";\t-- ' + comentarioLine + '\n'  #Formata para o arquivo BIN
                                                                                                       #Entrada => 1. JSR @14 #comentario1
                                                                                                       #Saída =>   1. tmp(0) := x"90E";	-- JSR @14 	#comentario1
                                        
            cont+=1 #Incrementa a variável de contagem, utilizada para incrementar as posições de memória no VHDL
            f.write(line) #Escreve no arquivo BIN.txt
            
            print(line,end = '') #Print apenas para debug
            

            
############################             
############################            
#Conversão para arquivo .mif
############################             
############################
            
with open(outputMIF, "r") as f: #Abre o arquivo .mif
    headerMIF = f.readlines() #Faz a leitura das linhas do arquivo,
                              #para fazer a aquisição do header
    
    
with open(outputBIN, "r") as f: #Abre o arquivo BIN
    lines = f.readlines() #Faz a leitura das linhas do arquivo
    
    
with open(outputMIF, "w") as f:  #Abre o destino .mif novamente
                                 #agora para preenchê-lo com o pograma

    cont = 0 #Cria uma variável para contagem
    
    #########################################
    #Preenche com o header lido anteriormente 
    for lineHeader in headerMIF:      
        if cont < 21:           #Contagem das linhas de cabeçalho
            f.write(lineHeader) #Escreve no arquivo se saída .mif o cabeçalho (21 linhas)
        cont = cont + 1         #Incrementa varíavel de contagem
   #-----------------------------------------
   ##########################################
  
    for line in lines: #Varre as linhas do código formatado para a ROM (VHDL)
    
        replacements = [('t', ''), ('m', ''), ('p', ''), ('(', ''), (')', ''), ('=', ''), ('x', ''), ('"', '')] #Define os caracteres que serão excluídos
        
        ##########################################
        #Remove os caracteres que foram definidos
        for char, replacement in replacements:
            if char in line:
                line = line.replace(char, replacement)
        #-----------------------------------------
        ##########################################
                
        line = line.split('#') #Remove o comentário da linha
        
        if "\n" in line[0]:
            line = line[0] 
        else:
            line = line[0] + '\n' #Insere a quebra de linha ('\n') caso não tenha

        f.write(line) #Escreve no arquivo initROM.mif
    f.write("END;") #Acrescente o indicador de finalização da memória. (END;)
