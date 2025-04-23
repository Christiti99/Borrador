# Script para descargar datos de tasa de desempleo nacional de Ecuador
# Este script será ejecutado por el GitHub Action

if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

if (!require("httr")) install.packages("httr", repos = "https://cloud.r-project.org")
library(httr)


# Cargar librerías necesarias
library(jsonlite)
library(dplyr)
library(httr)

# Crear directorio de datos si no existe
if (!dir.exists("datos")) {
  dir.create("datos")
}

# URL del archivo JSON
json_url <- "https://contenido.bce.fin.ec/documentos/informacioneconomica/indicadores/real/datos_tes.json"

# Descargar los datos JSON
cat("Descargando datos desde", json_url, "...\n")
response <- GET(json_url)

if(status_code(response) == 200) {
  cat("Datos descargados correctamente.\n")
  
  # Convertir los datos JSON a un dataframe de R
  data_json <- fromJSON(content(response, "text", encoding = "UTF-8"))
  
  # Extraer la vista 'view_ind_real_tes' 
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
      
      # Guardar como CSV
      write.csv(df_desempleo, "datos/tasa_desempleo_ecuador.csv", row.names = FALSE)
      cat("Datos guardados en datos/tasa_desempleo_ecuador.csv\n")
      
      # Crear archivo con la fecha de actualización
      writeLines(paste0("Última actualización: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S")), 
                 "datos/ultima_actualizacion.txt")
      
    } else {
      cat("No se encontraron datos de tasa de desempleo nacional.\n")
      quit(status = 1)
    }
  } else {
    cat("No se encontró la vista 'view_ind_real_tes' en los datos JSON.\n")
    quit(status = 1)
  }
} else {
  cat("Error al descargar los datos. Código de estado:", status_code(response), "\n")
  quit(status = 1)
}