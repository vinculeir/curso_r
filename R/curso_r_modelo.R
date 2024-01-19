
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
class(num)


caracter <- "ola"
class(char)


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

#Escalar


#Vector

#Matriz

#Array

#Lista

#Data frame



# PUNTO 7: Traballar con arquivos ---------------------------------------------------



# PUNTO 7.1: Abrir arquivos ---------------------------------------------------------


#Abrir Excel

#Abrir csv

#Abrir txt


# PUNTO 7.2: Limpar arquivos (wrangling) ---------------------------------------------------------

#Abrir arquivo de novo

library(dplyr)


#Extraer unha variable



# Extraer un dos datos por posicion


# Extraer datos por loxica con filter


#Ordenar


#Engadir variables

# Unir varias taboas

##Abrir nova taboa

#Reagrupar as taboas

# Operar por grupos


# PUNTO 8: Debuxar unha grafica -----------------------------------------------------





