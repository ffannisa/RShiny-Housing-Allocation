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
          values$username<-username
          # assign default values and do a save
          dialogBox("please be reminded that budget is currently at 9999999999")
          values$current_statistics<-data.frame(year=c(1),happiness=c(50),budget=c(999999),population=c(100),homelessness=c(0),employment=c(0))
          values$land_use<-data.frame(grid_number=c(1:25),type=rep("empty",25),remaining_lease=rep(-1,25))
          print(values$username)
          print(values$current_statistics)
          print(values$land_use)
          a=saveGameStatistics(values$username,values$current_statistics$year,values$current_statistics$happiness,values$current_statistics$budget,values$current_statistics$population,values$current_statistics$homelessness,values$current_statistics$employment)
          print(a)
          b=SaveCurrentLanduse(cbind(username=rep(values$username,25),values$land_use))
          print(b)
          
          changeTab(session)
          removeModal()
        }
      }
    }
    print(values$username)
    print(paste0("error: ",registerError))
    if(!(is.null(registerError))){
      passwordModal(failed=TRUE)
    }
  })
  
  #USE CASE 2 LOGIN
  observeEvent(input$loginButton, {
    loginError<-NULL
    if (input$loginUsername==""){
      loginError<-"Empty username!"
    } else if (input$loginUsername==""){
      loginError<-"Empty password!"
    } else{
      username<-stripSQLKeywords(input$loginUsername)
      password<-stripSQLKeywords(input$loginPassword)
      response<-login(username,password)
      if (response!="success"){
        loginError<-paste0("Strange SQL error\n",response)
      }else{
        values$username<-username
        values$current_statistics<-findLatestStatistics(values$username)
        values$land_use<-findLandUse(values$username)
        changeTab(session)
        removeModal()
      }
    }
    print(values$username)
    print(paste0("Error: ",loginError))
    if(!(is.null(loginError))){
      passwordModal(failed=TRUE)
    }
  })
  
  # receive input from drag and drop
  observeEvent(input$new_land_use,{
    print("new land use received")
    print(input$new_land_use)
    new_land_use<-stringr::str_split(input$new_land_use,",")
    grid_number<-as.numeric(new_land_use[[1]][1])
    if (values$land_use$type[values$land_use$grid_number==(grid_number)]!="empty" & substr(values$land_use$type[values$land_use$grid_number==(grid_number)],1,7)!="planned"){
      dialogBox("There is already something here!")
      
    }else{
      # if planned structure is replaced, remove its cost from building cost
      if(substr(values$land_use$type[values$land_use$grid_number==(grid_number)],1,7)=="planned"){
        print("replacing planned building")
        plannedType=substr(values$land_use$type[values$land_use$grid_number==(grid_number)],9)
        if (plannedType=="hdb_1"){
          values$building_cost<-values$building_cost-10000
        }else if(plannedType=="hdb_2"){
          values$building_cost<-values$building_cost-50000
        } else if(plannedType=="office"){
          values$building_cost<-values$building_cost-500000
        }else if(plannedType=="park"){
          values$building_cost<-values$building_cost-100000
        }else{
          showModal(dialogBox("strange shizzles happening on the planned type side"))
          remaining_lease=-1
        }
      }
      
      type<-paste0("planned ",new_land_use[[1]][2])
      
      if (type=="planned hdb_1"){
        remaining_lease=3
        values$building_cost<-values$building_cost+10000
      } else if(type=="planned hdb_2"){
        remaining_lease=5
        values$building_cost<-values$building_cost+50000
      } else if(type=="planned office"){
        remaining_lease=1
        values$building_cost<-values$building_cost+500000
      }else if(type=="planned park"){
        remaining_lease=2
        values$building_cost<-values$building_cost+100000
      } else{
        showModal(dialogBox("strange shizzles happening"))
        remaining_lease=-1
      }
      values$land_use[values$land_use$grid_number==grid_number,]<-data.frame(grid_number=grid_number,type=type,remaining_lease=remaining_lease)
      print(values$land_use[values$land_use$grid_number==grid_number,])
      gridUpdater()
    }
  })
  
  
  #USE CASE 5 SELECTION CONFIRMATION
  observeEvent(input$build,{
    if(values$current_statistics$budget <values$building_cost){
      showModal(dialogBox("You do not have enough money"))
    }else if(values$current_statistics$budget >=values$building_cost){
      print("build started successfully")
      # loop through values$land_use. Replace all to_build objects with the appropriate construction site
      values$current_statistics$budget <- values$current_statistics$budget- values$building_cost
      values$building_cost<-0
      for (i in 1:nrow(values$land_use)){
        print(values$land_use[i,])
        if (values$land_use[i,"type"]=="planned hdb_1"){
          values$land_use[i,"type"]<-"construction hdb_1"
          values$land_use[i,"remaining lease"]<-3
        }else if(values$land_use[i,"type"]=="planned hdb_2"){
          values$land_use[i,"type"]<-"construction hdb_2"
          values$land_use[i,"remaining lease"]<-3
        }else if(values$land_use[i,"type"]=="planned office"){
          values$land_use[i,"type"]<-"construction office"
          values$land_use[i,"remaining lease"]<-3
        } else if(values$land_use[i,"type"]=="planned park"){
          values$land_use[i,"type"]<-"construction park"
          values$land_use[i,"remaining lease"]<-3
        }
      }
      gridUpdater()
    }
  })
  
  #USE CASE 6 TIME PROGRESS
  observeEvent(input$progress, {
    progressYears<- input$time
    print(paste0("started progressing ",progressYears," years"))
    for (i in 1:progressYears){
      values$current_statistics$year<-values$current_statistics$year+1
      progressBarUpdater()
      # increase values
      values$current_statistics$happiness<-7*values$current_statistics$happiness%/%10-10*values$current_statistics$homeless+5*values$current_statistics$employment%/%10+50*sum(values$land_use$type=="office building")
      values$current_statistics$budget<-values$current_statistics$budget-100*values$current_statistics$population+200*values$current_statistics$employment+10000*sum(values$land_use$type=="office building")
      
      values$current_statistics$population<-values$current_statistics$population+values$current_statistics$population%/%10
      
      # reduce leases
      values$land_use$remaining_lease<-values$land_use$remaining_lease -1
      # checking if change is needed
      for (i in 1:25){
        if (values$land_use$remaining_lease[i]==0){
          if (values$land_use$type[i]=="hdb_1" | values$land_use$type[i]=="hdb_2" | values$land_use$type[i]=="office" | values$land_use$type[i]=="park"){
            values$land_use$type[i]<-"demolition"
            values$land_use$remaining_lease[i]<-1  
          }else if (values$land_use$typ[i]=="demolition"){
            values$land_use$type[i]<-"empty"
          }else if (values$land_use$type[i]=="construction hdb_1"){
            values$land_use$type[i]<-"hdb_1"
            values$land_use$remaining_lease[i]<-99  
          }else if (values$land_use$type[i]=="construction hdb_2"){
            values$land_use$type[i]<-"hdb_2"
            values$land_use$remaining_lease[i]<-99  
          }else if (values$land_use$type[i]=="construction office"){
            values$land_use$type[i]<-"office"
            values$land_use$remaining_lease[i]<-10
          }else if (values$land_use$type[i]=="construction park"){
            values$land_use$type[i]<-"park"
            values$land_use$remaining_lease[i]<-5
          }
        }
        
      }
      gridUpdater()
      
      # update building related stats
      values$current_statistics$homelessness<-max(0,values$current_statistics$population-(200*sum(values$land_use$type=="hdb_1")+400*sum(values$land_use$type=="hdb_2")))
      values$current_statistics$employment<-min(values$current_statistics$population,50*sum(values$land_use$type=="office building"))
      print(values$current_statistics)
      # saves
      a=SaveCurrentLanduse(cbind(username=rep(values$username,25),values$land_use))
      print(a)
      saveGameStatistics(values$username,
                         values$current_statistics$year,
                         values$current_statistics$happiness,
                         values$current_statistics$budget,
                         values$current_statistics$population,
                         values$current_statistics$homelessness,
                         values$current_statistics$employment)
      print(values$current_statistics$happiness<=0 | values$current_statistics$budget<=0)
      if (values$current_statistics$happiness<=0 | values$current_statistics$budget<=0){
        goToGameOver(FALSE)
        return()
      }else if(values$current_statistics$year==999){
        goToGameOver(TRUE)
        return()
      }
    }
  })
  
  
  changeTab<- function(session){
    # insert function to change tab
    updateTabsetPanel(session,inputId="tabs",selected="Game Play")
    print("changed tab to Game Play")
    gridUpdater()
  }
  
  progressBarUpdater<-function(){
    print("hi u were supposed to have a progress bar ;)")
    # dialogBox("move year progress bar")
  }
  gridUpdater <- function(){
    # retrieve the values$land_use and update values$images[i]
    print("gridUpdater started")
    for (i in 1:25){
      land_use<-values$land_use$type[i]
      print(paste0(i," ",land_use))
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
      }else if(land_use=="demolition"){
        values$images[i]<-image_demolition
      }else{
        stop(paste0("Funky land use alert at row",i))
      }
      
    }
    # print(values$images)
  }
  
  goToGameOver<- function(winning){
    print("goToGameOver Started")
    if (!winning){
      showModal(dialogBox("U lost. Also need a game over"))
    }else{
      showModal(dialogBox("U win. Also need a game over"))
    }
  }
  
  
  
  
  
}

