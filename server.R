library(shiny)
#install.packages("shinyBS")
library(shinyBS)
source("databaseFunctions.R")
source("templates.R")


pageButtonServer <- function(id, parentSession) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$page_change, {
      updateNavbarPage(session = parentSession,
                       inputId = "pages",
                       selected = "second_page")
    })
  })
}

uiLogin <- fluidPage(
  # Add font and Game design template to use -> Nes.css
  # Link the external CSS file and fonts
  tags$head(
    tags$style(HTML("
            body {
                background: url('www/background1.jpeg') no-repeat center center fixed; 
                -webkit-background-size: cover;
                -moz-background-size: cover;
                -o-background-size: cover;
                background-size: cover;
            }
        ")),
    tags$link(href = "https://unpkg.com/nes.css@2.3.0/css/nes.min.css", rel = "stylesheet"),
    tags$link(href = "https://fonts.googleapis.com/css?family=Press+Start+2P", rel = "stylesheet")
  ),
  
  # Link the external CSS file
  includeCSS("css/Login_style.css"),
  
  # Center the game title "Housing Hustlers" with spacing
  tags$div(
    style = "text-align: center; margin-top: 50px;",
    tags$h1("Housing Hustlers")
  ),
  
  
  
  # Add buttons for Register and Login
  div(class = "btn-align",
      actionButton("register", label = "New Player", class = "nes-btn is-primary"),    
      # Returning Player button
      actionButton("login", label = "Returning Player", class = "nes-btn is-primary")),
  div(# Action button to open modal dialog
    actionButton("show_instructions", "Instructions",  class = "nes-btn is-error")),
  
  # Add some spacing
  tags$br(),
  
  # Add the loggedInAs div and center its content at the bottom
  div(id = "loggedInAsWrapper",
      style = "text-align: center;",
      htmlOutput("loggedInAs")
  ),
  
  # Apply CSS to center the entire page
  style = "display: flex; flex-direction: column; justify-content: space-between; align-items: center; height: 100vh;"
  
)

source("images.R")
#source("building_cost_module.R")

uiGame <- fluidPage(
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
    tabPanel("Game Play",
             fluidPage(
               fillPage = TRUE,
               br(),
               # 1st fluid row for value boxes
               fluidRow(
                 div(# Action button to open modal dialog
                   actionButton("information", "Info",  class = "nes-btn is-normal")),
                 br(),
                 # Value Box 1
                 column(width = 3, 
                        div(outputId = "box_1", class = "custom-value-box1",
                            tags$div(class = "value-box-value", uiOutput("budgetValueGP")),
                            tags$div(class = "value-box-title", "Budget")
                        )
                 ),
                 
                 # Value Box 2
                 column(width = 3,
                        div(outputId = "box_2", class = "custom-value-box2",
                            tags$div(class = "value-box-value", uiOutput("employmentValueGP")),
                            tags$div(class = "value-box-title", "Employment")
                        )
                 ),
                 
                 # Value Box 3
                 column(width = 3,
                        div(outputId = "box_3", class = "custom-value-box3",
                            tags$div(class = "value-box-value", uiOutput("homelessnessValueGP")),
                            tags$div(class = "value-box-title", "Homelessness")
                        )
                 ),
                 
                 # Value Box 4
                 column(width = 3,
                        div(outputId = "box_4", class = "custom-value-box4",
                            tags$div(class = "value-box-value", uiOutput("populationValueGP")),
                            tags$div(class = "value-box-title", "Population")
                        )
                 )
               ),
               br(),
               hr(),
               fluidRow(
                 # 1st column for the game grid and 2nd column for the emoji
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
                              column(5, strong()),
                              br(),
                              column(7, tags$img(id="rubbishbin",src=image_rubbish,ondragover="allowDrop(event)",ondrop="ondropdemolish(event)",height="100px",width="100px"))
                            ),
                            hr(style = "border: 0.5px double #141f80;"),
                            fluidRow(
                              column(5, strong('Year'), textOutput('yearValue')), 
                              br(),
                              br(),
                              br(),
                              column(12, sliderInput(inputId = "time", label = NULL, min = 1, max = 10, value = 1)),
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
                                         tags$div(class = "value-box-value", uiOutput("buildingCostValueGP")),
                                         tags$div(class = "value-box-title", "Building Cost"))),
                              column(2, actionButton("build", label = "Build!", class = "nes-btn is-success")),
                              tags$script('
              function dragStart(event) {event.dataTransfer.setData("Text", ("type:"+event.target.getAttribute("type")));}
              
              function allowDrop(event) {event.preventDefault();}
              
              function drop(event) {
                var dataIn = event.dataTransfer.getData("Text").split(":");
                console.log("dataIn",dataIn);
                if (dataIn[0]=="type"){
                  var image = event.target;
                  var gridnumber = image.getAttribute("location");
                  const result = String(gridnumber) + "," + dataIn[1];
                  console.log(result);
                  Shiny.setInputValue("new_land_use", result);
                  Shiny.setInputValue("demolish_drop",null)
                }
              }
              
              function dragStartDemolish(event){
                event.dataTransfer.setData("Text", ("location:"+event.target.getAttribute("location")));
              }
              function ondropdemolish(event){
                var dataIn=event.dataTransfer.getData("Text").split(":");
                console.log("dataIn",dataIn);
                if (dataIn[0]=="location"){
                  Shiny.setInputValue("demolish_drop",dataIn[1]);
                  Shiny.setInputValue("new_land_use", null);
                }
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
                            tags$div(class = "value-box-value", uiOutput("budgetValueST")),
                            tags$div(class = "value-box-title", "Budget")
                        )
                 ),
                 
                 # Value Box 2
                 column(width = 3,
                        div(outputId = "box_2", class = "custom-value-box2",
                            tags$div(class = "value-box-value", uiOutput("employmentValueST")),
                            tags$div(class = "value-box-title", "Employment")
                        )
                 ),
                 
                 # Value Box 3
                 column(width = 3,
                        div(outputId = "box_3", class = "custom-value-box3",
                            tags$div(class = "value-box-value", uiOutput("homelessnessValueST")),
                            tags$div(class = "value-box-title", "Homelessness")
                        )
                 ),
                 
                 # Value Box 4
                 column(width = 3,
                        div(outputId = "box_4", class = "custom-value-box4",
                            tags$div(class = "value-box-value",  uiOutput("populationValueST")),
                            tags$div(class = "value-box-title", "Population")
                        )
                 )
               ),
               br(),
               hr(),
               
               # 2nd fluid row for map and plots
               fluidRow(
                 # 1st column for map: Population
                 column(6, style = 'border: 1px solid lightgrey; border-radius: 25px; background-color: #FFFFFF;',
                        br(),
                        # ntitle and info button
                        div(HTML('<b>Population Graph</b> '), style = 'display: inline-block;'),
                        uiOutput('population_button', style = 'display: inline-block;'),
                        br(), br(),
                        # map plot
                        plotOutput('population_graph'),
                        br(), br(), br()
                 ),
                 
                 # 2nd column for plots
                 column(6, 
                        # fluidRow for Happiness Index  ##DONE
                        fluidRow(style = 'border: 1px solid lightgrey; border-radius: 25px; margin-left: 10px; padding-left: 10px; background-color: #FFFFFF;',
                                 br(),
                                 # trend title and info button
                                 div(HTML('<b>Happiness index</b> '), style = 'display: inline-block;'),
                                 uiOutput('happy_trend_button', style = 'display: inline-block;'),
                                 br(), br(),
                                 # trend plot
                                 plotOutput('happy_trend_plot', height = '175px')
                        ),
                        br(),
                        # fluidRow for bar plot
                        fluidRow(style = 'border: 1px solid lightgrey; border-radius: 25px; margin-left: 10px; padding-left: 10px; background-color: #FFFFFF;',
                                 br(),
                                 # bar plot title and info button
                                 div(HTML('<b>Budget Bar Plot</b> '), style = 'display: inline-block;'),
                                 uiOutput('budg_plot_button', style = 'display: inline-block;'),
                                 br(), br(),
                                 # bar plot
                                 plotOutput('budg_bar_plot', height = '175px')
                        ),
                        br(),
                        br()
                 )
               )
               
             )
    )
  )
)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  pageButtonServer("page", parentSession = session)
  
  observeEvent(input$back_button, {
    updateNavbarPage(session, "pages", "first page")
  })
  
  output$dynamic_ui <- renderUI({
    req(input$pages)
    if(input$pages == "first page"){
      uiLogin
    }
  })
  
  output$game_ui <- renderUI({
    req(input$pages)
    if(input$pages == "second_page"){
      uiGame
    }
  })
  
  source("images.R")
  images <- c(rep(image_empty, 25))
  
  observeEvent(input$show_instructions, {
    # Show modal dialog when button is clicked
    showModal(modalDialog(
      title = "Instructions",
      # Display image in modal dialog
      div(style = 'overflow-x: scroll', tags$img(src = image_instruction , width=1440, height=540)),
      
      # Dismiss button
      modalButton("Dismiss"),
      
      # CSS to set the width of the modal
      footer = NULL,
      size = "m",
      tags$style(HTML("
    .modal-dialog {
      width: 90%;
    }
  "))
    ))
  })
  
  
  
  # define stored values !!! THIS DATA IS PLACEHOLDER FOR TESTING
  values <- reactiveValues(
    username = NULL,
    current_statistics = data.frame(year = c(1), happiness = c(1), budget = c(10000), population = c(10), homelessness = c(0), employment = c(0)),
    land_use = data.frame(grid_number = c(1:25), type = rep("empty", 25), remaining_lease = rep(-1, 25)),
    building_cost = 25,
    images = images,
    demolish_gridnumber=0,
    demolish_cost=0,
    demolish_time=0
  )
  
  # Render Year Counter
  output$yearValue <- renderText({
    values$current_statistics$year
  })
  
  # Render dynamic budget
  output$budgetValueGP <- renderText({
    values$current_statistics$budget
  })
  
  # Render dynamic employment
  output$employmentValueGP <- renderText({
    values$current_statistics$employment
  })
  
  # Render dynamic homelessness
  output$homelessnessValueGP <- renderText({
    values$current_statistics$homelessness
  })
  
  # Render dynamic population
  output$populationValueGP <- renderText({
    values$current_statistics$population
  })
  
  # Render dynamic building cost value
  output$buildingCostValueGP <- renderText({
    values$building_cost
  })
  
  # Render dynamic budget
  output$budgetValueST <- renderText({
    values$current_statistics$budget
  })
  
  # Render dynamic employment
  output$employmentValueST <- renderText({
    values$current_statistics$employment
  })
  
  # Render dynamic homelessness
  output$homelessnessValueST <- renderText({
    values$current_statistics$homelessness
  })
  
  # Render dynamic population
  output$populationValueST <- renderText({
    values$current_statistics$population
  })
  
  # Render dynamic building cost value
  output$buildingCostValueST <- renderText({
    values$building_cost
  })
  
  # UI functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  get_remaining_lease_text <- function(remaining_lease) {
    if (remaining_lease > 0) {
      return(paste(remaining_lease, "years remaining"))
    } else {
      return("")
    }
  }
  
  # Output for grid image and remaining lease text
  output$grid1 <- renderUI({
    tagList(
      tags$img(src=values$images[1], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 1, width="65",height="65",id=paste0("image",1)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[1]))
    )
  })
  output$grid2 <- renderUI({
    tagList(
      tags$img(src=values$images[2], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 2, width="65",height="65",id=paste0("image",2)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[2]))
    )
  })
  output$grid3 <- renderUI({
    tagList(
      tags$img(src=values$images[3], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 3, width="65",height="65",id=paste0("image",3)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[3]))
    )
  })
  output$grid4 <- renderUI({
    tagList(
      tags$img(src=values$images[4], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 4, width="65",height="65",id=paste0("image",4)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[4]))
    )
  })
  output$grid5 <- renderUI({
    tagList(
      tags$img(src=values$images[5], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 5, width="65",height="65",id=paste0("image",5)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[5]))
    )
  })
  output$grid6 <- renderUI({
    tagList(
      tags$img(src=values$images[6], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 6, width="65",height="65",id=paste0("image",6)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[6]))
    )
  })
  output$grid7 <- renderUI({
    tagList(
      tags$img(src=values$images[7], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 7, width="65",height="65",id=paste0("image",7)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[7]))
    )
  })
  output$grid8 <- renderUI({
    tagList(
      tags$img(src=values$images[8], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 8, width="65",height="65",id=paste0("image",8)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[8]))
    )
  })
  output$grid9 <- renderUI({
    tagList(
      tags$img(src=values$images[9], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 9, width="65",height="65",id=paste0("image",9)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[9]))
    )
  })
  output$grid10 <- renderUI({
    tagList(
      tags$img(src=values$images[10], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 10, width="65",height="65",id=paste0("image",10)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[10]))
    )
  })
  output$grid11 <- renderUI({
    tagList(
      tags$img(src=values$images[11], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 11, width="65",height="65",id=paste0("image",11)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[11]))
    )
  })
  output$grid12 <- renderUI({
    tagList(
      tags$img(src=values$images[12], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 12, width="65",height="65",id=paste0("image",12)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[12]))
    )
  })
  output$grid13 <- renderUI({
    tagList(
      tags$img(src=values$images[13], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 13, width="65",height="65",id=paste0("image",13)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[13]))
    )
  })
  output$grid14 <- renderUI({
    tagList(
      tags$img(src=values$images[14], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 14, width="65",height="65",id=paste0("image",14)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[14]))
    )
  })
  output$grid15 <- renderUI({
    tagList(
      tags$img(src=values$images[15], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 15, width="65",height="65",id=paste0("image",15)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[15]))
    )
  })
  output$grid16 <- renderUI({
    tagList(
      tags$img(src=values$images[16], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 16, width="65",height="65",id=paste0("image",16)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[16]))
    )
  })
  output$grid17 <- renderUI({
    tagList(
      tags$img(src=values$images[17], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 17, width="65",height="65",id=paste0("image",17)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[17]))
    )
  })
  output$grid18 <- renderUI({
    tagList(
      tags$img(src=values$images[18], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 18, width="65",height="65",id=paste0("image",18)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[18]))
    )
  })
  output$grid19 <- renderUI({
    tagList(
      tags$img(src=values$images[19], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 19, width="65",height="65",id=paste0("image",19)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[19]))
    )
  })
  output$grid20 <- renderUI({
    tagList(
      tags$img(src=values$images[20], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 20, width="65",height="65",id=paste0("image",20)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[20]))
    )
  })
  output$grid21 <- renderUI({
    tagList(
      tags$img(src=values$images[21], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 21, width="65",height="65",id=paste0("image",21)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[21]))
    )
  })
  output$grid22 <- renderUI({
    tagList(
      tags$img(src=values$images[22], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 22, width="65",height="65",id=paste0("image",22)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[22]))
    )
  })
  output$grid23 <- renderUI({
    tagList(
      tags$img(src=values$images[23], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 23, width="65",height="65",id=paste0("image",23)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[23]))
    )
  })
  output$grid24 <- renderUI({
    tagList(
      tags$img(src=values$images[24], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 24, width="65",height="65",id=paste0("image",24)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[24]))
    )
  })
  output$grid25 <- renderUI({
    tagList(
      tags$img(src=values$images[25], ondragover="allowDrop(event)", ondrop="drop(event)", ondragstart="dragStartDemolish(event)", location = 25, width="65",height="65",id=paste0("image",25)),
      tags$div(class = "remaining_lease_text", get_remaining_lease_text(values$land_use$remaining_lease[25]))
    )
  })
  
  
  # Show passwordModal
  observeEvent(input$register, {
    showModal(passwordModal())
  })
  
  # Show loginModal
  observeEvent(input$login, {
    showModal(loginModal(failed = FALSE))
  })
  
  # Show leaderboardModal
  observeEvent(input$leaderboard, {
    # rerender leaderboard table
    output$leaderboard_table <- renderTable(sort_leaderboard(sort_by = input$leaderboard_table))
    showModal(leaderboardModal(failed = FALSE))
  })
  
  # Output leaderboard table
  output$leaderboard_table <- renderTable(sort_leaderboard(sort_by = input$leaderboard_table))
  
  get_emoji <- function(happy_idx) {
    print(paste0("Happiness: ",happy_idx))
    if (happy_idx <= 25) {
      return("😡")  # Mad face emoji
    } else if (happy_idx > 25 && happy_idx <= 50) {
      return("😠")  # Upset face emoji
    } else if (happy_idx > 50 && happy_idx <= 75) {
      return("😐")  # Neutral face emoji
    } else if (happy_idx > 75) {
      return("😄")  # Happy face emoji
    } else {
      return("")  # Empty string if happy_idx is outside the defined ranges
    }
  }
  
  emoji <- reactive({
    get_emoji(values$current_statistics$happiness)
  })
  
  observe({
    bsTooltip(id = "emoji_output", 
              title = paste0("Happiness: ", as.character(values$current_statistics$happiness)), 
              placement = "bottom", 
              trigger = "hover")
  })
  
  # Output the emoji in the UI
  output$emoji_output <- renderText({
    emoji()
  })
  
  #### Information Sheet Pop-up
  observeEvent(input$information, {
    # Show modal dialog when button is clicked
    showModal(modalDialog(
      title = "Information",
      # Display multiple pages in modal dialog
      tabsetPanel(
        id = 'information_tabs',
        tabPanel("1", div(style = 'overflow-x: scroll', tags$img(src = image_info1, width=1440, height=540))),
        tabPanel("2", div(style = 'overflow-x: scroll', tags$img(src = image_info2, width=1440, height=540))),
        tabPanel("3", div(style = 'overflow-x: scroll', tags$img(src = image_info3, width=1440, height=540)))
      ),
      
      # Buttons to change pages
      footer = tagList(
        actionButton("previnfo", "Previous"),
        actionButton("nextinfo", "Next"),
        # Dismiss button
        modalButton("Dismiss")
      ),
      easyClose = TRUE,
      
      # CSS to set the width of the modal
      tags$style(HTML("
      .modal-dialog {
        width: 90%;
      }
    "))
    ))
  })
  
  # Observer to manage page change
  observeEvent(input$nextinfo, {
    # Get current tab
    current_tab <- as.numeric(input$information_tabs)
    print(current_tab)
    # If it's not the last tab, go to the next one
    if(current_tab < 3) {
      updateTabsetPanel(session, "information_tabs", selected = as.character(current_tab + 1))
    }
  })
  
  observeEvent(input$previnfo, {
    # Get current tab
    current_tab <- as.numeric(input$information_tabs)
    # If it's not the first tab, go to the previous one
    if(current_tab > 1) {
      updateTabsetPanel(session, "information_tabs", selected = as.character(current_tab - 1))
    }
  })
  ####
  
  # Add any server-side functionality here if needed
  
  # @ hillman calculate these values
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
  
  # Box 5: Budget
  output$box_5 <- renderValueBox({
    # not working
    valueBox(values$current_statistics$happiness, "Budget chart")
  })
  
  ### USING TIDYVERSE: MAKE GRAPHS
  # sales map button
  # Hillman move graphs to gameCalc
  
  output$population_graph_button <- renderUI({
    # BUTTON NOT IMPLEMENTED
    actionButton('populationGraphButton', NULL, icon = icon('info'), style = 'border-radius: 50%;')
  })
  
  observeEvent(input$populationGraphButton,{
    print("POPULATION GRAPH BUTTON NOT IMPLEMENTED")
  })
  
  
  
  
  ##### HAPPINESS GRAPH
  output$happy_trend_button <- renderUI({
    actionButton('happyTrendButton', NULL, icon = icon('info'), style = 'border-radius: 50%;')
  })
  
  
  #####
  
  ##### Budget Bar Plot
  # bar plot button
  output$budg_plot_button <- renderUI({
    actionButton('budgPlotButton', NULL, icon = icon('info'), style = 'border-radius: 50%;')
  })
  
  
  ######
  
  # Game calculation functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  source("gameCalc.R")
  gameCalc(input, output, session, values)
  
  
  
}
