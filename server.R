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


# Define server logic required to draw a histogram
function(input, output, session) {
  values<-reactiveValues(username=NULL,current_statistics=NULL,land_use=NULL)
  
  
  #USE CASE 1 USER REGISTRATION
  observeEvent(input$registerButton,{
    username<-input$registerUsername
    # check with aayush whether a blank is "" or NULL
    if (input$registerUsername==""){
      output$registerError<-"Empty username!"
    } else if (input$registerUsername==""){
      output$registerError<-"Empty password!"
    }else if (input$registerPassword!=input$registerPasswordConfirmation){
      output$registerError<-"Password Confirmation Does not match Password."
    } else {
      username<-stripSQLKeywords(username)
      password<-stripSQLKeywords(password)
      if (!checkExistingUsername(username)){
        output$registerError<-"This username already exists. Choose another username"  
      } else{
        response<-createUser(username,password)
        if (response!="success"){
          output$registerError<-paste0("Strange SQL error\n",response)
        }else{
          values$username<-username
          # insert function to change to game screen with default game data
        }
      }
    }
  })
  
  #USE CASE 2 LOGIN
  observeEvent(input$loginButton, {
    if (input$registerUsername==""){
      output$registerError<-"Empty username!"
    } else if (input$registerUsername==""){
      output$registerError<-"Empty password!"
    } else{
      username<-stripSQLKeywords(username)
      password<-stripSQLKeywords(password)
      response<-login(username,password)
      if (response!="success"){
        output$registerError<-paste0("Strange SQL error\n",response)
      }else{
        values$username<-username
        values$current_statistics<-findLatestStatistics(values$username)
        values$land_use<-findLandUse(values$username)
        # insert function to change to game screen
      }
    }
  })  
}
