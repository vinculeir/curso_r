# Tue Feb 13 16:08:11 2024 ------------------------------


# Cargamos os paquetes
library(rvest)
library(dplyr)
library(stringr)
library(ggplot2)
# 00_regex e stringr ----------------------------------------------------------------
#Bibliografia
# https://r4ds.had.co.nz/strings.html
# https://www.datacamp.com/tutorial/regex-r-regular-expressions-guide
# https://stringr.tidyverse.org/articles/regular-expressions.html

# Lista de paquetes para conectar con APIS
# https://gist.github.com/zhiiiyang/fc19995f7e350f3c7fb940757f6213cf

##Analisis de redes sociales: Twitter
# https://developer.twitter.com/en/docs
# https://developer.twitter.com/en/apps
# https://www.diegocalvo.es/obtener-datos-de-twitter-con-r-usando-su-api/
# https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html
# https://www.rdocumentation.org/packages/sentimentr/versions/2.9.0
# https://www.rdocumentation.org/packages/sentimentr/versions/2.9.0
# https://developer.twitter.com/en/docs/tutorials/getting-started-with-r-and-v2-of-the-twitter-api
# https://cloud.r-project.org/web/packages/rtweet/vignettes/auth.html#fn1
# https://www.youtube.com/watch?v=7SGphSAH7QA
# https://mkearney.github.io/nicar_tworkshop/#20
#
# Analisis de redes sociales: Facebook
# https://www.gacelaweb.com/conseguir-token-instagram-actualizado-2024/
#
# Analisis de redes sociales: Youtube
# https://www.gacelaweb.com/conseguir-token-instagram-actualizado-2024/
# https://cran.r-project.org/web/packages/tuber/vignettes/tuber-ex.html
# https://github.com/gojiplus/tuber?tab=readme-ov-file
# https://cran.r-project.org/web/packages/tuber/tuber.pdf
# RESOLUCION TAREFA BOOKING ---------------------------------------------------------

# O obxectivo desta tarefa e atopar os establecementos que se listan na busqueda de 
# Santiago de Compostela e extraer as suas caracteristicas
# METODO A: con rvest ---------------------------------------------------------------


#BOOKING Santiago de Compostela URL
url_booking_compostela <- 
  "https://www.booking.com/searchresults.es.html?ss=Santiago+de+Compostela&ssne=Santiago+de+Compostela&ssne_untouched=Santiago+de+Compostela&label=es-es-booking-desktop-onknyt5TBrS8m9RnGd*6fgS652829001115%3Apl%3Ata%3Ap1%3Ap2%3Aac%3Aap%3Aneg%3Afi%3Atikwd-65526620%3Alp1005518%3Ali%3Adec%3Adm&aid=2311236&lang=es&sb=1&src_elem=sb&src=searchresults&dest_id=-402059&dest_type=city&group_adults=2&no_rooms=1&group_children=0"



#Abrir paxina web con rvest
booking_compostela <- read_html(url_booking_compostela)

# Extraer urls dos establecementos
urls_establecementos <- 
booking_compostela %>% html_nodes("div[data-testid='property-card']") %>% 
  html_nodes("a[data-testid='title-link']") %>% 
  html_attr("href")

# Nomes dos establecementos
nome_establecementos <- 
  booking_compostela %>% html_nodes("div[data-testid='property-card']") %>% 
  html_nodes("div[data-testid='title']") %>% 
  html_text()
  







# METODO B: con RSelenium -----------------------------------------------------------

#Descargamos Docker Desktop


# Descargar a imaxe de Selenium con Firefox
system("docker pull selenium/standalone-firefox")

# Corresmos o container que contenha a imaxe do navegador Firefox
system("docker run -d -p 4445:4444 selenium/standalone-firefox")


#Extraer id container
id_container <- system("docker ps --no-trunc -q",intern=TRUE)

library(RSelenium)
#Iniciar navegador autonomo
driver <- rsDriver(browser = "firefox",
                   chromever=NULL,
                   verbose = FALSE)
