# Wed Jan 24 16:24:06 2024 ------------------------------

# Cargamos os paquetes
library(rvest)
library(dplyr)
library(stringr)
# 00_regex e stringr ----------------------------------------------------------------
#Bibliografia
# https://r4ds.had.co.nz/strings.html
# https://www.datacamp.com/tutorial/regex-r-regular-expressions-guide
# https://stringr.tidyverse.org/articles/regular-expressions.html


##FUNCIONS BASICAS
# Crear un vector de cadeas de texto
frases <- c("Ide comprar pan", "Donde estas?", "Entorno desenvolvemento",
            "Garda para despois","Adiante!")

#Saber a lonxitude en caracteres de cada frase
str_length(frases)
nchar(frases)

#De mmaiusculas a minusculas
minusculas <- 
str_to_lower(frases)
maiusculas <- 
#Viceversa
str_to_upper(frases)

#A primeira de cada frase en maiuscula
str_to_title(minusculas)

# Detectar se as frases contenhen a letra "a"
str_detect(frases, "a")

# Extraer a primeira palabra de cada frase
str_extract(frases, "\\w+")

# Reemplazar a palabra "Entorno" por "Lugar" 
str_replace(frases, "Entorno", "Lugar")

# Dividir as frases por o espazo en branco
str_split(frases, " ")

# Combinar as frases con un punto e coma
str_c(frases, collapse = "; ")

#Extraer un numero de caracteres de cada frase
str_sub(frases, 1, 1)

##DELIMITADORES
# Crear un vector de cadeas de texto
nomes <- c("Ana", "Luis", "Eva", "Xoan", "Sara", "David")

# Buscar os nomes que comezan por A
str_detect(nomes, "^A")

# Buscar os nomes que rematan en a
str_detect(nomes, "a$")

# Buscar os nomes que contenhan a,b ou c
str_detect(nomes, "[abc]")
# Buscar os nomes que tenhen exactamente tres letras
str_detect(nomes, "^\\w{3}$")

# Buscar os nomes que contenhen a letra v seguida dunha vogal
str_detect(nomes, "v\\b")

# Buscar los nomes que contenhen a letra a en calquera posición agas ao final
str_detect(nomes, "a\\B")

## Referencia anterior

# Crear un vector de cadeas de texto con nomes de paises e capitais
paises <- c("España-Madrid", "Francia-París", "Alemania-Berlín", "Italia-Roma", "Portugal-Lisboa")

# Substitucion de - entre caracteres alfanumericos (\\w+) por eses caracteres separados por coma
str_replace_all(paises, "(\\w+)-(\\w+)", "\\2, \\1")
# 01_Wescraping descarga de arquivos-----------------------------------------------------------------

##IGE
#https://www.ige.gal/igebdt/selector.jsp?COD=9974&paxina=001&c=0201001006&idioma=gl
readr::read_csv("https://www.ige.gal/igebdt/igeapi/datos/9974/0:200201,1:0,2:0,9915:12")
#AEITG
download.file(url = "https://abertos.xunta.gal/catalogo/economia-empresa-emprego/-/dataset/0605/calendario-festivos-habiles-para-practica/001/descarga-directa-ficheiro.csv",
              destfile = "data/sesion_2/calendario_festivos_habiles_2024.csv")
# 02_Webscraping en html gardado -------------------------------------------------------

# Idicamos o arquivo html
arquivo_html <- here::here("data","sesion_2","03_html_completo.html")
# Leemos el contenido HTML de la página 
paxina <- read_html(arquivo_html)
# Extraemos o titulo da paxina usando o selector CSS "h1" 
titulo <- paxina %>% html_node("h1") %>% html_text()
print(titulo)
# Extraemos o subtitulo da paxina usando o selector CSS "h2" 
subtitulos <- paxina %>% html_nodes("h2") %>% html_text()
print(subtitulos)


