#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("databaseFunctions.R")
source("templates.R")





# Define server logic required to draw a histogram
function(input, output, session) {
  
  source("images.R")
  images<-c(rep(image_empty,25))
  # define stored values !!! THIS DATA IS PLACEHOLDER FOR TESTING
  values<-reactiveValues(username=NULL,
                         current_statistics=data.frame(year=c(1),happiness=c(1),budget=c(1000),population=c(10),homelessness=c(0),employment=c(0)),
                         land_use=data.frame(grid_number=c(1:25),type=rep("empty",25),remaining_lease=rep(-1,25)),
                         building_cost=2000,
                         images=images
                         )
  
  # UI functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  # Output for grid image
  output[["grid1"]]<-renderUI(tags$img(src=values$images[1],ondragover="allowDrop(event)",ondrop="drop(event)", location = 1, width="100",height="100",id=paste0("image",1)))
  output[["grid2"]]<-renderUI(tags$img(src=values$images[2],ondragover="allowDrop(event)",ondrop="drop(event)", location = 2, width="100",height="100",id=paste0("image",2)))
  output[["grid3"]]<-renderUI(tags$img(src=values$images[3],ondragover="allowDrop(event)",ondrop="drop(event)", location = 3, width="100",height="100",id=paste0("image",3)))
  output[["grid4"]]<-renderUI(tags$img(src=values$images[4],ondragover="allowDrop(event)",ondrop="drop(event)", location = 4, width="100",height="100",id=paste0("image",4)))
  output[["grid5"]]<-renderUI(tags$img(src=values$images[5],ondragover="allowDrop(event)",ondrop="drop(event)", location = 5, width="100",height="100",id=paste0("image",5)))
  output[["grid6"]]<-renderUI(tags$img(src=values$images[6],ondragover="allowDrop(event)",ondrop="drop(event)", location = 6, width="100",height="100",id=paste0("image",6)))
  output[["grid7"]]<-renderUI(tags$img(src=values$images[7],ondragover="allowDrop(event)",ondrop="drop(event)", location = 7, width="100",height="100",id=paste0("image",7)))
  output[["grid8"]]<-renderUI(tags$img(src=values$images[8],ondragover="allowDrop(event)",ondrop="drop(event)", location = 8, width="100",height="100",id=paste0("image",8)))
  output[["grid9"]]<-renderUI(tags$img(src=values$images[9],ondragover="allowDrop(event)",ondrop="drop(event)", location = 9, width="100",height="100",id=paste0("image",9)))
  output[["grid10"]]<-renderUI(tags$img(src=values$images[10],ondragover="allowDrop(event)",ondrop="drop(event)", location = 10, width="100",height="100",id=paste0("image",10)))
  output[["grid11"]]<-renderUI(tags$img(src=values$images[11],ondragover="allowDrop(event)",ondrop="drop(event)", location = 11, width="100",height="100",id=paste0("image",11)))
  output[["grid12"]]<-renderUI(tags$img(src=values$images[12],ondragover="allowDrop(event)",ondrop="drop(event)", location = 12, width="100",height="100",id=paste0("image",12)))
  output[["grid13"]]<-renderUI(tags$img(src=values$images[13],ondragover="allowDrop(event)",ondrop="drop(event)", location = 13, width="100",height="100",id=paste0("image",13)))
  output[["grid14"]]<-renderUI(tags$img(src=values$images[14],ondragover="allowDrop(event)",ondrop="drop(event)", location = 14, width="100",height="100",id=paste0("image",14)))
  output[["grid15"]]<-renderUI(tags$img(src=values$images[15],ondragover="allowDrop(event)",ondrop="drop(event)", location = 15, width="100",height="100",id=paste0("image",15)))
  output[["grid16"]]<-renderUI(tags$img(src=values$images[16],ondragover="allowDrop(event)",ondrop="drop(event)", location = 16, width="100",height="100",id=paste0("image",16)))
  output[["grid17"]]<-renderUI(tags$img(src=values$images[17],ondragover="allowDrop(event)",ondrop="drop(event)", location = 17, width="100",height="100",id=paste0("image",17)))
  output[["grid18"]]<-renderUI(tags$img(src=values$images[18],ondragover="allowDrop(event)",ondrop="drop(event)", location = 18, width="100",height="100",id=paste0("image",18)))
  output[["grid19"]]<-renderUI(tags$img(src=values$images[19],ondragover="allowDrop(event)",ondrop="drop(event)", location = 19, width="100",height="100",id=paste0("image",19)))
  output[["grid20"]]<-renderUI(tags$img(src=values$images[20],ondragover="allowDrop(event)",ondrop="drop(event)", location = 20, width="100",height="100",id=paste0("image",20)))
  output[["grid21"]]<-renderUI(tags$img(src=values$images[21],ondragover="allowDrop(event)",ondrop="drop(event)", location = 21, width="100",height="100",id=paste0("image",21)))
  output[["grid22"]]<-renderUI(tags$img(src=values$images[22],ondragover="allowDrop(event)",ondrop="drop(event)", location = 22, width="100",height="100",id=paste0("image",22)))
  output[["grid23"]]<-renderUI(tags$img(src=values$images[23],ondragover="allowDrop(event)",ondrop="drop(event)", location = 23, width="100",height="100",id=paste0("image",23)))
  output[["grid24"]]<-renderUI(tags$img(src=values$images[24],ondragover="allowDrop(event)",ondrop="drop(event)", location = 24, width="100",height="100",id=paste0("image",24)))
  output[["grid25"]]<-renderUI(tags$img(src=values$images[25],ondragover="allowDrop(event)",ondrop="drop(event)", location = 25, width="100",height="100",id=paste0("image",25)))
  
   
  
  # Drag-and-Drop functionality
  observeEvent(input$new_land_use, {
    new_land_use <- input$new_land_use
    print(new_land_use)
  })
  # Show passwordModal
  observeEvent(input$register, {
    showModal(passwordModal(failed=FALSE))
  })
  
  # Show loginModal
  observeEvent(input$login, {
    showModal(loginModal(failed=FALSE))
  })
  
  
  get_emoji <- function(happy_idx) {
    # print(happy_idx)
    if (happy_idx >= 0 && happy_idx <= 25) {
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
  
  # Output the emoji in the UI
  output$emoji_output <- renderText({
    emoji()
  })
  
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
  
  # Box 5 : Happinness Index
  output$box_5 <- renderValueBox({
    valueBox(20, "box5")
  })
  
  ### USING TIDYVERSE: MAKE GRAPHS
  # sales map button
  # Hillman move graphs to gameCalc
  
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
  
  
  
  # Game calculation functions  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  source("gameCalc.R")
  gameCalc(input,output,session,values)
  
    
  
  
}




