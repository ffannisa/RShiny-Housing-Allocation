gameCalc<-function(input,output,session){
  #USE CASE 1 USER REGISTRATION
  observeEvent(input$registerButton,{
    # check with aayush whether a blank is "" or NULL
    if (input$registerUsername==""){
      output$registerError<-"Empty username!"
    } else if (input$registerUsername==""){
      output$registerError<-"Empty password!"
    }else if (input$registerPassword!=input$registerPasswordConfirmation){
      output$registerError<-"Password Confirmation Does not match Password."
    } else {
      username<-stripSQLKeywords(input$registerButton)
      password<-stripSQLKeywords(input$registerPassword)
      if (checkExistingUsername(username)){
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
    if (input$loginUsername==""){
      output$loginError<-"Empty username!"
    } else if (input$loginUsername==""){
      output$loginError<-"Empty password!"
    } else{
      username<-stripSQLKeywords(input$loginUsername)
      password<-stripSQLKeywords(input$loginPassword)
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