#Extraer o id dos encabezados
id_h2 <- paxina %>% html_nodes("h2") %>% html_attr("id")
print(id_h2)

h2_subencabezado_1 <- 
paxina %>% html_nodes(xpath = "//h2[@id='subencabezado_1']")
print(h2_subencabezado_1)

# Extraemos los enlaces da paxina usando el selector CSS "a" e o atributo "href"
enlaces <- paxina %>% html_nodes("a") %>% html_attr("href")
print(enlaces)

# 03_Webscraping en paxina web: Wikipedia ---------------------------------------------------------
# Idicamos a url
url <- "https://es.wikipedia.org/wiki/Anexo:Municipios_de_Galicia_por_poblaci%C3%B3n"
# Leemos el contenido HTML de la página 
paxina <- read_html(url)
# Extraemos o titulo da paxina usando o selector CSS "h1" 
#CSS
titulo <- paxina %>% html_node(".mw-page-title-main") %>% html_text()
print(titulo)

#Xpath
titulo <- paxina %>% html_node(xpath="//*[@id='firstHeading']/span[3]") %>% html_text()
#Extraer a taboa
taboa <- 
paxina %>% html_nodes(".mw-parser-output") %>% 
  html_nodes(xpath="//*[@id='mw-content-text']/div[1]/table") %>% 
  html_table()

taboa <- 
paxina %>% 
  html_nodes(xpath="//*[@id='mw-content-text']/div[1]/table") %>% 
  html_table() 


#Extraccion urls das paxinas dos municipios
urls_municipios <- 
paxina %>% 
  html_nodes(xpath="//*[@id='mw-content-text']/div[1]/table") %>% 
  html_nodes("td") %>% 
  html_nodes("a") %>% 
  html_attr("href") %>% 
  #Filtrar aqueles que tenhen nome de provincia
  .[!str_detect(.,"Provincia")]

#Extraer a informacion basica de Vigo
url_wikipedia <- "https://es.wikipedia.org/"

#Crear url de vigo
url_vigo <- paste0(url_wikipedia,urls_municipios[1])
#Abrir paxina

paxina_vigo <- read_html(url_vigo)

#Titulo
titulo_vigo <- paxina_vigo %>% html_nodes(".mw-page-title-main") %>% html_text()
#Nomes dos apartados sobre informacion basica
titulos_informacion_basica <- 
paxina_vigo %>% html_nodes("table[class='infobox geography vcard']") %>% 
  html_nodes("th[scope='row']") %>% html_text()
#Contidos de informacion basica
contidos_informacion_basica <- 
  paxina_vigo %>% html_nodes("table[class='infobox geography vcard']") %>% 
  html_nodes("td[colspan='2']") %>% html_text() %>% 
  str_replace(.,"\n","")

#Taboa de informacion basica
taboa_informacion_basica <- 
  tibble(Titulo  = titulos_informacion_basica,
         Contido = contidos_informacion_basica)
  
#Usar un bucle para extraer informacion de todos os municipios
for (municipio in urls_municipios) {
  
  #Crear url dun municipio
  url_municipio <- paste0(url_wikipedia,municipio)
  #Abrir paxina
  paxina_municipio <- read_html(url_municipio)
  #Titulo
  titulo_municipio<- paxina_municipio %>% html_nodes(".mw-page-title-main") %>% html_text()
  
  # Imprimir uo nome do municipio
  cat("Scrapeando a paxina de ", titulo_municipio, "\n")
  #Nomes dos apartados sobre informacion basica
  titulos_informacion_basica <- 
    paxina_municipio %>% html_nodes("table[class='infobox geography vcard']") %>% 
    html_nodes("th[scope='row']") %>% html_text()
  #Contidos de informacion basica
  contidos_informacion_basica <- 
    paxina_municipio %>% html_nodes("table[class='infobox geography vcard']") %>% 
    html_nodes("td[colspan='2']") %>% html_text() %>% 
    str_replace(.,"\n","")
  #Taboa de informacion basica
  taboa_informacion_basica <- 
    tibble(Titulo  = titulos_informacion_basica,
           Contido = contidos_informacion_basica) 
  
}

