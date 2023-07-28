library(shiny)

ui <- fluidPage(
  includeCSS("https://fonts.googleapis.com/css?family=PT+Sans|Autour+One|Source+Code+Pro"),
  includeCSS("css/Game_style.css"),
  
  tags$section(id = "sidebar",
               tags$div(class = "header",
                        tags$div(tags$h1("Housing Hustlers!", class = "title"))
               )
  ),
  
  tags$section(id = "view",
               tags$div(id = "board",
                        tags$div(id = "overlay", class = "grid-container",
                                 lapply(1:25, function(i) {
                                   tags$span(class = "plot")
                                 })
                        ),
                        tags$div(id = "plants"),
                        tags$div(id = "garden", class = "grid-container"),
                        tags$div(id = "soil", class = "grid-container",
                                 lapply(1:25, function(i) {
                                   tags$span(class = "plot")
                                 })
                        )
               )
  )
)

server <- function(input, output) {
  # Add any server-side functionality here if needed
}

shinyApp(ui, server)
