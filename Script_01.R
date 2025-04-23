# Script simplificado para descargar datos de tasa de desempleo nacional de Ecuador
# Fuente: https://contenido.bce.fin.ec/documentos/informacioneconomica/indicadores/real/TasaDesempleoNacional.html

# Cargar librerías necesarias
if(!require("jsonlite")) install.packages("jsonlite")
if(!require("dplyr")) install.packages("dplyr")
if(!require("httr")) install.packages("httr")

library(jsonlite)
library(dplyr)
library(httr)

# URL del archivo JSON (identificado en el código fuente)
json_url <- "https://contenido.bce.fin.ec/documentos/informacioneconomica/indicadores/real/datos_tes.json"

# Descargar los datos JSON
cat("Descargando datos desde", json_url, "...\n")
response <- GET(json_url)

if(status_code(response) == 200) {
  cat("Datos descargados correctamente.\n")
  
  # Convertir los datos JSON a un dataframe de R
  data_json <- fromJSON(content(response, "text", encoding = "UTF-8"))
  
  # Extraer la vista 'view_ind_real_tes' que contiene los datos de tasa de desempleo
  if("view_ind_real_tes" %in% names(data_json)) {
    df_desempleo <- data_json$view_ind_real_tes
    
    # Filtrar los datos específicos de la tasa de desempleo nacional
    df_desempleo <- df_desempleo %>%
      filter(
        Indicador == "Tasa de desempleo nacional",
        `Código Variable Dinámica` == "val_var50",
        Segmento == "Indicadores de Empleo"
      ) %>%
      # Seleccionar solo Fecha y Valor
      select(Fecha, Valor) %>%
      # Convertir Valor a numérico
      mutate(Valor = as.numeric(gsub(",", ".", Valor))) %>%
      # Ordenar por fecha
      arrange(Fecha)
    
    # Verificar si hay datos
    if(nrow(df_desempleo) > 0) {
      cat("Se encontraron", nrow(df_desempleo), "registros de tasa de desempleo nacional.\n")
      
      # Mostrar los primeros registros
      print(head(df_desempleo))
      
      # Guardar como CSV
      nombre_archivo_csv <- "tasa_desempleo_ecuador_simple.csv"
      write.csv(df_desempleo, nombre_archivo_csv, row.names = FALSE)
      cat("Datos guardados en", nombre_archivo_csv, "\n")
      
    } else {
      cat("No se encontraron datos de tasa de desempleo nacional.\n")
    }
  } else {
    cat("No se encontró la vista 'view_ind_real_tes' en los datos JSON.\n")
  }
} else {
  cat("Error al descargar los datos. Código de estado:", status_code(response), "\n")
}

# El dataframe df_desempleo ahora contiene solo las columnas Fecha y Valor
# y está disponible en el entorno de R para análisis adicionales
