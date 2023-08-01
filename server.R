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
  
  
  
  # define stored values !!! THIS DATA IS PLACEHOLDER FOR TESTING
  values<-reactiveValues(username=NULL,
                         current_statistics=data.frame(year=c(1),happiness=c(1),budget=c(1000),population=c(10),homelessness=c(0),employment=c(0)),
                         land_use=data.frame(grid_number=c(1:25),type=rep("empty",25),remaining_lease=rep(-1,25)),
                         building_cost=2000)
  
  # UI functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  # Show passwordModal
  observeEvent(input$register, {
    showModal(passwordModal(failed=FALSE))
  })
  
  # Show loginModal
  observeEvent(input$login, {
    showModal(loginModal(failed=FALSE))
  })
  
  
  get_emoji <- function(happy_idx) {
    print(happy_idx)
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




