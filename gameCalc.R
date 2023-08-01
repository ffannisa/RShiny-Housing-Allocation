source("databaseFunctions.R")

gameCalc<-function(input,output,session,values){
  #USE CASE 1 USER REGISTRATION
  observeEvent(input$registerButton,{
    registerError<-NULL
    # check with aayush whether a blank is "" or NULL
    if (input$registerUsername==""){
      registerError<-"Empty username!"
    } else if (input$registerUsername==""){
      registerError<-"Empty password!"
    }else if (input$registerPassword!=input$registerPasswordConfirmation){
      registerError<-"Password Confirmation Does not match Password."
    } else {
      username<-stripSQLKeywords(input$registerUsername)
      password<-stripSQLKeywords(input$registerPassword)
      if (checkExistingUsername(username)){
        registerError<-"This username already exists. Choose another username"
      } else{
        response<-createUser(username,password)
        if (response!="success"){
          registerError<-paste0("Strange SQL error\n",response)
        }else{
          values$username<-username
          # insert function to change to game screen with default game data
          removeModal()
        }
      }
    }
    print(values$username)
    print(registerError)
    if(!(is.null(registerError))){
      passwordModal(failed=TRUE)
    }
  })
  
  #USE CASE 2 LOGIN
  observeEvent(input$loginButton, {
    loginError<-NULL
    if (input$loginUsername==""){
      loginError<-renderUI("Empty username!")
    } else if (input$loginUsername==""){
      loginError<-renderUI("Empty password!")
    } else{
      username<-stripSQLKeywords(input$loginUsername)
      password<-stripSQLKeywords(input$loginPassword)
      response<-login(username,password)
      if (response!="success"){
        loginError<-renderUI(paste0("Strange SQL error\n",response))
      }else{
        values$username<-username
        values$current_statistics<-findLatestStatistics(values$username)
        values$land_use<-findLandUse(values$username)
        # insert function to change to game screen
        removeModal()
      }
    }
    print(values$username)
    print(loginError)
    if(!(is.null(loginError))){
      passwordModal(failed=TRUE)
    }
  })
}


