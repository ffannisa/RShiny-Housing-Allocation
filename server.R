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
  
  
  
  # define stored values
  values<-reactiveValues(username=NULL,current_statistics=NULL,land_use=NULL)
  
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




