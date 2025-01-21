## CPI - Desafio para analista de dados
## Julia Niemeyer - 2025
#Desafio IV – Capacidade de checar dupla contagem por similaridades e uniões

# Instalar pacotes necessários
library(dplyr)
library(readxl)
library(stringi)
library(stringr)
library(text2vec)
library(writexl)
library(stringdist)

## Ler planilhas
base1 <- read_csv("./Etapa_IV/Base1.csv")
base2 <- read_xlsx("./Etapa_IV/Base2.xlsx")

#limpar planilhas de caracteres especiais etc.
df1 <- base1 %>%
  #Remove caracteres especiais e acentos
  mutate(across(where(is.character), ~ stri_trans_general(., "Latin-ASCII"))) %>%
  # Remove todos os caracteres não alfanuméricos e espaços extras
  mutate(across(where(is.character), ~ str_remove_all(., "[^[:alnum:] ]"))) %>%
  # muda o nome da coluna
  rename(Projeto1 = project_name_Base1) %>%
  # Pega apenas valores únicos
  distinct(Projeto1, .keep_all = TRUE)


df2 <- base2 %>%
  #Remove caracteres especiais e acentos
  mutate(across(where(is.character), ~ stri_trans_general(., "Latin-ASCII"))) %>%
  # Remove todos os caracteres não alfanuméricos e espaços extras
  mutate(across(where(is.character), ~ str_remove_all(., "[^[:alnum:] ]"))) %>%
  # muda o nome da coluna
  rename(Projeto2 = project_name_Base2)  %>%
  # Pega apenas valores únicos
  distinct(Projeto2, .keep_all = TRUE)

# Função que substitui a palavra "PV" por "Solar"
replace_PV_with_Solar <- function(df) {
  # Apply the replacement only to character columns
  df <- df %>%
    mutate(across(where(is.character), ~ gsub("\\bPV\\b", "Solar", .)))
  
  return(df)
}

df1 <- replace_PV_with_Solar(df1)
df2 <- replace_PV_with_Solar(df2)


# Função para calcular o índice de Jaccard entre df1$Projeto1 e df2$Projeto2
comparar_jaccard <- function(df1, df2) {
  
  # Função para calcular o índice de Jaccard entre dois textos
  jaccard_index <- function(text1, text2) {
    # Tokenizar e transformar os textos em minúsculas
    tokens1 <- unique(unlist(strsplit(tolower(text1), " "))) 
    tokens2 <- unique(unlist(strsplit(tolower(text2), " "))) 
    
    # Calcular o índice de Jaccard
    jaccard_sim <- length(intersect(tokens1, tokens2)) / length(union(tokens1, tokens2))
    
    return(jaccard_sim)
  }
  
  # Criar um dataframe vazio para armazenar os resultados
  resultados <- data.frame(Project1 = character(), Project2 = character(), JaccardIndex = numeric(), stringsAsFactors = FALSE)
  
  # Loop para comparar todas as linhas de df1$Projeto1 com todas de df2$Projeto2
  for (project1 in df1$Projeto1) {
    for (project2 in df2$Projeto2) {
      # Calcular o índice de Jaccard para o par de textos
      jaccard_sim <- jaccard_index(project1, project2)
      
      # Adicionar o resultado ao dataframe
      resultados <- resultados %>%
        add_row(Project1 = project1, Project2 = project2, JaccardIndex = jaccard_sim)
    }
  }
  
  return(resultados)
}

# Aplicar função
resultados_jaccard <- comparar_jaccard(df1, df2)

# Exibir os resultados
#View(resultados_jaccard)

#Filtrar resultado
result_df <- resultados_jaccard %>%
    filter(resultados_jaccard$JaccardIndex >= 0.5555556) 

#View(result_df)

#Retirar manualmente os que não são semelhantes/iguais
final_df <- result_df[-c(3,4,9:14,16,20:23,25:29),]
View(final_df)

## salvar resultado
write_xlsx(final_df, "./Etapa_IV/Resultado_IV/Resultado_DesafioIV_JuliaNiemeyer.xlsx")
