# app/main.R

box::use(
  app/logic/utilizacion_de_quirofanos/grafico,
  app/logic/utilizacion_de_quirofanos/tabla,
  app/logic/tiempo_cirugía,
  app/logic/carga_imagen,
  app/logic/analisis_de_suspensiones/grafico_barra,
  app/logic/analisis_de_suspensiones/grafico_sankey,
  app/logic/Tiempo_extra/grafico_tiempoExtra,
  app/logic/Tiempo_extra/grafico_horizontal,
  app/logic/Tiempo_extra/grafico_circular,
  app/logic/Tiempo_extra/grafico_circular2)

box::use(
  htmltools,
  bs4Dash,
  timevis,
  reactable,
  shiny[moduleServer, NS, fluidRow, icon, h1,h2,tags,observeEvent,renderPrint,actionButton,tagList,img],
  shiny,
  bs4Dash[
    dashboardPage,
    dashboardHeader, dashboardBody, dashboardSidebar,
    sidebarMenu, menuItem,box,tabItem,tabItems,valueBox,dropdownMenu,messageItem,notificationItem,taskItem],
  utils,
  dplyr,
  config,
  polished,
  shinyWidgets,
  shinycssloaders,
  echarts4r)



#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(title = "Sistema de gestion HBV",rightUi = dropdownMenu(
      badgeStatus = "danger",
      type = "messages",
      messageItem(
        inputId = "triggerAction1",
        message = "Mensaje 1",
        from = "Juan Venegas",
        image = "https://adminlte.io/themes/v3/dist/img/user3-128x128.jpg",
        time = "Hoy",
        color = "lime"
      )
    ),leftUi = tagList(
      dropdownMenu(
        badgeStatus = "info",
        type = "notifications",
        notificationItem(
          inputId = "triggerAction2",
          text = "Error!",
          status = "danger"
        )
      ),
      dropdownMenu(
        badgeStatus = "info",
        type = "tasks",
        taskItem(
          inputId = "triggerAction3",
          text = "My progreso",
          color = "orange",
          value = 10
        )
      ))),
    dashboardSidebar(side = "top", visible = FALSE, status = "teal",
                     sidebarMenu(
                       id = "sidebar",
                       menuItem("Inicio",tabName = "menu1",
                                icon=icon("laptop-medical"),
                                selected = TRUE),
                       # menuItem("Horario pabellones",tabName = "menu2",
                       #          icon=icon("eye")),
                       # menuItem("Verificación de horario",tabName="menu3",
                       #          icon=icon("hospital")),
                       # menuItem("Estadisticas operaciones",tabName="menu5",
                       #           icon=icon("notes-medical"),
                       bs4Dash::menuItem("Reporte quirófanos",tabName="menu5_1",
                                         icon=icon("check-square")), 
                       bs4Dash::menuItem("Tiempo real vs programado",tabName="menu5_2",
                                         icon=icon("chart-line")),
                       bs4Dash::menuItem("Duración cirugías",tabName="menu5_3",
                                         icon=icon("user-doctor")),
                    bs4Dash::menuItem("Análisis suspenciones",tabName="menu5_4",
                                         icon=icon("user-doctor"))),
                     actionButton(
                       "sign_out",
                       "Sign Out",
                       icon = icon("sign-out-alt"),
                       class = "pull-right",selected = FALSE)
                     
                     
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "menu1",
                fluidRow(width=12, carga_imagen$ui(ns("myImage"))),
                # Boxes need to be put in a row (or column)
                fluidRow(width=12,
                         bs4Dash::infoBox(bs4Dash::bs4Ribbon(text = "Nuevo",color = "lightblue"),width = 6,title = shiny::h3("Reporte quirófanos", style = 'font-size:30px'),subtitle="Este menú contiene estadísticas de ocupación de quirófanos", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_1",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2),
                         bs4Dash::infoBox(bs4Dash::bs4Ribbon(text = "Nuevo",color = "lightblue"),width = 6,title = shiny::h3("Análisis tiempo real vs programado", style = 'font-size:30px'),subtitle="Datos acerca de las cirugías que exceden el tiempo programdo", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_2",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2)),
                fluidRow(width=12,
                         bs4Dash::infoBox(width = 6,title = shiny::h3("Duración cirugías", style = 'font-size:30px'),subtitle="Datos históricos de la duración de distintos tipos de cirugías", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_3",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2),
                         bs4Dash::infoBox(width = 6,title = shiny::h3("Análisis suspenciones", style = 'font-size:30px'),subtitle="Se presentan datos acerca de las causas de suspención de cirugías", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_4",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2))
        ), 
        
        
        # tabItem(tabName = "menu2",
        #         fluidRow(width=12,valueBox(width = 3,value=h2(5),color = "lightblue",subtitle="Pabellones disponibles",icon = icon("check")),
        #                           valueBox(width = 3,value=h2(7),color = "secondary",subtitle="Especialidades disponibles",icon = icon("check")),
        #                           valueBox(width = 3,value=h2(30),color = "success",subtitle="dias disponibles",icon = icon("check")),
        #                           valueBox(width = 3,value=h2(335),color = "warning",subtitle="dias no disponibles",icon = icon("check"))),
        # 
        #         fluidRow(width=12,box(width = 12,title = shiny::h3("Mapa de calor agenda pabellones"),closable = FALSE,elevation = 2, mapa_de_calor$ui(ns("calendarmap")),
        #                               status = "lightblue",headerBorder = FALSE,collapsible = FALSE,height = "300")),
        #     
        #         fluidRow(width=12,box(width = 12,title = shiny::h3("Calendario"),closable = FALSE,elevation = 2, calendario_semanal$ui(ns("calendario")),
        # 
        #                               status = "info",headerBorder = FALSE,collapsible = FALSE))
        #         
        #         ),
        
        # tabItem(tabName = "menu3",
        #         fluidRow(width=12,timeline$ui(ns("linea_de_tiempo"))),
        #         fluidRow(width=12,box(width=12,title="Linea de tiempo",height = "300",
        #                               status = "lightblue",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
        #         ),
        
        tabItem(tabName = "menu5_1",
                
                fluidRow(width=12,
                         box(width = 9,title = "Utilización de quirófanos",closable = FALSE,elevation = 2, grafico$ui(ns("grafico")),
                             status = "lightblue",headerBorder = FALSE,collapsible = FALSE),
                         
                         bs4Dash:: column(width = 3,
                                          valueBox(width = 12,subtitle = "Promedio porcentaje de ocupación quirófanos",value = shiny::h3("60%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas programadas respecto a las habilitadas",value = shiny::h3("79%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas ocupadas respecto a las programadas",value = shiny::h3("80%", style = 'font-size:27px'),color = "teal",icon = icon("check"))),
                         
                         
                         box(width = 12,title = "Utilización de quirófanos",closable = FALSE,elevation = 2, tabla$ui(ns("tabla")),
                             status = "lightblue",headerBorder = FALSE,collapsible = FALSE)
                )),
        
        tabItem(tabName = "menu5_2",
                
                fluidRow(width=12,
                                          valueBox(width = 6,subtitle = "Total horas adicionales último año",value = shiny::h3("2553", style = 'font-size:27px'),color = "lightblue",icon = icon("check")),
                                          valueBox(width = 6,subtitle = "Total horas de inactividad último año",value = shiny::h3("2817", style = 'font-size:27px'),color = "teal",icon = icon("check"))
                         ),
                         
                fluidRow(width=12,
                         box(width = 9,title = "Tiempo total adicional y de inactividad", closable = FALSE,elevation = 2, grafico_tiempoExtra$ui(ns("grafico_extra")),
                             status = "lightblue",headerBorder = FALSE,collapsible = FALSE),
                         
                         box(width = 3,title = "% de tiempo adicional por cirugía", closable = FALSE,elevation = 2, grafico_circular$ui(ns("grafico_circular")),
                                              status = "lightblue",headerBorder = FALSE,collapsible = FALSE)
                         ),
                
                fluidRow(width=12,
                         box(width = 9,title = "Tiempo adicional y tiempo de inactividad promedio por cirugía", closable = FALSE,elevation = 2, grafico_horizontal$ui(ns("grafico_horizontal")),
                             status = "lightblue",headerBorder = FALSE,collapsible = FALSE),
                         box(width = 3,title = "% de tiempo de inactividad por cirugía", closable = FALSE,elevation = 2, grafico_circular2$ui(ns("grafico_circular2")),
                             status = "teal",headerBorder = FALSE,collapsible = FALSE)
                         ),
        ),
        
        
        tabItem(tabName = "menu5_3",
                
                fluidRow(width=12,
                         box(width = 9,title = "Tiempos históricos de cirugía",closable = FALSE,elevation = 2, tiempo_cirugía$ui(ns("histograma")),
                             status = "lightblue",headerBorder = FALSE,collapsible = FALSE),
                         bs4Dash::column(width = 3,
                                         valueBox(width = 12,subtitle = "Media",value = shiny::h3("160 Minutos", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                         valueBox(width = 12,subtitle = "Desviación estándar",value = shiny::h3("22 Minutos", style = 'font-size:27px'),color = "teal",icon = icon("check")))
                )),
        
        tabItem(tabName = "menu5_4",
                fluidRow(width=12,
                         box(grafico_barra$ui(ns("grafico_barra")),width=9,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,status = "lightblue"),
                         bs4Dash::column(width=3,
                                         valueBox(width = 12,value = shiny::h3("42%", style = 'font-size:27px'),color = "teal",subtitle="Suspenciones debido a la causal paciente",
                                                  icon = icon("check")),valueBox(width = 12,value=shiny::h3("23%", style = 'font-size:27px'),color = "teal",subtitle="Suspenciones debido a la causal equipo quirúrgico",icon = icon("check")))),
                fluidRow(width=12,
                         box(grafico_sankey$ui(ns("grafico_sankey")),width=12,height="700px",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue")),
                fluidRow(width=12,
                         box(width=6,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                         box(width=6,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
                
        )
        
        
        
      )
      
    ))
  
  
}

polished::secure_ui(ui)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    #timeline$server("linea_de_tiempo")
    #tabla_profesionales$server("tabla_prof")
    #mapa_de_calor$server("calendarmap")
    #calendario_semanal$server("calendario")
    
    # Utilizacion de quirofanos
    grafico$server("grafico")
    tabla$server("tabla")
    
    # Analisis de suspensiones
    grafico_barra$server("grafico_barra")
    grafico_sankey$server("grafico_sankey")
    
    tiempo_cirugía$server("histograma")
    carga_imagen$server("myImage")
    grafico_tiempoExtra$server("grafico_extra")
    grafico_horizontal$server("grafico_horizontal")
    grafico_circular$server("grafico_circular")
    grafico_circular2$server("grafico_circular2")

    
    shinyWidgets::show_toast(
      title = "Sistema de gestion HBV",
      text = "Este dashboard es solo una version de prueba",
      type = "info",
      position = "top",
      timer=2000,
      width = "800"
    )
    
 
    
  })
  
  
}
polished::secure_server(server)