library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinyWidgets)
library(shinyjs)

pageButtonUi <- function(id) {
  actionButton(NS(id, "page_change"), label = "Start Game!", class = "nes-btn is-success bottomButton1")
}

fluidPage(
  useShinyjs(),
  tags$head(
    tags$style(
      HTML("
           .navbar { display: none; }
           body { padding-top: 0px; }
           .bottomButton1 {
             position: absolute;
             bottom: 20px;
             width: 100%;
           .bottomButton2 {
             position: absolute;
             bottom: 40px;
             width: 100%;
             font-family: 'Press Start 2P';
           }
      ")
    )
  ),
  navbarPage(
    title = "test",
    id = "pages",
    tabPanel(title = "first page",
             div(style="position:relative; height:100%;",
                 fluidRow(
                   column(width = 12, uiOutput("dynamic_ui")), # Here is the uiOutput
                   column(width = 12,
                          pageButtonUi("page")
                   )
                 )
             )
    ),
    tabPanel(title = "second_page",
             div(style="position:relative; height:100%;",
                 fluidRow(
                   column(width = 12, uiOutput("game_ui")), # uiOutput for game page
                   column(width = 12,
                          actionButton("restart", "Restart!", class = "nes-btn is-warning bottomButton2", style= "width: 30%; font-family: 'Press Start 2P';"),
                          br(),
                          actionButton("back_button", "Back to Login!", class = "nes-btn is-error bottomButton2", style= "width: 100%; font-family: 'Press Start 2P';")
                   )
                 )
             )
    )
  )
)
