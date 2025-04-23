# Cargar la librería git2r para manejar operaciones Git
if(!require("git2r")) install.packages("git2r")
library(git2r)

# Configurar el directorio del repositorio local
# Reemplaza "ruta/a/tu/repositorio" con la ruta real a tu repositorio local
# Usa la ruta correcta a tu repositorio
repo_path <- "C:/Users/Ordenador/Documents/Git-Hub/Borrador-"  # Sin guión al final

# Abrir el repositorio
repo <- repository(repo_path)

# Crear o actualizar un archivo trigger
trigger_file <- file.path(repo_path, "trigger_update.txt")
writeLines(paste0("Solicitando actualización de datos: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S")), 
           trigger_file)

# Añadir el archivo al staging
add(repo, "trigger_update.txt")

# Crear commit
commit(repo, message = "Trigger GitHub Action para actualizar datos")

# Push al repositorio remoto
# Usar la ruta COMPLETA a las claves SSH
push(repo, credentials = cred_ssh_key(
  publickey = "C:/Users/Ordenador/.ssh/id_rsa.pub",
  privatekey = "C:/Users/Ordenador/.ssh/id_rsa"
))

push(repo, credentials = cred_ssh_key(
  publickey = "C:/Users/Ordenador/.ssh/id_rsa.pub",
  privatekey = "C:/Users/Ordenador/.ssh/id_rsa"
))


cat("Push completado. El GitHub Action debería iniciarse pronto.\n")





library(git2r)

# Asegúrate de usar el path correcto
repo_path <- "C:/Users/Ordenador/Documents/Git-Hub/Borrador-"
repo <- repository(repo_path)  # Esto recarga los datos del repositorio con la URL actual

# Ahora intenta el push
push(repo, credentials = cred_ssh_key(
  publickey = "C:/Users/Ordenador/.ssh/id_rsa.pub",
  privatekey = "C:/Users/Ordenador/.ssh/id_rsa"
))

