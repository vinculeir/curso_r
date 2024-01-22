
# Wed Jan 17 13:11:59 2024 ------------------------------


# PUNTO 1: Directorio de traballo------------------------------------------------------

# Crear Rproj 
# Modificar preferencias de RStudio

# PUNTO 3: Estrutura de directorios -------------------------------------------------

#data
#R
#rmd
#outputs

# PUNTO 3: Nomes dos arquivos -------------------------------------------------------

#Evita usar espazos

arquivo un

arquivo_un

# Evitar usar caracteres especiais: @£$%^&*(:/) 

arquivo$
arquivo@
  
  
# Usa unha secuencia de numeros adecuada
  
arquivo1
...
arquivo10


arquivo01
...
arquivo10


# Formato de data ISO 8601

arquivovenresxaneiro24

arquivo_2024_01_19

# Nunca uses o prefixo _final

arquivo_final

# PUNTO 4: Operadores ---------------------------------------------------------------

5 + 3

5 - 3

5 * 3

5 / 3

5 * 3

5 %% 3


5 == 3

5 != 3

5 < 3

5 > 3

5 <= 3

5 >= 3


TRUE | FALSE

TRUE & FALSE

!TRUE

isTRUE(FALSE)


gasto_diario <- 1

gasto_diario = 1


# PUNTO 5: Tipos de datos -----------------------------------------------------------


#Tipos
numero <- 2.2
class(numero)


caracter <- "ola"
class(caracter)


factor <- factor(c("1","a","b"))
class(factor)

loxico <- TRUE
class(logi)


is.numeric(num)

is.character(num)

is.character(char)

is.logical(logi)


#Coercion

# numeric en character
class(num)

num_char <-  as.character(num)

class(num_char)

# PUNTO 6: Estruturas de datos ------------------------------------------------------

escalar <- c(1)

vector <- c(1,2,3,4)

matriz <- matrix(1:16, nrow = 4, byrow = TRUE)
matriz

un_array <- array(1:16, dim = c(2, 4, 2))
un_array

rownames(my_mat) <- c("A", "B", "C", "D")
colnames(my_mat) <- c("a", "b", "c", "d")


lista <- list(c("black", "yellow", "orange"),
               c(TRUE, TRUE, FALSE, TRUE, FALSE, FALSE),
               matrix(1:6, nrow = 3))

p.height <- c(180, 155, 160, 167, 181)
p.weight <- c(65, 50, 52, 58, 70)
p.names <- c("Joanna", "Charlotte", "Helen", "Karen", "Amy")

data_frame <- data.frame(height = p.height, weight = p.weight, names = p.names)
data_frame


# PUNTO 7: Traballar con arquivos ---------------------------------------------------



# PUNTO 7.1: Abrir arquivos ---------------------------------------------------------

#Abrir csv
peregrinos_csv <- read.csv2(file = 'data/arquivo_exemplo.csv', header = TRUE, sep = ";",
                            stringsAsFactors = TRUE)
#Abrir txt

peregrinos_txt <- read.table(file = 'data/arquivo_exemplo.txt', header = TRUE, sep = "\t",
                      stringsAsFactors = TRUE)
#Outro comando para abrir unha taboa con extension "txt"
peregrinos_txt <- read.delim(file = 'data/arquivo_exemplo.txt') 

#Abrir Excel

library(openxlsx)

peregrinos_xslxs <- read.xlsx(xlsxFile = "data/arquivo_exemplo.xlsx")


#Dimensiones dos dataframes
dim(peregrinos_txt)

dim(peregrinos_csv)

dim(peregrinos_xslxs)

#Con estos comandos podemos ter informacion sobre o tipo de variables que conforman
# o data frame
str(peregrinos_txt)
dplyr::glimpse(peregrinos_txt)


#As seguintes funciones permiten abrir as taboas e devolver o formato tibble do tidyverse
library(readr)

peregrinos_txt <- read_table(file = 'data/arquivo_exemplo.txt')


peregrinos_csv <- read_csv2(file = 'data/arquivo_exemplo.csv')


library(readxl)

peregrinos_xslxs <- read_excel(path = "data/arquivo_exemplo.xlsx")

# PUNTO 7.2: Limpar arquivos (wrangling) ---------------------------------------------------------

library(dplyr)

peregrinos <- read_csv2(file = 'data/arquivo_exemplo.csv')

#Extraer unha variable

peregrinos$Caminho

# Extraer un dos datos por posicion

peregrinos[1,1]

peregrinos[,1]

peregrinos$Caminho[1]

#Asignar unha das columnas a un novo obxecto
peregrinos_idade <- peregrinos$Idade

#Obter a media
mean(peregrinos_idade)

#Obter o resumo da variable
summary(peregrinos_idade)


# Extraer datos con operadores loxicos

peregrinos %>% filter(Idade>30&Sexo=="Hombre")

#Filtrar a taboa xeral e obter unha soa cos datos do caminho frances
caminho_frances <- peregrinos %>% filter(Caminho=="Frances")
#Ordeanr

peregrinos %>% arrange(desc(Idade))

#Engadir variables

##Creamos unha nova variable
ano = rep("2023",len=nrow(peregrinos))


#Engadimos variable ao dataframe
peregrinos %>% mutate(Ano=ano)

peregrinos %>% mutate(Ano=2023)


# Unir varias taboas

peregrinos_2 <- read_excel("data/arquivo_exemplo_2.xlsx")

#Unir duas taboas primando a primeira mediante tres variables comuns: Caminho, Sexo e Idade
peregrinos_union <- 
left_join(
  caminho_frances,
peregrinos_2,
by=c("Caminho","Sexo","Idade"))


#Reagrupar as taboas
library(tidyr)


#Formato amplo
peregrinos_wide <- 
peregrinos[1:10,] %>% pivot_wider(names_from=Sexo,
                           values_from=Gasto_diario)

#Formato estreito
peregrinos_wide %>%
  pivot_longer(cols=c(Hombre,Mujer),
               names_to="Sexo",
               values_to="Gasto_diario")

#Agrupar e resumir


summary(peregrinos$Idade)

table(peregrinos$Sexo)

table(peregrinos$Sexo,peregrinos$Caminho)


#Obter a idade media por sexo
peregrinos_idad_media <- 
peregrinos %>% group_by(Sexo) %>% 
  summarise(Idade_media=mean(Idade,na.rm=TRUE))

# PUNTO 7.3: Exportar datos ---------------------------------------------------------


write.table(peregrinos_idad_media,
          "data/idade_media.txt")

write.csv(peregrinos_idad_media,
           "data/idade_media.csv")

saveRDS(peregrinos_idad_media,
                  "data/idade_media.rds")

# PUNTO 8: Debuxar un grafico -------------------------------------------------------

library(ggplot2)
peregrinos %>% 
  ggplot(aes(x=Idade, y=Gasto_diario,color=Sexo))+
  geom_point()+
  facet_wrap(~Caminho)
