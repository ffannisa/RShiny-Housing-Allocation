library(shiny)

ui <- fluidPage(
  tags$head(
    tags$meta(charset = "utf-8"),
    tags$title("Housing Hustlers!"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    tags$meta(property = "og:title", content = "Grid Garden"),
    tags$meta(property = "og:description", content = "A game for learning CSS grid layout"),
    tags$meta(property = "og:image", content = "https://cssgridgarden.com/images/screenshot.png"),
    tags$meta(name = "twitter:title", content = "Housing Hustlers!"),
    tags$meta(name = "twitter:image", content = "https://cssgridgarden.com/images/screenshot.png"),
    tags$link(rel = "stylesheet", href = "animate.min.css"),
    tags$link(href = "https://fonts.googleapis.com/css?family=PT+Sans|Autour+One|Source+Code+Pro", rel = "stylesheet", type = "text/css"),
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  # Main UI content here
  # In this case, the app only contains the existing HTML code without changes
  tags$section(
    id = "sidebar",
    tags$div(
      class = "header",
      tags$div(
        tags$h1(class = "title", "Grid Garden")
      )
    )
  ),
  tags$section(
    id = "view",
    tags$div(
      id = "board",
      tags$div(
        id = "overlay",
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot")
      ),
      tags$div(id = "plants"),
      tags$div(id = "garden"),
      tags$div(
        id = "soil",
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot"),
        tags$span(class = "plot")
      )
    )
  )
)

server <- function(input, output) {
  # No server logic needed for this app
}

shinyApp(ui, server)
