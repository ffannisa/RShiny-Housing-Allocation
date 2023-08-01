library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinyWidgets)
library(shinyjs)

ui <- fluidPage(
  # Add font and Game design template to use -> Nes.css
  # Link the external CSS file and fonts
  tags$head(
    tags$link(href = "https://unpkg.com/nes.css@2.3.0/css/nes.min.css", rel = "stylesheet"),
    tags$link(href = "https://fonts.googleapis.com/css?family=Press+Start+2P", rel = "stylesheet")
  ),
  
  # Center the game title "Housing Hustlers" with spacing
  tags$div(class = "title",
           style = "text-align: center; margin-top: 30px;",
           tags$h1("Housing Hustlers!", class = "nes-text is-error")
  ),
  
  # Link external CSS files -> reference: Grid garden game
  includeCSS("css/Game_style.css"),
  
  # Add tabsetPanel to create tabs
  tabsetPanel(
    type = "tabs",
    # Add the Game interface tab
    tabPanel("Game Play",
             fluidPage(
               fillPage = TRUE,
               br(),
               # 1st fluid row for value boxes
               fluidRow(
                 # Value Box 1
                 column(width = 3, 
                        div(outputId = "box_1", class = "custom-value-box1",
                            tags$div(class = "value-box-value", "5"),
                            tags$div(class = "value-box-title", "Budget")
                        )
                 ),
                 
                 # Value Box 2
                 column(width = 3,
                        div(outputId = "box_2", class = "custom-value-box2",
                            tags$div(class = "value-box-value", "10"),
                            tags$div(class = "value-box-title", "Unemployed")
                        )
                 ),
                 
                 # Value Box 3
                 column(width = 3,
                        div(outputId = "box_3", class = "custom-value-box3",
                            tags$div(class = "value-box-value", "15"),
                            tags$div(class = "value-box-title", "Homeless")
                        )
                 ),
                 
                 # Value Box 4
                 column(width = 3,
                        div(outputId = "box_4", class = "custom-value-box4",
                            tags$div(class = "value-box-value", "20"),
                            tags$div(class = "value-box-title", "Population")
                        )
                 )
               ),
               br(),
               hr(),
               fluidRow(
                 # 1st column for the game grid and 2nd column for the knob slider
                 column(width = 7,
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
                 ),
                 br(),
                 br(),
                 br(),
                 column(width = 5,
                        # Value Box 5 (Happiness)
                        div(outputId = "box_5", class = "custom-value-box5",
                            tags$div(class = "value-box-value", "20"),
                            tags$div(class = "value-box-title", "Happiness")
                        ),
                        br(),
                        br(),
                        # Demolish button and other elements
                        wellPanel(
                          verticalLayout(
                            fluidRow(
                              br(),
                              br(),
                              column(5, strong()),
                              br(),
                              column(7, actionButton("demolish", label = "Demolish!", class = "nes-btn is-error"))
                            ),
                            hr(style = "border: 0.5px double #141f80;"),
                            fluidRow(
                              column(5, strong('Year')), 
                              br(),
                              column(12, sliderInput(inputId = "", label = NULL, min = 0, max = 10, value = 5, step = 5)),
                              br(),
                              column(7, actionButton("progress", label = "Progress!", class = "nes-btn is-warning"))
                            )
                          )
                        )  
                 )
               ),
               br(),
               br(),
               # Additional horizontal sidebar at the bottom
               fluidRow(
                 column(12,
                        wellPanel(
                          verticalLayout(
                            fluidRow(
                              column(2, strong('Additional Content 1')), 
                              column(2, strong('Additional Content 2')),
                              column(2, strong('Additional Content 3')),
                              column(2, strong('Additional Content 4')),
                              column(2, strong('Additional Content 5')),
                              column(2, actionButton("build", label = "Build!", class = "nes-btn is-success")),
                            )
                          )
                        )
                 )
               )
             )
    ),

    # Add the Statistics tab
    tabPanel("Show Statistics!",
             fluidRow(
               br(),
               # 1st fluid row for value boxes
               fluidRow(
                 # Value Box 1
                 column(width = 3,
                        div(outputId = "box_1", class = "custom-value-box1",
                            tags$div(class = "value-box-value", "5"),
                            tags$div(class = "value-box-title", "Budget")
                        )
                 ),
                 
                 # Value Box 2
                 column(width = 3,
                        div(outputId = "box_2", class = "custom-value-box2",
                            tags$div(class = "value-box-value", "10"),
                            tags$div(class = "value-box-title", "Unemployed")
                        )
                 ),
                 
                 # Value Box 3
                 column(width = 3,
                        div(outputId = "box_3", class = "custom-value-box3",
                            tags$div(class = "value-box-value", "15"),
                            tags$div(class = "value-box-title", "Homeless")
                        )
                 ),
                 
                 # Value Box 4
                 column(width = 3,
                        div(outputId = "box_4", class = "custom-value-box4",
                            tags$div(class = "value-box-value", "20"),
                            tags$div(class = "value-box-title", "Population")
                        )
                 )
               ),
               br(),
               hr(),
               
               # 2nd fluid row for map and plots
               fluidRow(
                 # 1st column for map
                 column(6, style = 'border: 1px solid lightgrey; border-radius: 25px; background-color: #FFFFFF;',
                        br(),
                        # ntitle and info button
                        div(HTML('<b>Homelesness Graph</b> '), style = 'display: inline-block;'),
                        uiOutput('sales_map_button', style = 'display: inline-block;'),
                        br(), br(),
                        # map plot
                        plotOutput('sales_map'),
                        br(), br(), br()
                 ),
                 
                 # 2nd column for plots
                 column(6, 
                        # fluidRow for sales trend
                        fluidRow(style = 'border: 1px solid lightgrey; border-radius: 25px; margin-left: 10px; padding-left: 10px; background-color: #FFFFFF;',
                                 br(),
                                 # sales trend title and info button
                                 div(HTML('<b>Unemployment Graph</b> '), style = 'display: inline-block;'),
                                 uiOutput('sales_trend_button', style = 'display: inline-block;'),
                                 br(), br(),
                                 # trend plot
                                 plotOutput('trend_plot', height = '175px')
                        ),
                        br(),
                        # fluidRow for bar plot
                        fluidRow(style = 'border: 1px solid lightgrey; border-radius: 25px; margin-left: 10px; padding-left: 10px; background-color: #FFFFFF;',
                                 br(),
                                 # bar plot title and info button
                                 div(HTML('<b>Happiness Index</b> '), style = 'display: inline-block;'),
                                 uiOutput('bar_plot_button', style = 'display: inline-block;'),
                                 br(), br(),
                                 # bar plot
                                 plotOutput('bar_plot', height = '175px')
                        )
                 )
               )
               
             )
    )
  )
)

