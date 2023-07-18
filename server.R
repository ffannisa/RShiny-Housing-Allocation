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

checkExistingUsername<- function (username){
  # username: string
  # check if this username is already in use
  # return TRUE or FALSE
}
# Define server logic required to draw a histogram
function(input, output, session) {
  values<-reactiveValues(userInfo=NULL)
  
  
  #function that runs when user wishes to register
  observeEvent(input$registerButton,{
    username<-input$registerUsername
    if (input$registerUsername==""){
      output$registerError<-"Empty username!"
    } else if (input$registerUsername==""){
      output$registerError<-"Empty password!"
    }
    else if (input$registerPassword!=input$registerPasswordConfirmation){
      output$registerError<-"Password Confirmation Does not match Password."
    } else{
      # 
    }
  })
  
}
