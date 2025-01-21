## CPI - Desafio para analista de dados
## Julia Niemeyer - 2025

## Desafio III – Manipulação de dados não estruturados:
## Análise em Python

##Ler bibliotecas e pacotes
import os
import pdfplumber
from pathlib import Path
import pandas as pd

# Diretório de trabalho atual (obtido com os.getcwd())
diretorio_atual = Path(os.getcwd())

# Cria caminho relativo de input 
caminho_relativo = diretorio_atual / 'Etapa III' / 'Exemplo_Acao.pdf'

# Cria caminho relativo de output 
caminho_output = diretorio_atual / 'Etapa III' / 'Resultado_III' / 'Extracao_acao_JuliaNiemeyer.xlsx' 

# Open the PDF with pdfplumber
with pdfplumber.open(caminho_relativo) as pdf:
    # Para pegar em informações de todas as páginas do PDF
    for pagina in pdf.pages:
        # Extrai texto da página
        texto_pagina = pagina.extract_text()
        
        # Cria uma lista com o texto extraído
        if texto_pagina:  # Pra ter certeza que teve texto. Senão, teremos que rever como extrair as informações
            extracted_text.append(texto_pagina)


# Se certifica de que algum texto foi extraído
if extracted_text:
    # Junta a lista em uma única string 
    full_text = "\n".join(extracted_text)
    
    # Separa o texto por llinhas
    text_lines = full_text.split("\n")

# Cria um DataFrame com as informações
    df = pd.DataFrame(text_lines, columns=["Extracted Text"])
    
    # mostra a DataFrame (apenas inicio)
    print(df.head())  

##acessa a info sobre código de acesso baseado no indice da df
codigo_acao = df.iloc[6]['Extracted Text']

##acessa a info sobre descrição baseado no indice da df
desc_acao = df.iloc[[9,10,11]]

# Concatena os textos da descrição em uma única string
desc_acao = " ".join(desc_acao['Extracted Text'])

# Cria um novo dataframe e junta as informações
df_novo = pd.DataFrame({
    'Codigo': [codigo_acao],
    'Descricao': [desc_acao]
})

# Exibe o novo dataframe
print(df_novo)

#salva o dataframe como xlsx
df_novo.to_excel(caminho_output, index=False, engine='xlsxwriter')

