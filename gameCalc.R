source("databaseFunctions.R")
source("images.R")


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
          values$current_statistics$username<-username
          # assign default values and do a save
          
          changeTab(session)
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
        values$current_statistics$username<-username
        values$current_statistics<-findLatestStatistics(values$current_statistics$username)
        values$land_use<-findLandUse(values$current_statistics$username)
        changeTab(session)
        removeModal()
      }
    }
    print(values$username)
    print(loginError)
    if(!(is.null(loginError))){
      passwordModal(failed=TRUE)
    }
  })
  
  # receive input from drag and drop
  observeEvent(input$new_land_use,{
    new_land_use<-stringr::str_split(input$new_land_use,",")
    
    grid_number<-as.numeric(new_land_use[[1]][1])
    
    
    if (values$land_use$type[values$land_use$grid_number==(grid_number)]!="empty"){
      dialogBox("There is already something here!")
      return()
    }
    
    type<-paste0("planned ",new_land_use[[1]][2])
    
    if (type=="planned hdb_1"){
      remaining_lease=3
    } else if(type=="planned hdb_2"){
      remaining_lease=5
    } else if(type=="planned office"){
      remaining_lease=1
    }else if(type=="planned park"){
      remaining_lease=2
    } else{
      dialogBox("strange shizzles happening")
      remaining_lease=-1
    }
    values$land_use[values$land_use$grid_number==grid_number,]<-data.frame(grid_number=grid_number,type=type,remaining_lease=remaining_lease)
    gridUpdater()
  })
  
  
  #USE CASE 5 SELECTION CONFIRMATION
  observeEvent(input$build,{
    if(values$current_statistics$budget <values$building_cost){
      showModal(dialogBox("You do not have enough money"))
    }else if(values$current_statistics$budget >=values$building_cost){
      showModal(dialogBox("replace land use with construction at appropriate spots and deduct money"))
      # loop through values$land_use. Replace all to_build objects with the appropriate construction site
      values$current_statistics$budget <- values$current_statistics$budget- values$building_cost
      values$building_cost<-0
      for (i in nrow(values$land_use)){
        if (values$land_use[i,"type"]=="planned hdb_1"){
          values$land_use[i,"type"]<-"construction hdb_1"
          values$land_use[i,"remaining lease"]<-3
        }else if(values$land_use[i,"type"]=="planned hdb_2"){
          values$land_use[i,"type"]<-"construction hdb_2"
          values$land_use[i,"remaining lease"]<-3
        }else if(values$land_use[i,"type"]=="planned office"){
          values$land_use[i,"type"]<-"construction office"
          values$land_use[i,"remaining lease"]<-3
        } else if(values$land_use[i,"type"]=="planned office"){
          values$land_use[i,"type"]<-"construction office"
          values$land_use[i,"remaining lease"]<-3
        }
      }
      gridUpdater()
    }
  })
  
  #USE CASE 6 TIME PROGRESS
  observeEvent(input$progress, {
    progressYears<- input$time
    for (i in 1:progressYears){
      values$current_statistics$year<-values$current_statistics$year+1
      progressBarUpdater()
      # increase values
      values$current_statistics$happiness<-0.7*values$current_statistics$happiness-10*values$current_statistics$homeless+0.5*values$current_statistics$employment+50*sum(values$land_use$type=="office building")
      values$current_statistics$budget<-values$current_statistics$budget-100*values$current_statistics$population+200*values$current_statistics$employment+10000*sum(values$land_use$type=="office building")
      values$current_statistics$population<-values$current_statistics$population+0.1*values$current_statistics$population
      # reduce leases
      values$land_use$remaining_lease<-values$land_use$remaining_lease -1
      # checking if change is needed
      for (i in 1:25){
        if (values$land_use$remaining_lease[i]==0){
          if (values$land_use$type=="hdb_1" | values$land_use$type=="hdb_2" | values$land_use$type=="office" | values$land_use$type=="park"){
            values$land_use$type<-"demolition"
            values$land_use$remaining_lease[i]<-1  
          }else if (values$land_use$type=="demolition"){
            values$land_use$type<-"empty"
          }else if (values$land_use$type=="construction hdb_1"){
            values$land_use$type<-"hdb_1"
            values$land_use$remaining_lease[i]<-99  
          }else if (values$land_use$type=="construction hdb_2"){
            values$land_use$type<-"hdb_2"
            values$land_use$remaining_lease[i]<-99  
          }else if (values$land_use$type=="construction office"){
            values$land_use$type<-"office"
            values$land_use$remaining_lease[i]<-10
          }else if (values$land_use$type=="construction park"){
            values$land_use$type<-"park"
            values$land_use$remaining_lease[i]<-5
          }
        }
        
      }
      # update building related stats
      values$current_statistics$homelessness<-max(0,values$current_statistics$population-(200*sum(values$land_use$type=="hdb_1")+400*sum(values$land_use$type=="hdb_2")))
      values$current_statistics$employment<-min(values$current_statistics$population,50*values$land_use$type=="office building")
      
      # saves
      SaveCurrentLandUse(date.frame(
                                    username=rep(values$username,25),
                                    grid_number=values$land_use[,"grid_number"],
                                    type=values$land_use[,"type"],
                                    remaining_lease=values$land_use[,"remaining_lease"]
                                    ))
      saveGameStatistics(values$username,
                         values$current_statistics$year,
                         values$current_statistics$happiness,
                         values$current_statistics$budget,
                         values$current_statistics$population,
                         values$current_statistics$homelessness,
                         values$current_statistics$employment)
      if (values$current_statistics$happiness<=0 | values$current_statistics$budget<=0){
        break
        goTotGameOver(FALSE)
      }else if(values$current_statistics$year==999){
        break
        goTotGameOver(TRUE)
      }
    }
  })
  
  
  changeTab<- function(session){
    # insert function to change tab
    updateTabsetPanel(session,inputId="tabs",selected="Game Play")
    print(values$current_statistics)
  }
  
  # progressBarUpdater<-function(){
  #   dialogBox("move year progress bar")
  # }
  gridUpdater <- function(){
    # retrieve the values$land_use and update values$images[i]
    for (i in 1:25){
      land_use<-values$land_use$type[i]
      print(land_use)
      if (land_use=="empty"){
        values$images[i]<-image_empty
      }else if(land_use=="planned hdb_1"){
        values$images[i]<-image_planned_hdb1
      }else if(land_use=="planned hdb_2"){
        values$images[i]<-image_planned_hdb2
      }else if(land_use=="planned office"){
        values$images[i]<-image_planned_office
      }else if(land_use=="planned park"){
        values$images[i]<-image_planned_park
      }else if(substr(land_use,1,12)=="construction"){
        values$images[i]<-image_construction
      }else if(land_use=="hdb_1"){
        values$images[i]<-image_hdb1
      }else if(land_use=="hdb_2"){
        values$images[i]<-image_hdb2
      }else if(land_use=="office"){
        values$images[i]<-image_office
      }else if(land_use=="park"){
        values$images[i]<-image_park
      }else{
        stop(paste0("Funky land use alert at row",i))
      }
      
    }
    # print(values$images)
  }
  goTotGameOver<- function(winning){
    
    if (!winning){
      dialogBox("U lost. Also need a game over")
    }else{
      dialogBox("U win. Also need a game over") 
    }
  }
  
  
  
  
  
}

