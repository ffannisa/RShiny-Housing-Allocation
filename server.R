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
  
  # Game calculation functions  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  source("gameCalc.R")
  gameCalc(input,output,session,values)
  
  
}




