# app/logic/Tiempo_extra/grafico_horizontal.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  echarts4r
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    echarts4r$echarts4rOutput(ns("grafico_horizontal"))
    
  )
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_extra<- echarts4r$renderEcharts4r({ 
      xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 7, rowIndex = 167:170, colIndex= 4:5
                      , as.data.frame = TRUE, header = TRUE) |> 
        echarts4r::e_chart(Especialidad) |>
        echarts4r::e_bar(Tiempo.adicional, name = "Tiempo adicional promedio") |>
        echarts4r::e_labels(position = "right") |>
        echarts4r::e_flip_coords() |>
        echarts4r::e_y_axis(splitLine = list(show = FALSE)) |>
        echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
    
      
    })
    
    
    
  })
}