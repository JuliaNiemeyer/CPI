## CPI - Desafio para analista de dados
## Julia Niemeyer - 2025

## Desafio I – Tratamento e padronização dos dados:
##Ler bibliotecas e pacotes
library(dplyr)
library(readxl)
library(stringr)
library(stringi)
library(writexl)

## Ler planilha
dados <- read_xlsx("I:/Meu Drive/Job_applications/CPI/Desafio_Analista_Dados_CPI_2025/Desafio_Analista_Dados_CPI_2025/Etapa I e II/Desafio1 - SIOP.xlsx")

## a.Crie uma coluna chamada unidade_orcamentaria apenas com o código
result <- dados %>%
  mutate(
    unidade_orcamentaria = `Unidade Orçamentária` %>%
      # Remover o identificador numérico e " – "
      str_remove("^\\d+\\s?[-–]\\s?") %>%
      # Remove caracteres especiais e acentos
      stri_trans_general("Latin-ASCII") %>%
      # Remove todos os caracteres não alfanuméricos e espaços extras
      str_remove_all("[^[:alnum:] ]") %>%
      # Substituir múltiplos espaços por um único
      str_squish()
  )

#  View(result)

## b.Crie uma coluna chamada cod_unidade_orcamentaria com o código
result <- result %>%
  mutate(
    cod_unidade_orcamentaria = str_extract(`Unidade Orçamentária`, "^\\d+")
  )
#head(result)

## c. Crie uma coluna chamada programa 
result <- result %>%
  mutate(
    programa = Programa %>%
      # Remover o identificador numérico e " – "
      str_remove("^\\d+\\s?[-–]\\s?") %>%
      # Remove caracteres especiais e acentos
      stri_trans_general("Latin-ASCII") %>%
      # Remove todos os caracteres não alfanuméricos e espaços extras
      str_remove_all("[^[:alnum:] ]") %>%
      # Substituir múltiplos espaços por um único
      str_squish()
  )

#head(result)  

## d.Crie uma coluna chamada cod_programa,com o id do programa
result <- result %>%
  mutate(
    cod_programa = str_extract(Programa, "^\\d+")
  )
#head(result)

## e. Crie uma coluna chamada acao
result <- result %>%
  mutate(
    acao = `Ação` %>%
      # Remove os 5 primeiros caracteres alfanuméricos, incluindo o hífen
      str_remove("^.{5}") %>%
      # Remove caracteres especiais e acentos
      stri_trans_general("Latin-ASCII") %>%
      # Remove todos os caracteres não alfanuméricos e espaços extras
      str_remove_all("[^[:alnum:] ]") %>%
      # Substituir múltiplos espaços por um único
      str_squish()
  )


# f.Crie uma coluna chamada cod_acao, com o código da ação
result <- result %>%
  mutate(
    cod_acao = str_extract(`Ação`, "^.{4}")
  )

## salvar resultado
write_xlsx(result, "./Etapa I e II/Resultado_I_II/Resultado_DesafioI_JuliaNiemeyer.xlsx")