navegador <- driver[["client"]] 

# Url base de booking
url_booking <- 
  "https://www.booking.com/index.es.html?label=gen173nr-1BCAEoggI46AdIM1gEaEaIAQGYAQq4ARfIAQ_YAQHoAQGIAgGoAgO4At2crq4GwAIB0gIkNzM4YzljZTctOTc0NS00MjEwLWEwYzEtNzc0MWQ3ODc1MDZm2AIF4AIB&sid=7b9e628803c3fd9e9f1d62ff2745cd5f&keep_landing=1&sb_price_type=total&"
#Navegar a la url indicada
navegador$navigate(url_booking)

#Atopar a caixa do buscador "Adonde Vas?"
buscador_caixa <- 
navegador$findElement(using="xpath",
                      "//*[@id=':re:']")
#Baleirar a caixa
buscador_caixa$clearElement()
#Encher
buscador_caixa$sendKeysToElement(list("Santiago de Compostela"))
#Clicar no boton "BUSCAR"
boton_buscar <- 
  navegador$findElement(using="xpath",
                        "/html/body/div[3]/div[2]/div/form/div[1]/div[4]/button/span")
#Clicar 
boton_buscar$clickElement()

# Lectura da paxina coa relacion de aloxamentos

#Extraemos o codigo da paxina actual completa
paxina_aloxamentos <- 
  xml2::read_html(navegador$getPageSource()[[1]]) 


# Extraer urls dos establecementos
urls_aloxamentos <- 
  paxina_aloxamentos %>% html_nodes("div[data-testid='property-card']") %>% 
  html_nodes("a[data-testid='title-link']") %>% 
  html_attr("href")

# Nomes dos establecementos
nome_aloxamentos <- 
  paxina_aloxamentos %>% html_nodes("div[data-testid='property-card']") %>% 
  html_nodes("div[data-testid='title']") %>% 
  html_text()


#Extraer o numero de paxinas de busqueda que temos
n_paxinas <- 
paxina_aloxamentos %>% html_nodes("li[class='b16a89683f']") %>% 
  html_text() %>% 
  as.numeric() %>% 
  max(.,na.rm=TRUE)

#  Crear un loop para ir pasando paxinas e obter os nomes e urls de cada un 
#  dos aloxamentos de todas as paxinas

lista_aloxamentos <- list()

for (paxina in 1:n_paxinas) {
  
  # Pasamos paxina 
  navegador$findElement(using="xpath",
                        paste0("//*[@aria-label=' ",paxina,"']"))$clickElement()
  # Paramos uns segundos para que cargue a paxina
  Sys.sleep(5)
  
  #Extraemos o codigo da paxina actual completa
  paxina_aloxamentos <- 
    xml2::read_html(navegador$getPageSource()[[1]]) 
  # Extraer urls dos establecementos
  urls_aloxamentos <- 
    paxina_aloxamentos %>% html_nodes("div[data-testid='property-card']") %>% 
    html_nodes("a[data-testid='title-link']") %>% 
    html_attr("href")
  # Nomes dos establecementos
  nome_aloxamentos <- 
    paxina_aloxamentos %>% html_nodes("div[data-testid='property-card']") %>% 
    html_nodes("div[data-testid='title']") %>% 
    html_text()  
  # Gardamos os nomes e as urls dos aloxamentos
  taboa_aloxamentos <- 
    tibble(nome_aloxamento = nome_aloxamentos,
           url_aloxamento  = urls_aloxamentos)
  #Imos almacenando a informacion dos aloxamentos nesta lista
  lista_aloxamentos[[paxina]] <- taboa_aloxamentos
  
  }


# Quedamonos cos aloxamentos unicos
aloxamentos_unicos <- 
lista_aloxamentos %>% bind_rows() %>% 
  unique()


# Extraer informacion dos 10 primeiros aloxamentos

