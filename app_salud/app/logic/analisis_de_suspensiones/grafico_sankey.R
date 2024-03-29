# app/logic/analisis_de_suspensiones/grafico_sankey.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  echarts4r,
  stats
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    echarts4r$echarts4rOutput(ns("grafico_sankey"))
    
  )
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_sankey<- echarts4r$renderEcharts4r({ 
      
     
      sankey <- data.frame(
        source = c("Suspensiones",
                   "Suspensiones",
                   "Suspensiones",
                   "Suspensiones",
                   "Suspensiones",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Paciente",
                   "Equipo Quirurgico",
                   "Equipo Quirurgico",
                   "Equipo Quirurgico",
                   "Equipo Quirurgico",
                   "Administrativo",
                   "Administrativo",
                   "Administrativo",
                   "Administrativo",
                   "Unidades de apoyo clínico",
                   "Unidades de apoyo clínico",
                   "Unidades de apoyo clínico",
                   "Unidades de apoyo clínico",
                   "Unidades de apoyo clínico",
                   "Emergencias"),
        target = c("Paciente",
                   "Equipo Quirurgico",
                   "Administrativo",
                   "Unidades de apoyo clínico",
                   "Emergencias",
                   "Patología aguda",
                   "No se presenta",
                   "Sin suspensión de anticoagulante y otras drogas proscritas",
                   "Rechaza Cirugía",
                   "Patología crónica descompensada",
                   "Sin indicación quirúrgica",
                   "Anticipación de círugia por agudización de patología",
                   "Estudio incompleto",
                   "Falta de ayuno",
                   "Falta de preparación de piel, intestinal, antibiótica u otra específica",
                   "Exámenes alterados no corregidos",
                   "Patología no informada, no conocida (alergia al látex)",
                   "Paciente fallece",
                   "No se ubica",
                   "Descompensación en pabellón",
                   "Descompensación en pabellón",
                   "Prolongación de tabla",
                   "Falta / Disponibilidad de cirujano",
                   "Falta / Disponibilidad de Técnico Paramédico",
                   "Falta / Disponibilidad de Anestesiólogo",
                   "Falta disponibilidad de cama UPC",
                   "Error de programación",
                   "Reemplazo por urgencia",
                   "Documentación incompleta",
                   "Falta de insumos / stock insuficiente",
                   "Instrumental incompleto o no disponible",
                   "Equipamiento no operativo",
                   "Falla coordinación unidad de imagenología",
                   "Falta medicamentos / stock insuficiente",
                   "Emergencia sanitaria COVID-19: Resguardo de usuarios y personal de salud"
        ),
        value = c(279,140,65,42,53,62,
                  56,18,22,16,19,13,20,18,9,11,7,4,2,1,1,
                  89,28,18,5,
                  24,32,7,2,
                  20,11,8,2,1,53),
        stringsAsFactors = TRUE)
      
      sankey |> 
        echarts4r::e_charts() |> 
        echarts4r::e_sankey(source, target, value,layoutIterations = 6) |> 
        echarts4r::e_title("Sankey chart") |>
        echarts4r::e_dims(height = "700px", width = "auto") |>
        echarts4r::e_theme("walden")|> 
        echarts4r::e_tooltip() 

      
      
      
    })
    
    
    
  })
}