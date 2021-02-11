
library(foreign)
library(readr)
library(here)

ruta <- here::here()

setwd(ruta)
veredas <- read.dbf("datos_originales/CRVeredas_2017.dbf")

codificacion <- function(x){
    if(class(x) == "factor"){
        x <- as.character(x)
        Encoding(x) <- "UTF-8"
    }
    if(class(x) == "character"){
        Encoding(x) <- "UTF-8"
    }
    return(x)  
}

veredas$NOMBRE_VER <- gsub("\r\n", "", veredas$NOMBRE_VER)
veredas$NOMBRE_VER <- gsub("\u008dO", "O", veredas$NOMBRE_VER)
veredas$NOMBRE_VER <- gsub("\u0081", "", veredas$NOMBRE_VER)
veredas$NOMBRE_VER <- gsub("Ã\u008dÂ", "", veredas$NOMBRE_VER)
veredas$NOMBRE_VER <- gsub("RO SECO", "RIO SECO", veredas$NOMBRE_VER)
veredas$NOMBRE_VER <- gsub("RO ARRIBA", "RIO ARRIBA", veredas$NOMBRE_VER)

veredas$NOMBRE_VER <- gsub("RÃO NECOCLÃ\u008d", "RÍO NECOCLÍ", veredas$NOMBRE_VER)
veredas$NOMBRE_VER <- gsub("RESGUARDO INDÃ\u008dGENA DE PAYÃN",
                           "RESGUARDO INDÍGENA DE PAYÃN", veredas$NOMBRE_VER)





veredas <- as.data.frame(lapply(veredas, codificacion))
setwd(ruta)
veredas <- veredas[c("OBJECTID","COD_DPTO", "DPTOMPIO", "CODIGO_VER", "NOM_DEP", "NOMB_MPIO", 
                     "NOMBRE_VER", "VIGENCIA", "AREA_HA")]

#dup <- veredas[duplicated(veredas$CODIGO_VER) | duplicated(veredas$CODIGO_VER, fromLast = T),]

veredas <- veredas %>% group_by(CODIGO_VER) %>% summarise(COD_DPTO = max(COD_DPTO),
           DPTOMPIO = max(DPTOMPIO), NOM_DEP  = max(NOM_DEP), NOMB_MPIO  = max(NOMB_MPIO),
           NOMBRE_VER = max(NOMBRE_VER), VIGENCIA = max(VIGENCIA), AREA_HA = sum(AREA_HA))


saveRDS(veredas, "datos/veredas.rds")
write_csv(veredas, "datos/veredas.csv" )