server <- function(input, output, session) {
  
  # Add any server-side functionality here if needed
  # Box 1
  output$box_1 <- shinydashboard::renderValueBox({
    valueBox(5, "box1")
  })
  
  # Box 2
  output$box_2 <- renderValueBox({
    valueBox(10, "box2")
  })
  
  # Box 3
  output$box_3 <- renderValueBox({
    valueBox(15, "box3")
  })
  
  # Box 4
  output$box_4 <- renderValueBox({
    valueBox(20, "box4")
  })
  
  # Box 5 : Happinness Index
  output$box_5 <- renderValueBox({
    valueBox(20, "box5")
  })
  
  ### USING TIDYVERSE: MAKE GRAPHS
  # sales map button
  output$sales_map_button <- renderUI({
    actionButton('salesMapButton', NULL, icon = icon('info'), style = 'border-radius: 50%;')
  })
  
  # sales map
  output$sales_map = renderPlot({
    ggplot(mtcars, aes(x = disp, y = mpg)) + geom_point()
  })
  
  # sales trend button
  output$sales_trend_button <- renderUI({
    actionButton('salesTrendButton', NULL, icon = icon('info'), style = 'border-radius: 50%;')
  })
  
  # sales trend plot
  output$trend_plot = renderPlot({
    ggplot(mtcars, aes(x = disp, y = mpg, group = 'cyl')) + geom_line()
  })
  
  # bar plot button
  output$bar_plot_button <- renderUI({
    actionButton('barPlotButton', NULL, icon = icon('info'), style = 'border-radius: 50%;')
  })
  
  # bar plot
  output$bar_plot = renderPlot({
    ggplot(count(mtcars, cyl), aes(x = cyl, y = n)) + geom_bar(stat = 'identity')
  })
}

shinyApp(ui, server)