#Extraer informacion dos municipios en formato funcion

#Funcion
extraccion_info_basica_municipio <- function(municipio, url_wikipedia) {
  
  #Crear url dun municipio
  url_municipio <- paste0(url_wikipedia,municipio)
  #Abrir paxina
  paxina_municipio <- read_html(url_municipio)
  #Titulo
  titulo_municipio<- paxina_municipio %>% html_nodes(".mw-page-title-main") %>% html_text()
  #Nomes dos apartados sobre informacion basica
  titulos_informacion_basica <- 
    paxina_municipio %>% html_nodes("table[class='infobox geography vcard']") %>% 
    html_nodes("th[scope='row']") %>% html_text()
  #Contidos de informacion basica
  contidos_informacion_basica <- 
    paxina_municipio %>% html_nodes("table[class='infobox geography vcard']") %>% 
    html_nodes("td[colspan='2']") %>% html_text() %>% 
    str_replace(.,"\n","")
  #Taboa de informacion basica
  taboa_informacion_basica <- 
    tibble(Titulo  = titulos_informacion_basica,
           Contido = contidos_informacion_basica) 
  #Taboa final
  return(taboa_informacion_basica)
  
}
#aplicar funcion
extraccion_info_basica_municipio(municipio     = urls_municipios[4],
                                 url_wikipedia = "https://es.wikipedia.org/")
# 04_Webscraping paxina Sergas ------------------------------------------------------
url_sergas_comunicacion <- "https://saladecomunicacion.sergas.gal"
#Paxina 189 da web de comunicacion do Sergas
url_sergas_covid <- "https://saladecomunicacion.sergas.gal/Paginas/ListaxeNovas.aspx?paxina=190"

#Lectura paxina
paxina_sergas <- read_html(url_sergas_covid)
#Extraemos os titulos dos artigos
urls_artigos_sergas_covid <- 
  paxina_sergas %>% html_nodes(xpath="//*[@class='listaNoticia']") %>% 
  html_nodes("a") %>% 
  html_attr("href")

#titulos artigos covid
titulos_artigos_sergas <- 
  paxina_sergas %>% html_nodes(xpath="//*[@class='listaNoticia']") %>% 
  html_nodes("a") %>% html_text()

#Detectar artigos con "Casos activos"
artigos_con_casos_activos <- 
  str_detect(titulos_artigos_sergas,"CASOS ACTIVOS")


#Filtramos as urls so de "Casos activos"
urls_artigos_sel <- 
  urls_artigos_sergas_covid[artigos_con_casos_activos]


#Lectura do primeiro artigo
artigo_covid <- read_html(paste0(url_sergas_comunicacion,urls_artigos_sel[1]))

#Extraer o corpo do texto
corpo_texto <- 
  artigo_covid %>% 
  html_nodes(xpath="//*[@class='textoNewDetalle']") %>% 
  html_text()
#Extraer a informacion do numero de casos activos en galicia
casos_activos <- 
  str_extract(corpo_texto,"casos activos de coronavirus en Galicia(.*?)[0-9]+,") %>% 
  str_extract_all(.,"[0-9]+") %>% unlist() %>% 
  str_c(.,collapse="") %>% as.numeric()
#Extraer a informacion da data do artigo
data_informacion <- 
  artigo_covid %>% 
  html_nodes(xpath="//*[@id='audioidReadSpeakerDataNova']") %>% 
  html_text() %>% 
  str_extract_all(.,"[0-9]+") %>% unlist() %>% 
  str_c(.,collapse="") %>% 
  as.Date(.,format="%d%m%Y")

#Construir taboa de alamacenamento de casos activos por data
taboa_casos_activos <- tibble(data          = data_informacion,
                              casos_activos = casos_activos)

#Extraer o numero de casos activos
