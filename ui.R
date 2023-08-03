library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinyWidgets)
library(shinyjs)

source("images.R")
#source("building_cost_module.R")

fluidPage(
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
    id="tabs",
    # Add the Game interface tab
    tabPanel("Login",
             # Define UI for application that draws a histogram
             fluidPage(
               # Add font and Game design template to use -> Nes.css
               # Link the external CSS file and fonts
               tags$head(
                 tags$link(href = "https://unpkg.com/nes.css@2.3.0/css/nes.min.css", rel = "stylesheet"),
                 tags$link(href = "https://fonts.googleapis.com/css?family=Press+Start+2P", rel = "stylesheet")
               ),
               
               # Link the external CSS file
               includeCSS("css/Login_style.css"),
               
               # Center the game title "Housing Hustlers" with spacing
               # ask FANNISA IF THE NEXT 4 LINES OF CODE IS NEEDED?
               tags$div(
                 style = "text-align: center; margin-top: 50px;",
                 tags$h1("Housing Hustlers")
               ),
               
               # Add buttons for Register and Login
               div(class = "btn-align",
                   actionButton("register", label = "New Player", class = "nes-btn is-primary"),    
                   # Returning Player button
                   actionButton("login", label = "Returning Player", class = "nes-btn is-primary")),
               
               # Add some spacing
               tags$br(),
               tags$br(),
               
               # Add the loggedInAs div and center its content at the bottom
               div(id = "loggedInAsWrapper",
                   style = "text-align: center;",
                   htmlOutput("loggedInAs")
               ),
               
               # Apply CSS to center the entire page
               style = "display: flex; flex-direction: column; justify-content: space-between; align-items: center; height: 100vh;"
               
             )
    ),
    
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
                                                         tags$span(class = "plot",id = paste0("grid", i), location = i,
                                                                   uiOutput(paste0("grid", i)))
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
                 column(width = 5,
                        # Value Box 5 (Happiness) - Replaced with emoji image output
                        # Add a text element to display the emoji based on the value of happy_idx
                        tags$div(
                          style = "font-size: 100px; text-align: center;",
                          textOutput("emoji_output")
                        ),
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
                        # Include the building cost elements here
                        #uiOutput("building_cost_ui")
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
                              column(2, tags$img(id="img",type="hdb_1",draggable="true",ondragstart="dragStart(event)",src=image_hdb1, alt="House 1", width=100, height=100, strong('HDB 1'))), 
                              column(2, tags$img(id="img2",type="hdb_2",draggable="true",ondragstart="dragStart(event)",src=image_hdb2, alt="House 2", width=100, height=100, strong('HDB 2'))),
                              column(2, tags$img(id="img3",type="office",draggable="true",ondragstart="dragStart(event)",src=image_office, alt="Office", width=100, height=100, strong('Office'))),
                              column(2, tags$img(id="img4",type="park",draggable="true",ondragstart="dragStart(event)",src=image_park, alt="Park", width=100, height=100, strong('Park'))),
                              ### Change to dynamic values
                              column(2, 
                                     div(outputId = "box_5", class = "custom-value-box5",
                                         tags$div(class = "value-box-value", uiOutput("buildingCostValue")),
                                         tags$div(class = "value-box-title", "Building Cost"))),
                              column(2, actionButton("build", label = "Build!", class = "nes-btn is-success")),
                              tags$script('
              function dragStart(event) {event.dataTransfer.setData("Text", event.target.getAttribute("type"));}
              
              function allowDrop(event) {event.preventDefault();}
              
              function drop(event) {
                event.preventDefault();
                var type = event.dataTransfer.getData("Text");
                var image = event.target;
                var gridnumber = image.getAttribute("location");
                const result = String(gridnumber) + "," + type;
                console.log(result);
                Shiny.setInputValue("new_land_use", result);
              }
              ')
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