## Funcion para extraer ubicacion e puntuacion dos aloxamentos
extraer_ubicacion_puntuacion <- function() {
  
  # Lemos a paxina do aloxamento
  paxina_aloxamento <-     xml2::read_html(navegador$getPageSource()[[1]]) 
  
  # Queremos extraer unha serie de datos:
  
  # Ubicacion / direccion
  ubicacion <- 
    paxina_aloxamento %>% html_nodes("p[id='showMap2']") %>% 
    html_nodes("span[class='\nhp_address_subtitle\njs-hp_address_subtitle\njq_tooltip\n']") %>% 
    html_text() %>% 
    str_replace_all(.,"\n","")
  
  # Putuacion da xente
  puntuacion <- 
    paxina_aloxamento %>%
    html_nodes("div[class='b2b990caf1']") %>%
    html_nodes("div[class='a3b8729ab1 d86cee9b25']") %>% 
    html_text() %>% 
    str_replace(.,",",".") %>% 
    as.numeric()
  
  # #Taboa dos prezos
  # taboa_prezos <- 
  # paxina_aloxamento %>%
  #   html_nodes("table[class='hprt-table  ']") %>% 
  #   html_table()

  # Taboa cos datos extraidos
  taboa_datos <- 
    tibble(ubicacion  = ubicacion,
           puntuacion = puntuacion)
  
  
  # Resultado final
  taboa_datos
  
  
  # # Resultado final
  # cbind(taboa_datos,taboa_prezos)
  
}

lista_informacion <- list()

for (aloxamento in 1:10) {
  Sys.sleep(3)
# Navegamos ao primeiro aloxamento
navegador$navigate(aloxamentos_unicos$url_aloxamento[aloxamento])

# Aplicamos a funcion de extraccion da informacion desexada  
  lista_informacion[[aloxamento]] <- 
extraer_ubicacion_puntuacion()
  
}

cbind(aloxamentos_unicos[1:10,],
lista_informacion %>% bind_rows()
)



#Navegar a la url indicada
navegador$navigate(url_booking)

#Atopar a caixa do buscador da data
buscador_caixa_data <- 
  navegador$findElement(using="xpath",
                        "//*[@class='a8887b152e']")
# Clicar na caixa da data
buscador_caixa_data$clickElement()


#Seleccionar a data do 17 de febreiro de 2024
navegador$findElement(using="xpath",
                      "//*[@aria-label='17 febrero 2024']")$clickElement()
#Seleccionar a data do 18 de febreiro de 2024
navegador$findElement(using="xpath",
                      "//*[@aria-label='18 febrero 2024']")$clickElement()
# Clicar na caixa da data
buscador_caixa_data$clickElement()

#Clicar no boton "BUSCAR"
  navegador$findElement(using="xpath",
                        "/html/body/div[3]/div[2]/div/form/div[1]/div[4]/button/span")$clickElement()

  
 
  # REMATE
  # Cerrar a conexión e e o contedor de Docker
  navegador$close() # pecha o  navegador
  driver[["server"]]$stop() # pecha o porto
  #Parar o container
  system(paste0("docker stop ",id_container))
  #Eliminar o container
  system(paste0("docker rm ",id_container))

# ANALISIS DE REDES SOCIAIS: YOUTUBE ------------------------------------------------
  
  #Antes hai que crear unha app en Google Cloud Console e verificala
  #https://cloud.google.com/gcp/?hl=es&utm_source=bing&utm_medium=cpc&utm_campaign=emea-es-all-es-dr-bkws-all-all-trial-e-gcp-1707574&utm_content=text-ad-none-any-DEV_c-CRE_526889177722-ADGP_Hybrid+%7C+BKWS+-+EXA+%7C+Txt+-+GCP+-+General+-+v7-KWID_43700069449301607-kwd-55675752867-userloc_1005518&utm_term=KW_google%20cloud%20console-NET_g-PLAC_&&gad_source=1&gclid=EAIaIQobChMI2Je99PqthAMV-6doCR0WUArtEAAYASAAEgIgsfD_BwE&gclsrc=aw.ds
  # Limite de cuota de youtube es 10.000 consultas por día
  library(tuber)
  # ID de client e ID segredo app sesion3TubeApp
  id_client = "882091881893-dv38ea44egbun6ja3ttfkvj2c140g0fo.apps.googleusercontent.com"
  secret_id = "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"
  # ID de client e ID segredo app sesion3TubeApp
  id_client = "875371711359-3lh96hgju5jmj4de05naffu25pa9b55k.apps.googleusercontent.com"
  secret_id =  "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"
  
  #Autenticacion cos datos anteriores
  yt_oauth(app_id = id_client,
           app_secret = secret_id)
  # #Abrir arquivo rds por se non funciona o paquete
  # info_tubeR <- readRDS(here::here("data/sesion_3/info_tubeR.rds"))
  #Escollemos un video e extraemos o seu id
  #https://www.youtube.com/watch?v=yNJiHFKSdqg
  video_id="yNJiHFKSdqg"
  #Extraer estatisticas do video
  estatisticas <- 
  get_stats(video_id=video_id)
  #Extraer os comentarios e a informacion parella
  comentarios <- 
  get_all_comments(video_id)
  # #Detalles do video
  detalles <-   get_video_details(video_id=video_id)
  # Buscar videos relacionados co tema "eleccións autonómicas Galicia 18F"
  videos <- yt_search(term = "Eleccións Galicia 18F", max_results = 20)
  # Atoparemos as estatisticas dos 20 primeiros videos da busqueda
  ids_20_videos <-   videos$video_id[1:20]

# Funcion para extraer informacion relevante dos videos desexados  
  extraer_estatisticas_video <- function(videoId) {
    #Informacion relevante
    estatisticas_video <- 
    get_stats(video_id=videoId)
    #Numero de visionados
    visionados <- estatisticas_video$viewCount
    
    detalles_video <- 
      get_video_details(video_id=videoId) 
    #Cnale a que pertence o video
    canle_video <- detalles_video$items[[1]]$snippet$channelTitle
    #Data na que foi publicado
    data_publicacion <- detalles_video$items[[1]]$snippet$publishedAt
    
    taboa_info_video <- 
      tibble(visionados = visionados,
             canle      = canle_video,
             data       = data_publicacion)
    
    #Resultado final
    taboa_info_video
    
  }

  
  lista_info_videos <- list()
  for(i in 1:length(ids_20_videos)){
    lista_info_videos[[i]] <-    extraer_estatisticas_video(ids_20_videos[i])
  }
  
  #Extraer a informacion dos 20 primeiros videos
  info_videos <- bind_rows(lista_info_videos) %>% 
    mutate(data=lubridate::date(data),
           visionados=as.numeric(visionados))
  
  # Facemos unha grafica cos datos
  ggplot(info_videos, aes(data, y = visionados, colour=canle, group = canle)) +
  geom_line(size=2) +
    geom_point(color="black")+
    facet_wrap(~canle)+
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    labs(x = "Data", y = "Número de vistas",
         title = "Vistas dos videos das eleccións autonómicas Galicia 18F por canles")
  
  
  #Extraer a informacion de todos os videos dunha canle (NOS TV)
  # https://www.youtube.com/@nostelevision_
  canle<- list_channel_resources(filter = c(channel_id = "UC7E39RyOqx_UkouqoZYJ8Rw"),
                              part="contentDetails")

  # Lista das playlists
  playlist_id <- canle$items[[1]]$contentDetails$relatedPlaylists$uploads
  
  # Extraer os videos das playlists
  videos_playlists <- get_playlist_items(filter= c(playlist_id=playlist_id)) 
  
  # Extraer as ids dos videos
  videos_playlists_ids <- as.vector(videos_playlists$contentDetails.videoId)
  
  # funcion para sacar as estatisticas dos videos das playlists
  get_all_stats <- function(id) {
    get_stats(id)
  } 
  
  # Get stats and convert results to data frame 
  resultados <- lapply(videos_playlists_ids, get_all_stats)
  resultados_df <- do.call(rbind, lapply(resultados, data.frame))
  
  head(resultados_df)
  
